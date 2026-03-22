from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import (
    SEVERITY_ERROR,
    SEVERITY_WARNING,
    Violation,
    collect_source_files,
    is_ui_file,
    line_for_offset,
)


GUARD_ID = "ui-logic-separation"
FILE_NAME = "tool/frontend_guard/guards/ui_logic_separation.py"
DESCRIPTION = "Render-only UI boundaries for screens, widgets, and shared UI."

RULE_UI_NO_PROVIDER_DECLARATION = "UI_LAYER_NO_PROVIDER_DECLARATION"
RULE_UI_NO_DATA_OR_NETWORK_IMPORT = "UI_LAYER_NO_DATA_OR_NETWORK_IMPORT"
RULE_UI_NO_DIRECT_JSON_TRANSFORM = "UI_LAYER_NO_DIRECT_JSON_TRANSFORM"
RULE_UI_AVOID_DERIVATION_HELPERS = "UI_LAYER_AVOID_DOMAIN_LOGIC_HELPERS"

_RIVERPOD_ANNOTATION_PATTERN = re.compile(r"@\s*(riverpod|Riverpod)\b")
_MANUAL_PROVIDER_PATTERN = re.compile(
    r"\b(Provider|StateProvider|FutureProvider|StreamProvider|"
    r"ChangeNotifierProvider|StateNotifierProvider|NotifierProvider|"
    r"AsyncNotifierProvider)\s*(<|\()"
)
_IMPORT_PATTERN = re.compile(r"""^\s*import\s+['"]([^'"]+)['"];""", re.MULTILINE)
_JSON_PATTERN = re.compile(r"\b(jsonEncode|jsonDecode)\s*\(")
_DERIVED_HELPER_PATTERN = re.compile(
    r"^\s*(?:Future<[^>]+>|[A-Za-z0-9_<>, ?]+)\s+"
    r"(_(?:resolve|compute|derive|calculate|filter|sort|map|parse|normalize|validate|compare|transform)\w*)\s*\(",
    re.MULTILINE,
)

_ALLOWED_UI_RETURN_TYPES = {
    "Widget",
    "PreferredSizeWidget",
    "void",
    "Future<void>",
    "Color",
    "TextStyle",
    "TextTheme",
    "Decoration",
    "BoxDecoration",
    "BorderRadius",
    "BorderRadiusGeometry",
    "EdgeInsets",
    "EdgeInsetsGeometry",
    "Alignment",
    "AlignmentGeometry",
    "ShapeBorder",
    "IconData",
}

_FORBIDDEN_IMPORT_MARKERS = (
    "/data/",
    "/datasource/",
    "/datasources/",
    "/repositories/",
    "/repository/",
    "/domain/repositories/",
    "/domain/usecases/",
    "/domain/usecase/",
    "/service/",
    "/services/",
    "/network/",
    "api_client.dart",
    "package:dio/dio.dart",
    "package:retrofit/retrofit.dart",
    "dart:io",
    "dart:convert",
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/presentation",)):
        if not is_ui_file(source_file.rel_path):
            continue
        violations.extend(_check_no_provider_declaration(source_file))
        violations.extend(_check_forbidden_imports(source_file))
        violations.extend(_check_json_transform(source_file))
        violations.extend(_check_derived_logic_helpers(source_file))
    return violations


def _check_no_provider_declaration(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _RIVERPOD_ANNOTATION_PATTERN.search(raw_line) is None and _MANUAL_PROVIDER_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_UI_NO_PROVIDER_DECLARATION,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="UI files must not declare providers or Riverpod notifiers.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_forbidden_imports(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for match in _IMPORT_PATTERN.finditer(source_file.text):
        import_path = match.group(1)
        if not any(marker in import_path for marker in _FORBIDDEN_IMPORT_MARKERS):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_UI_NO_DATA_OR_NETWORK_IMPORT,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=line_for_offset(source_file.text, match.start()),
                reason="UI files must stay render-only and must not import data, network, repository, service, or IO layers directly.",
                snippet=import_path,
            )
        )
    return violations


def _check_json_transform(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _JSON_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_UI_NO_DIRECT_JSON_TRANSFORM,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="UI files must not perform jsonEncode/jsonDecode directly.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_derived_logic_helpers(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for match in _DERIVED_HELPER_PATTERN.finditer(source_file.text):
        signature = match.group(0).strip()
        if any(return_type in signature for return_type in _ALLOWED_UI_RETURN_TYPES):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_UI_AVOID_DERIVATION_HELPERS,
                severity=SEVERITY_WARNING,
                file=source_file.rel_path,
                line=line_for_offset(source_file.text, match.start()),
                reason="Move derivation, parsing, normalization, and domain-like helper logic out of UI files unless it returns UI-only values.",
                snippet=signature,
            )
        )
    return violations
