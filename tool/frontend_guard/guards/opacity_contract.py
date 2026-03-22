from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "opacity-contract"
FILE_NAME = "tool/frontend_guard/guards/opacity_contract.py"
DESCRIPTION = "Alpha values must flow through opacity tokens."

RULE_NO_WITH_OPACITY = "NO_WITH_OPACITY"
RULE_NO_NUMERIC_ALPHA = "NO_NUMERIC_ALPHA_LITERAL"

_WITH_OPACITY_PATTERN = re.compile(r"\bwithOpacity\s*\(")
_NUMERIC_ALPHA_PATTERN = re.compile(r"\bwithValues\s*\(\s*alpha\s*:\s*(0?\.\d+|1(?:\.0+)?)")
_ALLOWED_FILES = {
    "lib/core/theme/tokens/opacity_tokens.dart",
}


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib",)):
        if source_file.rel_path in _ALLOWED_FILES:
            continue
        violations.extend(_check_pattern(source_file, _WITH_OPACITY_PATTERN, RULE_NO_WITH_OPACITY))
        violations.extend(_check_pattern(source_file, _NUMERIC_ALPHA_PATTERN, RULE_NO_NUMERIC_ALPHA))
    return violations


def _check_pattern(source_file, pattern: re.Pattern[str], rule: str) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if pattern.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=rule,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Use AppOpacityTokens instead of inline alpha literals.",
                snippet=raw_line.strip(),
            )
        )
    return violations
