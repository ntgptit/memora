from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "component-theme"
FILE_NAME = "tool/frontend_guard/guards/component_theme.py"
DESCRIPTION = "Feature UI and shared shells consume the centralized theme foundation."

RULE_NO_THEME_OF = "UI_MUST_NOT_USE_THEME_OF"
RULE_NO_INLINE_BUTTON_STYLE = "UI_MUST_NOT_BUILD_INLINE_BUTTON_STYLE"
RULE_NO_INLINE_INPUT_DECORATION = "UI_MUST_NOT_BUILD_INLINE_INPUT_DECORATION"

_THEME_OF_PATTERN = re.compile(r"\bTheme\.of\s*\(")
_BUTTON_STYLE_PATTERN = re.compile(r"\b(ButtonStyle\s*\(|\w+Button\.styleFrom\s*\()")
_INPUT_DECORATION_PATTERN = re.compile(r"\bInputDecoration\s*\(")
_SCAN_ROOTS = (
    "lib/presentation/features",
    "lib/presentation/shared/layouts",
    "lib/presentation/shared/screens",
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, _SCAN_ROOTS):
        violations.extend(_check_pattern(source_file, _THEME_OF_PATTERN, RULE_NO_THEME_OF, _theme_reason()))
        violations.extend(
            _check_pattern(
                source_file,
                _BUTTON_STYLE_PATTERN,
                RULE_NO_INLINE_BUTTON_STYLE,
                "Use shared button primitives and centralized component themes instead of inline ButtonStyle construction.",
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _INPUT_DECORATION_PATTERN,
                RULE_NO_INLINE_INPUT_DECORATION,
                "Use shared input primitives and the centralized InputDecoration theme instead of inline InputDecoration construction.",
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


def _theme_reason() -> str:
    return "Use BuildContext theme extensions such as context.theme, context.colorScheme, and context.textTheme instead of Theme.of."
