from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "l10n-usage"
FILE_NAME = "tool/frontend_guard/guards/l10n_usage.py"
DESCRIPTION = "No hardcoded user-facing literals in main/presentation UI."

RULE_TEXT_LITERAL = "L10N_NO_HARDCODED_TEXT_WIDGET_LITERAL"
RULE_NAMED_LITERAL = "L10N_NO_HARDCODED_NAMED_ARGUMENT_LITERAL"

_ALLOW_LITERAL_MARKER = "l10n-guard: allow-literal"
_TEXT_WIDGET_PATTERN = re.compile(r"\b(Text|SelectableText)\s*\(")
_INLINE_TEXT_LITERAL_PATTERN = re.compile(r"""\b(?:Text|SelectableText)\s*\(\s*(?:const\s+)?(['"]).+?\1""")
_STRING_ONLY_LINE_PATTERN = re.compile(r"""^\s*(?:const\s+)?(['"]).+?\1\s*,?\s*$""")
_NAMED_ARGUMENT_PATTERN = re.compile(
    r"""\b(label|labelText|hintText|helperText|errorText|tooltip|title|subtitle|text|semanticLabel|buttonLabel|message)\s*:\s*(?:const\s+)?(['"]).+?\2"""
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/presentation", "lib/main.dart")):
        violations.extend(_check_inline_text_literals(source_file))
        violations.extend(_check_multiline_text_literals(source_file))
        violations.extend(_check_named_argument_literals(source_file))
    return violations


def _check_inline_text_literals(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ALLOW_LITERAL_MARKER in raw_line:
            continue
        if _INLINE_TEXT_LITERAL_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_TEXT_LITERAL,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="User-facing text literals in Text/SelectableText are forbidden. Use AppStrings or localization resources.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_multiline_text_literals(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ALLOW_LITERAL_MARKER in raw_line:
            continue
        if _STRING_ONLY_LINE_PATTERN.search(raw_line) is None:
            continue
        if not _belongs_to_text_widget(source_file.lines, index - 1):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_TEXT_LITERAL,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="User-facing text literals in Text/SelectableText are forbidden. Use AppStrings or localization resources.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _belongs_to_text_widget(lines: list[str], current_index: int) -> bool:
    lookback_limit = max(-1, current_index - 3)
    for previous_index in range(current_index - 1, lookback_limit, -1):
        previous_line = lines[previous_index].strip()
        if previous_line == "":
            continue
        return _TEXT_WIDGET_PATTERN.search(previous_line) is not None
    return False


def _check_named_argument_literals(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ALLOW_LITERAL_MARKER in raw_line:
            continue
        if _NAMED_ARGUMENT_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NAMED_LITERAL,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="User-facing named argument literals are forbidden. Use AppStrings or localization resources.",
                snippet=raw_line.strip(),
            )
        )
    return violations
