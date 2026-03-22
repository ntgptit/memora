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


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, _SCAN_ROOTS):
        if len(source_file.lines) > _MAX_LINES:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_FILE_TOO_LARGE,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=1,
                    reason=f"Keep files under {_MAX_LINES} lines to preserve readability and reviewability.",
                    snippet=f"lines={len(source_file.lines)}",
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
