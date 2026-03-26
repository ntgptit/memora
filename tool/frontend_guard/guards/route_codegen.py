from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files, has_go_router_dependency


GUARD_ID = "route-codegen"
FILE_NAME = "tool/frontend_guard/guards/route_codegen.py"
DESCRIPTION = "GoRouter navigation must use generated typed route data instead of string-based locations."

RULE_ROUTER_REQUIRES_TYPED_ROUTE_GENERATION = "ROUTER_REQUIRES_GO_ROUTER_BUILDER_TYPED_ROUTES"
RULE_NO_STRING_BASED_NAVIGATION = "ROUTER_NO_STRING_BASED_NAVIGATION"

_GO_ROUTER_BUILDER_PATTERN = re.compile(r"^\s*go_router_builder\s*:", re.MULTILINE)
_TYPED_ROUTE_PATTERN = re.compile(r"@\s*Typed(?:GoRoute|StatefulShellRoute)\b")
_PART_G_PATTERN = re.compile(r"""^\s*part\s+['"][^'"]+\.g\.dart['"];""", re.MULTILINE)
_APP_ROUTES_PATTERN = re.compile(r"\broutes\s*:\s*\$appRoutes\b")
_APP_ROUTES_IMPORT_PATTERN = re.compile(r"""app_routes\.dart['"]""")
_CONTEXT_NAV_PATTERN = re.compile(r"\bcontext\.(?:go|push|goNamed|pushNamed|replace)\s*\(")
_GOROUTER_NAV_PATTERN = re.compile(
    r"\bGoRouter\.(?:of|maybeOf)\([^)]*\)\s*\?\?\s*.*"
)
_GOROUTER_DIRECT_NAV_PATTERN = re.compile(
    r"\bGoRouter\.(?:of|maybeOf)\([^)]*\)\.(?:go|push|goNamed|pushNamed|replace)\s*\("
)


def run(root: Path) -> list[Violation]:
    if not has_go_router_dependency(root):
        return []

    violations: list[Violation] = []
    violations.extend(_check_router_codegen_files(root))
    violations.extend(_check_no_string_navigation(root))
    return violations


def _check_router_codegen_files(root: Path) -> list[Violation]:
    violations: list[Violation] = []

    pubspec_file = root / "pubspec.yaml"
    pubspec_text = pubspec_file.read_text(encoding="utf-8") if pubspec_file.exists() else ""
    if _GO_ROUTER_BUILDER_PATTERN.search(pubspec_text) is None:
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_ROUTER_REQUIRES_TYPED_ROUTE_GENERATION,
                severity=SEVERITY_ERROR,
                file="pubspec.yaml",
                line=1,
                reason="Repos using go_router must include go_router_builder and generate typed route data.",
                snippet="go_router:",
            )
        )

    route_data_file = root / "lib" / "app" / "app_route_data.dart"
    if not route_data_file.exists():
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_ROUTER_REQUIRES_TYPED_ROUTE_GENERATION,
                severity=SEVERITY_ERROR,
                file="lib/app/app_route_data.dart",
                line=1,
                reason="Typed route definitions must live in lib/app/app_route_data.dart.",
                snippet="missing file",
            )
        )
        return violations

    route_text = route_data_file.read_text(encoding="utf-8")
    if _PART_G_PATTERN.search(route_text) is None or _TYPED_ROUTE_PATTERN.search(route_text) is None:
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_ROUTER_REQUIRES_TYPED_ROUTE_GENERATION,
                severity=SEVERITY_ERROR,
                file="lib/app/app_route_data.dart",
                line=1,
                reason="Typed route definitions must declare a generated part file and use @TypedGoRoute/@TypedStatefulShellRoute.",
                snippet=route_data_file.name,
            )
        )

    router_file = root / "lib" / "app" / "app_router.dart"
    if not router_file.exists():
        return violations

    router_text = router_file.read_text(encoding="utf-8")
    if _APP_ROUTES_PATTERN.search(router_text) is None:
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_ROUTER_REQUIRES_TYPED_ROUTE_GENERATION,
                severity=SEVERITY_ERROR,
                file="lib/app/app_router.dart",
                line=1,
                reason="GoRouter must use the generated $appRoutes list from go_router_builder.",
                snippet="GoRouter(",
            )
        )
    return violations


def _check_no_string_navigation(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib", "test")):
        if source_file.rel_path == "lib/app/app_route_data.dart":
            continue

        for index, raw_line in enumerate(source_file.lines, start=1):
            stripped = raw_line.strip()
            if _APP_ROUTES_IMPORT_PATTERN.search(raw_line):
                violations.append(
                    Violation(
                        guard_id=GUARD_ID,
                        rule=RULE_NO_STRING_BASED_NAVIGATION,
                        severity=SEVERITY_ERROR,
                        file=source_file.rel_path,
                        line=index,
                        reason="Do not import the legacy app_routes.dart table. Navigate with generated route data classes instead.",
                        snippet=stripped,
                    )
                )
                continue

            if _CONTEXT_NAV_PATTERN.search(raw_line) or _GOROUTER_DIRECT_NAV_PATTERN.search(raw_line):
                violations.append(
                    Violation(
                        guard_id=GUARD_ID,
                        rule=RULE_NO_STRING_BASED_NAVIGATION,
                        severity=SEVERITY_ERROR,
                        file=source_file.rel_path,
                        line=index,
                        reason="Use generated route data methods like SomeRouteData(...).go(context) or .push(context) instead of string-based context.go/context.push navigation.",
                        snippet=stripped,
                    )
                )
    return violations
