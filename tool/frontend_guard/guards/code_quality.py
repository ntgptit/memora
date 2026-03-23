from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "code-quality"
FILE_NAME = "tool/frontend_guard/guards/code_quality.py"
DESCRIPTION = "Basic code quality guard for presentation and theme layers."

RULE_FILE_TOO_LARGE = "FILE_TOO_LARGE"
RULE_NO_TODO_FIXME = "NO_TODO_OR_FIXME"

_MAX_LINES = 240
_TODO_PATTERN = re.compile(r"\b(TODO|FIXME)\b")
_SCAN_ROOTS = (
    "lib/presentation",
    "lib/core/theme",
    "tool/frontend_guard",
)
_NON_LOGIC_DIRECTIVE_PREFIXES = (
    "import ",
    "export ",
    "part ",
    "library ",
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, _SCAN_ROOTS):
        logical_line_count = _count_logical_lines(source_file.lines)
        if logical_line_count > _MAX_LINES:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_FILE_TOO_LARGE,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=1,
                    reason=f"Keep files under {_MAX_LINES} lines to preserve readability and reviewability.",
                    snippet=f"logical_lines={logical_line_count}",
                )
            )
        violations.extend(_check_todo(source_file))
    return violations


def _check_todo(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _TODO_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NO_TODO_FIXME,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Committed TODO/FIXME markers are forbidden in guarded layers.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _count_logical_lines(lines: list[str]) -> int:
    logical_line_count = 0
    inside_block_comment = False

    for raw_line in lines:
        stripped_line = raw_line.strip()
        if not stripped_line:
            continue

        if inside_block_comment:
            if "*/" in stripped_line:
                _, _, trailing = stripped_line.partition("*/")
                stripped_line = trailing.strip()
                inside_block_comment = False
                if not stripped_line:
                    continue
            else:
                continue

        while stripped_line.startswith("/*"):
            if "*/" in stripped_line:
                _, _, trailing = stripped_line.partition("*/")
                stripped_line = trailing.strip()
                if not stripped_line:
                    break
                continue

            inside_block_comment = True
            stripped_line = ""
            break

        if not stripped_line:
            continue

        if stripped_line.startswith("//"):
            continue

        if stripped_line.startswith(_NON_LOGIC_DIRECTIVE_PREFIXES):
            continue

        logical_line_count += 1

    return logical_line_count
