from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "spacing-ownership"
FILE_NAME = "tool/frontend_guard/guards/spacing_ownership.py"
DESCRIPTION = "Feature UI and shared shells consume spacing through context tokens instead of raw numeric spacing."

RULE_NO_RAW_EDGE_INSETS = "UI_NO_RAW_EDGE_INSETS_LITERAL"
RULE_NO_RAW_SIZED_BOX = "UI_NO_RAW_SIZED_BOX_LITERAL"
RULE_NO_RAW_BORDER_RADIUS = "UI_NO_RAW_BORDER_RADIUS_LITERAL"

_RAW_EDGE_INSETS_PATTERN = re.compile(r"\bEdgeInsets\.(all|symmetric|only)\s*\(\s*\d")
_RAW_SIZED_BOX_PATTERN = re.compile(r"\bSizedBox\s*\(\s*(height|width)\s*:\s*\d")
_RAW_BORDER_RADIUS_PATTERN = re.compile(r"\bBorderRadius\.circular\s*\(\s*\d")
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
                _RAW_EDGE_INSETS_PATTERN,
                RULE_NO_RAW_EDGE_INSETS,
                "Use context.spacing, context.layout, or shared layout helpers instead of raw EdgeInsets literals. If the inset is feature-specific, extract a semantic named constant rather than leaving the number inline.",
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_SIZED_BOX_PATTERN,
                RULE_NO_RAW_SIZED_BOX,
                "Use context.spacing or shared spacing primitives for layout rhythm instead of raw SizedBox numbers. If the gap is intentionally feature-specific, extract a semantic named constant.",
            )
        )
        violations.extend(
            _check_pattern(
                source_file,
                _RAW_BORDER_RADIUS_PATTERN,
                RULE_NO_RAW_BORDER_RADIUS,
                "Use context.radius or radius tokens instead of raw BorderRadius values. Only extract a semantic named constant when the radius is intentionally local to one feature.",
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
