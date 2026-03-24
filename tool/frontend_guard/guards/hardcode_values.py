from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import (
    SEVERITY_ERROR,
    Violation,
    collect_source_files,
    is_ui_file,
)


GUARD_ID = "hardcode-values"
FILE_NAME = "tool/frontend_guard/guards/hardcode_values.py"
DESCRIPTION = "Inline numeric UI literals must route through tokens, theme extensions, or semantic named constants."

RULE_BOX_CONSTRAINT_LITERAL = "UI_NO_INLINE_BOX_CONSTRAINT_LITERAL"
RULE_ICON_SIZE_LITERAL = "UI_NO_INLINE_ICON_SIZE_LITERAL"
RULE_WIDGET_DIMENSION_LITERAL = "UI_NO_INLINE_WIDGET_DIMENSION_LITERAL"
RULE_WRAP_SPACING_LITERAL = "UI_NO_INLINE_WRAP_SPACING_LITERAL"
RULE_ELEVATION_LITERAL = "UI_NO_INLINE_ELEVATION_LITERAL"
RULE_STROKE_LITERAL = "UI_NO_INLINE_STROKE_LITERAL"

_ALLOW_LITERAL_MARKER = "hardcode-guard: allow-literal"
_BOX_CONSTRAINT_PATTERN = re.compile(r"\b(maxWidth|minWidth|maxHeight|minHeight)\s*:\s*\d")
_ICON_SIZE_PATTERN = re.compile(r"\bsize\s*:\s*\d")
_WIDGET_DIMENSION_PATTERN = re.compile(r"\b(width|height)\s*:\s*\d")
_WRAP_SPACING_PATTERN = re.compile(r"\b(runSpacing|spacing)\s*:\s*\d")
_ELEVATION_PATTERN = re.compile(r"\belevation\s*:\s*\d")
_STROKE_PATTERN = re.compile(r"\b(thickness|strokeWidth)\s*:\s*\d")

_BOX_CONSTRAINT_CONTEXT = re.compile(r"\bBoxConstraints\s*\(")
_ICON_CONTEXT = re.compile(r"\b(?:Icon|AppIcon|IconThemeData)\s*\(")
_WIDGET_DIMENSION_CONTEXT = re.compile(
    r"\b(?:SizedBox|SizedBox\.square|Container|ConstrainedBox|Card|SnackBar)\s*\("
)
_WRAP_CONTEXT = re.compile(r"\bWrap\s*\(")


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/presentation",)):
        if not is_ui_file(source_file.rel_path):
            continue
        violations.extend(_check_box_constraints(source_file))
        violations.extend(_check_icon_sizes(source_file))
        violations.extend(_check_widget_dimensions(source_file))
        violations.extend(_check_wrap_spacing(source_file))
        violations.extend(_check_elevation(source_file))
        violations.extend(_check_stroke(source_file))
    return violations


def _check_box_constraints(source_file) -> list[Violation]:
    return _check_with_context(
        source_file=source_file,
        line_pattern=_BOX_CONSTRAINT_PATTERN,
        context_pattern=_BOX_CONSTRAINT_CONTEXT,
        rule=RULE_BOX_CONSTRAINT_LITERAL,
        reason=(
            "Do not inline BoxConstraints dimensions in UI. Use context.layout/context.component for "
            "shared layout sizing, or extract a semantic named constant such as _authFormMaxWidth when the value is feature-specific."
        ),
    )


def _check_icon_sizes(source_file) -> list[Violation]:
    return _check_with_context(
        source_file=source_file,
        line_pattern=_ICON_SIZE_PATTERN,
        context_pattern=_ICON_CONTEXT,
        rule=RULE_ICON_SIZE_LITERAL,
        reason=(
            "Do not inline icon sizes in UI. Use context.iconSize when the value belongs to the design system, "
            "or extract a semantic named constant when the size is intentionally feature-specific."
        ),
    )


def _check_widget_dimensions(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ALLOW_LITERAL_MARKER in raw_line:
            continue
        if _WIDGET_DIMENSION_PATTERN.search(raw_line) is None:
            continue
        if _belongs_to_context(
            lines=source_file.lines,
            current_index=index - 1,
            context_pattern=_BOX_CONSTRAINT_CONTEXT,
        ):
            continue
        if not _belongs_to_context(
            lines=source_file.lines,
            current_index=index - 1,
            context_pattern=_WIDGET_DIMENSION_CONTEXT,
        ):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_WIDGET_DIMENSION_LITERAL,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason=(
                    "Do not inline widget width or height in UI. Use context.component/context.layout/context.spacing for "
                    "shared design-system sizing, or extract a semantic named constant when the dimension is local to the feature."
                ),
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_wrap_spacing(source_file) -> list[Violation]:
    return _check_with_context(
        source_file=source_file,
        line_pattern=_WRAP_SPACING_PATTERN,
        context_pattern=_WRAP_CONTEXT,
        rule=RULE_WRAP_SPACING_LITERAL,
        reason=(
            "Do not inline Wrap spacing in UI. Use context.spacing for design-system rhythm, or extract a semantic named constant when the gap is unique to one feature."
        ),
    )


def _check_elevation(source_file) -> list[Violation]:
    return _check_with_context(
        source_file=source_file,
        line_pattern=_ELEVATION_PATTERN,
        context_pattern=re.compile(r"\b(?:Card|SnackBar|Material)\s*\("),
        rule=RULE_ELEVATION_LITERAL,
        reason=(
            "Do not inline elevation in UI. Prefer centralized component themes or AppElevationTokens, and only fall back to a semantic named constant when the elevation is intentionally local."
        ),
    )


def _check_stroke(source_file) -> list[Violation]:
    return _check_with_context(
        source_file=source_file,
        line_pattern=_STROKE_PATTERN,
        context_pattern=re.compile(r"\b(?:CircularProgressIndicator|Divider|BorderSide)\s*\("),
        rule=RULE_STROKE_LITERAL,
        reason=(
            "Do not inline stroke or thickness values in UI. Use AppBorderTokens, component tokens, or a semantic named constant if the value is feature-specific."
        ),
    )


def _check_with_context(
    *,
    source_file,
    line_pattern: re.Pattern[str],
    context_pattern: re.Pattern[str],
    rule: str,
    reason: str,
) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ALLOW_LITERAL_MARKER in raw_line:
            continue
        if line_pattern.search(raw_line) is None:
            continue
        if not _belongs_to_context(
            lines=source_file.lines,
            current_index=index - 1,
            context_pattern=context_pattern,
        ):
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


def _belongs_to_context(
    *,
    lines: list[str],
    current_index: int,
    context_pattern: re.Pattern[str],
) -> bool:
    current_line = lines[current_index].strip()
    if context_pattern.search(current_line) is not None:
        return True

    lookback_limit = max(-1, current_index - 4)
    for previous_index in range(current_index - 1, lookback_limit, -1):
        previous_line = lines[previous_index].strip()
        if not previous_line:
            continue
        if context_pattern.search(previous_line) is not None:
            return True
    return False
