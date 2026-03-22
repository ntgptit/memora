from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "accessibility"
FILE_NAME = "tool/frontend_guard/guards/accessibility.py"
DESCRIPTION = "Accessibility baseline for tappable controls in presentation layers."

RULE_ICON_BUTTON_REQUIRES_TOOLTIP = "ICON_BUTTON_REQUIRES_TOOLTIP"
RULE_GESTURE_DETECTOR_REQUIRES_BEHAVIOR = "GESTURE_DETECTOR_REQUIRES_BEHAVIOR"

_ICON_BUTTON_PATTERN = re.compile(r"\bIconButton(?:\.\w+)?\s*\(")
_GESTURE_DETECTOR_PATTERN = re.compile(r"\bGestureDetector\s*\(")


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/presentation",)):
        violations.extend(_check_icon_buttons(source_file))
        violations.extend(_check_gesture_detectors(source_file))
    return violations


def _check_icon_buttons(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ICON_BUTTON_PATTERN.search(raw_line) is None:
            continue
        window = "\n".join(source_file.lines[index - 1 : index + 10])
        if "tooltip:" in window:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_ICON_BUTTON_REQUIRES_TOOLTIP,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Every IconButton in presentation layers must expose a tooltip for accessibility.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_gesture_detectors(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _GESTURE_DETECTOR_PATTERN.search(raw_line) is None:
            continue
        window = "\n".join(source_file.lines[index - 1 : index + 8])
        if "onTap:" not in window:
            continue
        if "behavior:" in window:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_GESTURE_DETECTOR_REQUIRES_BEHAVIOR,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Tappable GestureDetector instances must declare behavior explicitly for predictable hit testing.",
                snippet=raw_line.strip(),
            )
        )
    return violations
