#!/usr/bin/env python3
"""
Frontend checklist guard for Memora Flutter frontend client.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


RULE_REQUIRED_APP_BOOTSTRAP_FILES = "REQUIRED_APP_BOOTSTRAP_FILES_EXIST"
RULE_REQUIRED_FRONTEND_STRUCTURE = "REQUIRED_FRONTEND_STRUCTURE_EXISTS"
RULE_REQUIRED_THEME_STRUCTURE = "REQUIRED_THEME_STRUCTURE_EXISTS"
RULE_REQUIRED_L10N_BUNDLES = "REQUIRED_L10N_BUNDLES_EXIST"
RULE_REQUIRED_RUNTIME_DEPENDENCIES = "REQUIRED_RUNTIME_DEPENDENCIES_PRESENT"
RULE_REQUIRED_DEV_DEPENDENCIES = "REQUIRED_DEV_DEPENDENCIES_PRESENT"
RULE_GENERATED_FILES_IGNORED = "GENERATED_FILES_ARE_GITIGNORED"
RULE_NO_MANUAL_PROVIDER_DECLARATION = "NO_MANUAL_RIVERPOD_PROVIDER_DECLARATION"
RULE_RIVERPOD_PART_DIRECTIVE = "RIVERPOD_ANNOTATED_FILE_HAS_PART_DIRECTIVE"
RULE_UI_NO_PROVIDER_DECLARATION = "UI_LAYER_NO_PROVIDER_DECLARATION"
RULE_UI_NO_DATA_OR_NETWORK_IMPORT = "UI_LAYER_NO_DATA_OR_NETWORK_IMPORT"
RULE_NAVIGATION_USES_GO_ROUTER = "NAVIGATION_MUST_USE_GO_ROUTER"
RULE_SHARED_WIDGETS_NO_NAVIGATION = "SHARED_WIDGETS_NO_NAVIGATION"
RULE_PRESENTATION_AVOID_RAW_THEME_ACCESS = "PRESENTATION_AVOID_RAW_THEME_ACCESS"

SEVERITY_ERROR = "ERROR"
SEVERITY_WARNING = "WARN"

REPORT_FILE = "frontend_guard_report.json"
DART_EXTENSION = ".dart"

MANUAL_PROVIDER_PATTERN = re.compile(
    r"\b(Provider|StateProvider|FutureProvider|StreamProvider|"
    r"ChangeNotifierProvider|StateNotifierProvider|NotifierProvider|"
    r"AsyncNotifierProvider)\s*(<|\()"
)
RIVERPOD_ANNOTATION_PATTERN = re.compile(r"@\s*(riverpod|Riverpod)\b")
IMPORT_PATTERN = re.compile(r"""^\s*import\s+['"]([^'"]+)['"];""", re.MULTILINE)
NAVIGATOR_PATTERN = re.compile(r"Navigator\.of\s*\(|MaterialPageRoute\s*\(|onGenerateRoute\b")
SHARED_NAVIGATION_PATTERN = re.compile(
    r"Navigator\.of\s*\(|GoRouter\.of\s*\(|context\.(go|push|replace|pop)\s*\("
)
RAW_THEME_PATTERN = re.compile(
    r"Theme\.of\s*\(|TextTheme\.of\s*\(|ColorScheme\.of\s*\(|"
    r"styleFrom\s*\(|ButtonStyle\s*\("
)
TOP_LEVEL_YAML_SECTION_PATTERN = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)\s*:\s*$")
YAML_KEY_PATTERN = re.compile(r"^(\s+)([A-Za-z_][A-Za-z0-9_]*)\s*:\s*(.*)$")

REQUIRED_APP_PATHS = (
    "lib/main.dart",
    "lib/app/app.dart",
    "lib/app/app_router.dart",
    "lib/app/app_routes.dart",
    "lib/app/app_providers.dart",
    "lib/app/app_initializer.dart",
    "lib/app/app_lifecycle_handler.dart",
)

REQUIRED_FRONTEND_PATHS = (
    "lib/app",
    "lib/core",
    "lib/core/config",
    "lib/core/theme",
    "lib/core/di",
    "lib/presentation",
    "lib/presentation/shared",
    "lib/presentation/shared/primitives",
    "lib/presentation/shared/composites",
    "lib/presentation/features",
    "lib/data",
    "lib/domain",
    "lib/l10n",
)

REQUIRED_THEME_PATHS = (
    "lib/core/theme/tokens",
    "lib/core/theme/responsive",
    "lib/core/theme/extensions",
    "lib/core/theme/component_themes",
    "lib/core/theme/app_color_scheme.dart",
    "lib/core/theme/app_text_theme.dart",
    "lib/core/theme/app_theme.dart",
    "lib/core/theme/theme_helpers.dart",
)

REQUIRED_L10N_PATHS = (
    "lib/l10n/app_en.arb",
    "lib/l10n/app_vi.arb",
    "lib/l10n/app_ko.arb",
    "lib/l10n/l10n.dart",
)

REQUIRED_RUNTIME_DEPENDENCIES = (
    "flutter_riverpod",
    "riverpod_annotation",
    "go_router",
    "dio",
    "retrofit",
    "freezed_annotation",
    "json_annotation",
    "flutter_secure_storage",
    "shared_preferences",
    "connectivity_plus",
    "flutter_localizations",
    "intl",
)

REQUIRED_DEV_DEPENDENCIES = (
    "build_runner",
    "riverpod_generator",
    "retrofit_generator",
    "json_serializable",
    "freezed",
    "custom_lint",
    "yaml",
)

PROJECT_RULES = {
    RULE_REQUIRED_APP_BOOTSTRAP_FILES,
    RULE_REQUIRED_FRONTEND_STRUCTURE,
    RULE_REQUIRED_THEME_STRUCTURE,
    RULE_REQUIRED_L10N_BUNDLES,
    RULE_REQUIRED_RUNTIME_DEPENDENCIES,
    RULE_REQUIRED_DEV_DEPENDENCIES,
    RULE_GENERATED_FILES_IGNORED,
}


@dataclass(frozen=True)
class Violation:
    rule: str
    severity: str
    file: str
    line: int
    reason: str
    snippet: str

    def to_console(self) -> str:
        return f"{self.file}:{self.line}: [{self.severity}] {self.rule} - {self.reason} :: {self.snippet}"


@dataclass(frozen=True)
class FileContext:
    path: Path
    rel_path: str
    text: str
    lines: list[str]

    @property
    def file_name(self) -> str:
        return self.path.name

    @property
    def file_stem(self) -> str:
        return self.path.stem


class Rule:
    name: str

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        raise NotImplementedError


class NoManualProviderDeclarationRule(Rule):
    name = RULE_NO_MANUAL_PROVIDER_DECLARATION

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if MANUAL_PROVIDER_PATTERN.search(raw) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Use Riverpod annotation generated providers instead of manual provider declarations.",
                    snippet=raw.strip(),
                )
            )
        return violations


class RiverpodPartDirectiveRule(Rule):
    name = RULE_RIVERPOD_PART_DIRECTIVE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if RIVERPOD_ANNOTATION_PATTERN.search(file_ctx.text) is None:
            return []

        expected_part = f"part '{file_ctx.file_stem}.g.dart';"
        if expected_part in file_ctx.text:
            return []

        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=1,
                reason="Files with @riverpod or @Riverpod must declare the generated part directive.",
                snippet=expected_part,
            )
        ]


class UiLayerNoProviderDeclarationRule(Rule):
    name = RULE_UI_NO_PROVIDER_DECLARATION

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not _is_ui_file(file_ctx.rel_path):
            return []

        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if RIVERPOD_ANNOTATION_PATTERN.search(raw) is None and MANUAL_PROVIDER_PATTERN.search(raw) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="UI files must not declare providers or Riverpod notifiers.",
                    snippet=raw.strip(),
                )
            )
        return violations


class UiLayerNoDataOrNetworkImportRule(Rule):
    name = RULE_UI_NO_DATA_OR_NETWORK_IMPORT

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not _is_ui_file(file_ctx.rel_path):
            return []

        violations: list[Violation] = []
        for match in IMPORT_PATTERN.finditer(file_ctx.text):
            import_path = match.group(1)
            if not _is_forbidden_ui_import(import_path):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=_line_for_offset(file_ctx.lines, match.start()),
                    reason="UI files must stay render-only and must not import data, network, service, or IO layers directly.",
                    snippet=import_path,
                )
            )
        return violations


class NavigationUsesGoRouterRule(Rule):
    name = RULE_NAVIGATION_USES_GO_ROUTER

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if NAVIGATOR_PATTERN.search(raw) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Use go_router app routing instead of Navigator or MaterialPageRoute APIs.",
                    snippet=raw.strip(),
                )
            )
        return violations


class SharedWidgetsNoNavigationRule(Rule):
    name = RULE_SHARED_WIDGETS_NO_NAVIGATION

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not _is_shared_widget_file(file_ctx.rel_path):
            return []

        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if SHARED_NAVIGATION_PATTERN.search(raw) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Shared widgets must remain navigation-free render components.",
                    snippet=raw.strip(),
                )
            )
        return violations


class PresentationAvoidRawThemeAccessRule(Rule):
    name = RULE_PRESENTATION_AVOID_RAW_THEME_ACCESS

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not file_ctx.rel_path.startswith("lib/presentation/"):
            return []

        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if RAW_THEME_PATTERN.search(raw) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Prefer centralized theme/context extensions over raw Theme.of or local Material style overrides in presentation code.",
                    snippet=raw.strip(),
                )
            )
        return violations


def _default_rules() -> list[Rule]:
    return [
        NoManualProviderDeclarationRule(),
        RiverpodPartDirectiveRule(),
        UiLayerNoProviderDeclarationRule(),
        UiLayerNoDataOrNetworkImportRule(),
        NavigationUsesGoRouterRule(),
        SharedWidgetsNoNavigationRule(),
        PresentationAvoidRawThemeAccessRule(),
    ]


def _project_rule_names() -> set[str]:
    return PROJECT_RULES


def _project_violations(root: Path, pubspec_text: str, selected_rule_names: set[str]) -> list[Violation]:
    should_run_all = len(selected_rule_names) == 0
    violations: list[Violation] = []
    dependency_sections, section_line_numbers = _parse_pubspec_sections(pubspec_text)

    if should_run_all or RULE_REQUIRED_APP_BOOTSTRAP_FILES in selected_rule_names:
        violations.extend(
            _check_required_paths(
                root=root,
                rule_name=RULE_REQUIRED_APP_BOOTSTRAP_FILES,
                paths=REQUIRED_APP_PATHS,
                reason_prefix="App bootstrap contract violation.",
            )
        )

    if should_run_all or RULE_REQUIRED_FRONTEND_STRUCTURE in selected_rule_names:
        violations.extend(
            _check_required_paths(
                root=root,
                rule_name=RULE_REQUIRED_FRONTEND_STRUCTURE,
                paths=REQUIRED_FRONTEND_PATHS,
                reason_prefix="Frontend structure contract violation.",
            )
        )

    if should_run_all or RULE_REQUIRED_THEME_STRUCTURE in selected_rule_names:
        violations.extend(
            _check_required_paths(
                root=root,
                rule_name=RULE_REQUIRED_THEME_STRUCTURE,
                paths=REQUIRED_THEME_PATHS,
                reason_prefix="Theme foundation contract violation.",
            )
        )

    if should_run_all or RULE_REQUIRED_L10N_BUNDLES in selected_rule_names:
        violations.extend(
            _check_required_paths(
                root=root,
                rule_name=RULE_REQUIRED_L10N_BUNDLES,
                paths=REQUIRED_L10N_PATHS,
                reason_prefix="Localization contract violation.",
            )
        )

    if should_run_all or RULE_REQUIRED_RUNTIME_DEPENDENCIES in selected_rule_names:
        violations.extend(
            _check_required_dependencies(
                rule_name=RULE_REQUIRED_RUNTIME_DEPENDENCIES,
                section_name="dependencies",
                dependencies=REQUIRED_RUNTIME_DEPENDENCIES,
                dependency_sections=dependency_sections,
                section_line_numbers=section_line_numbers,
            )
        )

    if should_run_all or RULE_REQUIRED_DEV_DEPENDENCIES in selected_rule_names:
        violations.extend(
            _check_required_dependencies(
                rule_name=RULE_REQUIRED_DEV_DEPENDENCIES,
                section_name="dev_dependencies",
                dependencies=REQUIRED_DEV_DEPENDENCIES,
                dependency_sections=dependency_sections,
                section_line_numbers=section_line_numbers,
            )
        )

    if should_run_all or RULE_GENERATED_FILES_IGNORED in selected_rule_names:
        violations.extend(_check_generated_files_ignored(root))

    return violations


def _check_required_paths(root: Path, rule_name: str, paths: Iterable[str], reason_prefix: str) -> list[Violation]:
    violations: list[Violation] = []
    for relative_path in paths:
        target = root / Path(relative_path)
        if target.exists():
            continue
        violations.append(
            Violation(
                rule=rule_name,
                severity=SEVERITY_ERROR,
                file=relative_path,
                line=1,
                reason=f'{reason_prefix} Missing required path "{relative_path}".',
                snippet=relative_path,
            )
        )
    return violations


def _check_required_dependencies(
    rule_name: str,
    section_name: str,
    dependencies: Iterable[str],
    dependency_sections: dict[str, dict[str, int]],
    section_line_numbers: dict[str, int],
) -> list[Violation]:
    existing = dependency_sections.get(section_name, {})
    default_line = section_line_numbers.get(section_name, 1)
    violations: list[Violation] = []
    for dependency in dependencies:
        if dependency in existing:
            continue
        violations.append(
            Violation(
                rule=rule_name,
                severity=SEVERITY_ERROR,
                file="pubspec.yaml",
                line=default_line,
                reason=f'Required dependency "{dependency}" is missing from {section_name}.',
                snippet=dependency,
            )
        )
    return violations


def _check_generated_files_ignored(root: Path) -> list[Violation]:
    gitignore = root / ".gitignore"
    if not gitignore.exists():
        return [
            Violation(
                rule=RULE_GENERATED_FILES_IGNORED,
                severity=SEVERITY_ERROR,
                file=".gitignore",
                line=1,
                reason="Missing .gitignore for generated frontend artifacts.",
                snippet=".gitignore",
            )
        ]

    content = gitignore.read_text(encoding="utf-8")
    lines = content.splitlines()
    required_patterns = ("*.g.dart", "*.freezed.dart", "frontend_guard_report.json")
    violations: list[Violation] = []
    for pattern in required_patterns:
        if any(line.strip() == pattern for line in lines):
            continue
        violations.append(
            Violation(
                rule=RULE_GENERATED_FILES_IGNORED,
                severity=SEVERITY_ERROR,
                file=".gitignore",
                line=1,
                reason=f'Generated file pattern "{pattern}" must be ignored.',
                snippet=pattern,
            )
        )
    return violations


def _parse_pubspec_sections(text: str) -> tuple[dict[str, dict[str, int]], dict[str, int]]:
    sections: dict[str, dict[str, int]] = {
        "dependencies": {},
        "dev_dependencies": {},
    }
    section_line_numbers: dict[str, int] = {}

    current_section: str | None = None
    entry_indent: int | None = None
    for line_number, raw in enumerate(text.splitlines(), start=1):
        stripped = raw.strip()
        if stripped == "" or stripped.startswith("#"):
            continue

        top_level_match = TOP_LEVEL_YAML_SECTION_PATTERN.match(raw)
        if top_level_match is not None and not raw[0].isspace():
            section_name = top_level_match.group(1)
            if section_name in sections:
                current_section = section_name
                entry_indent = None
                section_line_numbers[section_name] = line_number
            else:
                current_section = None
                entry_indent = None
            continue

        if current_section is None:
            continue

        key_match = YAML_KEY_PATTERN.match(raw)
        if key_match is None:
            continue

        indent = len(key_match.group(1))
        if entry_indent is None:
            entry_indent = indent
        if indent != entry_indent:
            continue

        dependency_name = key_match.group(2)
        sections[current_section][dependency_name] = line_number

    return sections, section_line_numbers


def _collect_dart_files(root: Path) -> list[FileContext]:
    lib_root = root / "lib"
    contexts: list[FileContext] = []

    for path in sorted(lib_root.rglob(f"*{DART_EXTENSION}")):
        relative = path.relative_to(root).as_posix()
        if relative.endswith(".g.dart") or relative.endswith(".freezed.dart"):
            continue
        text = path.read_text(encoding="utf-8")
        contexts.append(
            FileContext(
                path=path,
                rel_path=relative,
                text=text,
                lines=text.splitlines(),
            )
        )
    return contexts


def _is_ui_file(relative_path: str) -> bool:
    if not relative_path.startswith("lib/presentation/"):
        return False

    return any(
        marker in relative_path
        for marker in (
            "/screens/",
            "/widgets/",
            "/layouts/",
            "/primitives/",
            "/composites/",
        )
    )


def _is_shared_widget_file(relative_path: str) -> bool:
    return relative_path.startswith("lib/presentation/shared/primitives/") or relative_path.startswith(
        "lib/presentation/shared/composites/"
    )


def _is_forbidden_ui_import(import_path: str) -> bool:
    if import_path in {"dart:io", "dart:convert", "package:dio/dio.dart", "package:retrofit/retrofit.dart"}:
        return True

    return any(
        marker in import_path
        for marker in (
            "/core/network/",
            "/data/",
            "/datasources/",
            "/repositories/",
            "/services/",
        )
    )


def _line_for_offset(lines: list[str], offset: int) -> int:
    running = 0
    for index, line in enumerate(lines, start=1):
        running += len(line) + 1
        if offset < running:
            return index
    return 1 if not lines else len(lines)


def _write_report(root: Path, violations: list[Violation]) -> None:
    payload = {
        "summary": {
            "total": len(violations),
            "errors": sum(1 for item in violations if item.severity == SEVERITY_ERROR),
            "warnings": sum(1 for item in violations if item.severity == SEVERITY_WARNING),
        },
        "violations": [
            {
                "rule": item.rule,
                "severity": item.severity,
                "file": item.file,
                "line": item.line,
                "reason": item.reason,
                "snippet": item.snippet,
            }
            for item in violations
        ],
    }
    (root / REPORT_FILE).write_text(json.dumps(payload, ensure_ascii=True, indent=2), encoding="utf-8")


def _print_summary(violations: list[Violation]) -> None:
    if not violations:
        print("Frontend checklist guard passed.")
        return

    errors = sum(1 for item in violations if item.severity == SEVERITY_ERROR)
    warnings = sum(1 for item in violations if item.severity == SEVERITY_WARNING)
    if errors > 0:
        print(f"Frontend checklist guard failed. errors={errors}, warnings={warnings}")
    else:
        print(f"Frontend checklist guard completed with warnings. warnings={warnings}")

    for item in violations:
        print(item.to_console())


def _rule_group_aliases() -> dict[str, set[str]]:
    return {
        "structure": {
            RULE_REQUIRED_APP_BOOTSTRAP_FILES,
            RULE_REQUIRED_FRONTEND_STRUCTURE,
            RULE_REQUIRED_THEME_STRUCTURE,
            RULE_REQUIRED_L10N_BUNDLES,
        },
        "deps": {
            RULE_REQUIRED_RUNTIME_DEPENDENCIES,
            RULE_REQUIRED_DEV_DEPENDENCIES,
            RULE_GENERATED_FILES_IGNORED,
        },
        "state": {
            RULE_NO_MANUAL_PROVIDER_DECLARATION,
            RULE_RIVERPOD_PART_DIRECTIVE,
            RULE_UI_NO_PROVIDER_DECLARATION,
        },
        "ui": {
            RULE_UI_NO_DATA_OR_NETWORK_IMPORT,
            RULE_PRESENTATION_AVOID_RAW_THEME_ACCESS,
        },
        "navigation": {
            RULE_NAVIGATION_USES_GO_ROUTER,
            RULE_SHARED_WIDGETS_NO_NAVIGATION,
        },
        "theme": {
            RULE_REQUIRED_THEME_STRUCTURE,
            RULE_PRESENTATION_AVOID_RAW_THEME_ACCESS,
        },
    }


def _parse_only_filters(raw_value: str) -> set[str]:
    if raw_value.strip() == "":
        return set()
    return {token.strip() for token in raw_value.split(",") if token.strip() != ""}


def _resolve_selected_rule_names(only_filters: set[str]) -> set[str]:
    groups = _rule_group_aliases()
    selected: set[str] = set()
    for token in only_filters:
        if token in groups:
            selected.update(groups[token])
            continue
        selected.add(token)
    return selected


def _filter_rules(rules: list[Rule], only_filters: set[str]) -> list[Rule]:
    if not only_filters:
        return rules
    selected = _resolve_selected_rule_names(only_filters)
    return [rule for rule in rules if rule.name in selected]


def main() -> int:
    parser = argparse.ArgumentParser(description="Memora Flutter frontend checklist guard.")
    parser.add_argument("--root", default=".", help="Project root directory. Default: current directory.")
    parser.add_argument(
        "--only",
        default="",
        help="Run only selected rule ids or rule groups (comma separated). Example: --only=state",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Fail when warning violations exist.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    pubspec_file = root / "pubspec.yaml"
    if not pubspec_file.exists():
        print("Missing pubspec.yaml.")
        return 1

    dart_files = _collect_dart_files(root)
    if len(dart_files) == 0:
        print("No Dart files found under lib/.")
        return 1

    rules = _filter_rules(_default_rules(), _parse_only_filters(args.only))
    selected_rule_names = _resolve_selected_rule_names(_parse_only_filters(args.only))

    violations: list[Violation] = []
    if len(selected_rule_names) == 0 or len(_project_rule_names().intersection(selected_rule_names)) > 0:
        violations.extend(_project_violations(root, pubspec_file.read_text(encoding="utf-8"), selected_rule_names))

    for file_ctx in dart_files:
        for rule in rules:
            violations.extend(rule.check(file_ctx))

    violations.sort(key=lambda item: (item.severity != SEVERITY_ERROR, item.file, item.line))
    _write_report(root, violations)
    _print_summary(violations)

    has_error = any(item.severity == SEVERITY_ERROR for item in violations)
    if has_error:
        return 1
    if args.strict and violations:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
