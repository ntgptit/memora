from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import (
    SEVERITY_ERROR,
    Violation,
    collect_source_files,
    has_go_router_dependency,
)


GUARD_ID = "navigation"
FILE_NAME = "tool/frontend_guard/guards/navigation.py"
DESCRIPTION = "go_router contract and navigation API boundaries."

RULE_GO_ROUTER_DEPENDENCY = "GO_ROUTER_DEPENDENCY_REQUIRED"
RULE_NAVIGATOR_FORBIDDEN = "NAVIGATION_MUST_NOT_USE_NAVIGATOR"
RULE_MATERIAL_PAGE_ROUTE_FORBIDDEN = "NAVIGATION_MUST_NOT_USE_MATERIAL_PAGE_ROUTE"
RULE_ON_GENERATE_ROUTE_FORBIDDEN = "NAVIGATION_MUST_NOT_USE_ON_GENERATE_ROUTE"
RULE_STRING_PATH_NAVIGATION = "NAVIGATION_NO_STRING_PATH_USAGE"

_NAVIGATOR_PATTERN = re.compile(r"\bNavigator\.")
_MATERIAL_PAGE_ROUTE_PATTERN = re.compile(r"\bMaterialPageRoute\s*(?:<[^>]+>)?\s*\(")
_ON_GENERATE_ROUTE_PATTERN = re.compile(r"\bonGenerateRoute\b")
_STRING_PATH_NAVIGATION_PATTERN = re.compile(r"""\bcontext\.(go|push|replace)\s*\(\s*['"]/""")


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    if not has_go_router_dependency(root):
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_GO_ROUTER_DEPENDENCY,
                severity=SEVERITY_ERROR,
                file="pubspec.yaml",
                line=1,
                reason="go_router dependency is required for app navigation.",
                snippet="go_router:",
            )
        )

    for source_file in collect_source_files(root, ("lib",)):
        violations.extend(_check_file(source_file))
    return violations


def _check_file(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        stripped = raw_line.strip()
        if _NAVIGATOR_PATTERN.search(stripped) is not None:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_NAVIGATOR_FORBIDDEN,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=index,
                    reason="Navigator.* is forbidden. Use go_router based app routing.",
                    snippet=stripped,
                )
            )
        if _MATERIAL_PAGE_ROUTE_PATTERN.search(stripped) is not None:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_MATERIAL_PAGE_ROUTE_FORBIDDEN,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=index,
                    reason="MaterialPageRoute is forbidden. Route changes must go through go_router.",
                    snippet=stripped,
                )
            )
        if _ON_GENERATE_ROUTE_PATTERN.search(stripped) is not None:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_ON_GENERATE_ROUTE_FORBIDDEN,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=index,
                    reason="onGenerateRoute is forbidden. Keep route configuration centralized in app_router.",
                    snippet=stripped,
                )
            )
        if _STRING_PATH_NAVIGATION_PATTERN.search(stripped) is not None:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_STRING_PATH_NAVIGATION,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=index,
                    reason="String path navigation is forbidden. Use app route constants or wrappers instead of raw '/path' literals.",
                    snippet=stripped,
                )
            )
    return violations
