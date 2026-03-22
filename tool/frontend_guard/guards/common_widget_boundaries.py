from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "common-widget-boundaries"
FILE_NAME = "tool/frontend_guard/guards/common_widget_boundaries.py"
DESCRIPTION = "Shared widget layers follow Memora primitive/composite/layout/screen boundaries."

RULE_SHARED_UI_NO_FEATURE_IMPORT = "SHARED_UI_NO_FEATURE_IMPORT"
RULE_PRIMITIVE_LAYER_BOUNDARY = "PRIMITIVE_LAYER_BOUNDARY"
RULE_COMPOSITE_LAYER_BOUNDARY = "COMPOSITE_LAYER_BOUNDARY"
RULE_LAYOUT_LAYER_BOUNDARY = "LAYOUT_LAYER_BOUNDARY"
RULE_SHARED_SCREEN_LAYER_BOUNDARY = "SHARED_SCREEN_LAYER_BOUNDARY"
RULE_SHARED_UI_NO_THROW = "SHARED_UI_NO_THROW"

_IMPORT_PATTERN = re.compile(r"""^\s*import\s+['"]([^'"]+)['"];""", re.MULTILINE)
_THROW_PATTERN = re.compile(r"\bthrow\b")

_LAYER_RULES = {
    "primitives": (
        RULE_PRIMITIVE_LAYER_BOUNDARY,
        (
            "/presentation/shared/composites/",
            "/presentation/shared/layouts/",
            "/presentation/shared/screens/",
            "/presentation/features/",
        ),
        "Shared primitives may depend only on core and other shared primitives.",
    ),
    "composites": (
        RULE_COMPOSITE_LAYER_BOUNDARY,
        (
            "/presentation/shared/layouts/",
            "/presentation/shared/screens/",
            "/presentation/features/",
        ),
        "Shared composites may compose primitives but must not depend on layouts, shared screens, or feature UI.",
    ),
    "layouts": (
        RULE_LAYOUT_LAYER_BOUNDARY,
        ("/presentation/features/",),
        "Shared layouts must stay feature-agnostic.",
    ),
    "screens": (
        RULE_SHARED_SCREEN_LAYER_BOUNDARY,
        ("/presentation/features/",),
        "Shared system screens must stay feature-agnostic.",
    ),
}


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/presentation/shared",)):
        violations.extend(_check_imports(source_file))
        violations.extend(_check_throw_usage(source_file))
    return violations


def _check_imports(source_file) -> list[Violation]:
    violations: list[Violation] = []
    layer = _shared_layer(source_file.rel_path)
    for match in _IMPORT_PATTERN.finditer(source_file.text):
        import_path = match.group(1)
        line = source_file.text.count("\n", 0, match.start()) + 1
        if "/presentation/features/" in import_path:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_SHARED_UI_NO_FEATURE_IMPORT,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=line,
                    reason="Shared UI must remain reusable and must not depend on feature UI packages.",
                    snippet=import_path,
                )
            )
        if layer not in _LAYER_RULES:
            continue
        rule, forbidden_markers, reason = _LAYER_RULES[layer]
        if not any(marker in import_path for marker in forbidden_markers):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=rule,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=line,
                reason=reason,
                snippet=import_path,
            )
        )
    return violations


def _check_throw_usage(source_file) -> list[Violation]:
    layer = _shared_layer(source_file.rel_path)
    if layer not in _LAYER_RULES:
        return []

    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _THROW_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_SHARED_UI_NO_THROW,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Shared UI should render explicit states instead of throwing.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _shared_layer(path: str) -> str:
    for layer in _LAYER_RULES:
        if f"/{layer}/" in path:
            return layer
    return ""
