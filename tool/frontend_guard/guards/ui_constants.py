from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "ui-constants"
FILE_NAME = "tool/frontend_guard/guards/ui_constants.py"
DESCRIPTION = "Feature UI and shared shells must not inline raw UI constants that belong in core config or theme tokens."

RULE_NO_RAW_DURATION = "UI_NO_RAW_DURATION_LITERAL"
RULE_NO_RAW_COLOR = "UI_NO_RAW_COLOR_LITERAL"
RULE_NO_RAW_FONT_SIZE = "UI_NO_RAW_FONT_SIZE_LITERAL"

_RAW_DURATION_PATTERN = re.compile(r"\bDuration\s*\(\s*milliseconds\s*:\s*\d+")
_RAW_COLOR_PATTERN = re.compile(r"\b(Color\s*\(\s*0x[0-9A-Fa-f]+\)|Colors\.)")
_RAW_FONT_SIZE_PATTERN = re.compile(r"\bfontSize\s*:\s*\d")
_SCAN_ROOTS = (
    "lib/presentation/features",
    "lib/presentation/shared/layouts",
    "lib/presentation/shared/screens",
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, _SCAN_ROOTS):
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_DURATION_PATTERN,
                RULE_NO_RAW_DURATION,
                _duration_reason(source_file.rel_path),
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_COLOR_PATTERN,
                RULE_NO_RAW_COLOR,
                _color_reason(source_file.rel_path),
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_FONT_SIZE_PATTERN,
                RULE_NO_RAW_FONT_SIZE,
                _font_size_reason(source_file.rel_path),
            )
        )
    return violations


def _check_pattern(source_file, pattern: re.Pattern[str], rule: str, reason: str) -> list[Violation]:
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
                reason=reason,
                snippet=raw_line.strip(),
            )
        )
    return violations


def _duration_reason(rel_path: str) -> str:
    if rel_path.startswith("lib/core/theme/"):
        return "Move animation duration values into AppDuration or AppMotionTokens instead of leaving Duration literals inline in theme code."
    return "Use AppDuration or AppMotionTokens instead of inline Duration literals. If the duration is intentionally local to one feature, extract a semantic named constant."


def _color_reason(rel_path: str) -> str:
    if rel_path.startswith("lib/core/theme/"):
        return "Use AppColorTokens, ColorScheme, or theme extensions instead of raw color literals in theme foundation code."
    return "Use context.colorScheme, shared theme extensions, or color tokens instead of raw color literals in UI code."


def _font_size_reason(rel_path: str) -> str:
    if rel_path.startswith("lib/core/theme/"):
        return "Use AppTypographyTokens instead of inline fontSize values in theme foundation code."
    return "Use shared text primitives, context.textTheme, or typography tokens instead of inline fontSize values in UI code."
