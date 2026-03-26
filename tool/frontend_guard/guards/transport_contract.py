from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "transport-contract"
FILE_NAME = "tool/frontend_guard/guards/transport_contract.py"
DESCRIPTION = "Transport parsers must bind a single canonical backend key per field."

RULE_NO_MULTI_KEY_JSON_FALLBACK = "TRANSPORT_NO_MULTI_KEY_JSON_FALLBACK"

_SCAN_ROOTS = (
    "lib/data/models",
    "lib/core/network",
    "lib/core/errors",
)
_MAP_LOOKUP_PATTERN = re.compile(r"""([A-Za-z_][A-Za-z0-9_]*)\s*\[\s*['"]([A-Za-z0-9_]+)['"]\s*\]""")
_CONTAINS_KEY_PATTERN = re.compile(
    r"""([A-Za-z_][A-Za-z0-9_]*)\.containsKey\(\s*['"]([A-Za-z0-9_]+)['"]\s*\)"""
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, _SCAN_ROOTS):
        violations.extend(_check_null_coalescing_fallback(source_file))
        violations.extend(_check_contains_key_fallback(source_file))
    return violations


def _check_null_coalescing_fallback(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if "??" not in raw_line:
            continue
        statement = _collect_expression_window(source_file.lines, index - 1)
        if not _has_multi_key_lookup(statement, _MAP_LOOKUP_PATTERN):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NO_MULTI_KEY_JSON_FALLBACK,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason=(
                    "Frontend transport parsing must read one canonical backend key only. "
                    "Do not keep legacy or snake_case alias fallback with ??; update the frontend contract instead."
                ),
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_contains_key_fallback(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if ".containsKey(" not in raw_line:
            continue
        statement = _collect_expression_window(source_file.lines, index - 1)
        if "?" not in statement or ":" not in statement:
            continue
        if not _has_multi_key_lookup(statement, _CONTAINS_KEY_PATTERN):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NO_MULTI_KEY_JSON_FALLBACK,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason=(
                    "Frontend transport parsing must not branch across multiple backend keys for the same field. "
                    "Use one canonical contract key and update the client model when the backend changes."
                ),
                snippet=raw_line.strip(),
            )
        )
    return violations


def _collect_expression_window(lines: list[str], start_index: int) -> str:
    parts: list[str] = []
    balance = 0
    for index in range(start_index, len(lines)):
        if index >= len(lines):
            break
        raw_line = lines[index].strip()
        if raw_line == "":
            continue
        parts.append(raw_line)
        balance += lines[index].count("(") - lines[index].count(")")
        if balance <= 0 and (raw_line.endswith(",") or raw_line.endswith(";")):
            break
    return " ".join(parts)


def _has_multi_key_lookup(statement: str, pattern: re.Pattern[str]) -> bool:
    keys_by_receiver: dict[str, set[str]] = {}
    for match in pattern.finditer(statement):
        receiver, key = match.groups()
        keys_by_receiver.setdefault(receiver, set()).add(key)
    return any(len(keys) > 1 for keys in keys_by_receiver.values())
