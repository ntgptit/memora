from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "ui-design"
FILE_NAME = "tool/frontend_guard/guards/ui_design.py"
DESCRIPTION = "Feature UI should consume shared design-system widgets instead of raw Material counterparts."

RULE_NO_RAW_BUTTONS = "FEATURE_UI_NO_RAW_BUTTON_WIDGET"
RULE_NO_RAW_INPUTS = "FEATURE_UI_NO_RAW_INPUT_WIDGET"
RULE_NO_RAW_SELECTIONS = "FEATURE_UI_NO_RAW_SELECTION_WIDGET"
RULE_NO_RAW_FEEDBACK = "FEATURE_UI_NO_RAW_FEEDBACK_WIDGET"
RULE_NO_RAW_DISPLAYS = "FEATURE_UI_NO_RAW_DISPLAY_WIDGET"

_RAW_BUTTON_PATTERN = re.compile(
    r"\b(ElevatedButton|OutlinedButton|TextButton|IconButton|FloatingActionButton)\b"
)
_RAW_INPUT_PATTERN = re.compile(
    r"\b(TextField|TextFormField|DropdownButton|DropdownButtonFormField)\b"
)
_RAW_SELECTION_PATTERN = re.compile(r"\b(Checkbox|Radio|Switch|Slider)\b")
_RAW_FEEDBACK_PATTERN = re.compile(
    r"\b(SnackBar|ScaffoldMessenger|CircularProgressIndicator|LinearProgressIndicator)\b"
)
_RAW_DISPLAY_PATTERN = re.compile(r"\b(Card|Chip|Divider|VerticalDivider)\b")


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/presentation/features",)):
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_BUTTON_PATTERN,
                RULE_NO_RAW_BUTTONS,
                "Use shared button primitives from presentation/shared/primitives/buttons instead of raw Material buttons in feature UI.",
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_INPUT_PATTERN,
                RULE_NO_RAW_INPUTS,
                "Use shared input primitives from presentation/shared/primitives/inputs instead of raw Material inputs in feature UI.",
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_SELECTION_PATTERN,
                RULE_NO_RAW_SELECTIONS,
                "Use shared selection primitives from presentation/shared/primitives/selections instead of raw Material selection widgets in feature UI.",
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_FEEDBACK_PATTERN,
                RULE_NO_RAW_FEEDBACK,
                "Use shared feedback primitives and listeners instead of raw Material feedback widgets in feature UI.",
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_DISPLAY_PATTERN,
                RULE_NO_RAW_DISPLAYS,
                "Use shared display primitives from presentation/shared/primitives/displays instead of raw Material display widgets in feature UI.",
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
