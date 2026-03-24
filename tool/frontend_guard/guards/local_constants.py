from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import (
    SEVERITY_ERROR,
    Violation,
    collect_source_files,
    is_ui_file,
)


GUARD_ID = "local-constants"
FILE_NAME = "tool/frontend_guard/guards/local_constants.py"
DESCRIPTION = "Local presentation constants must not duplicate theme/token/l10n ownership."

RULE_ICON_SIZE_CONSTANT = "UI_NO_LOCAL_ICON_SIZE_CONSTANT"
RULE_COMPONENT_SIZE_CONSTANT = "UI_NO_LOCAL_COMPONENT_SIZE_CONSTANT"
RULE_SPACING_CONSTANT = "UI_NO_LOCAL_SPACING_CONSTANT"
RULE_COPY_CONSTANT = "L10N_NO_LOCAL_PRESENTATION_COPY_CONSTANT"

_ALLOW_LITERAL_MARKER = "local-constants-guard: allow-literal"
_NUMERIC_CONSTANT_PATTERN = re.compile(
    r"^\s*(?:static\s+)?const\s+(?:double|int)\s+([A-Za-z_][A-Za-z0-9_]*)\s*="
)
_STRING_CONSTANT_PATTERN = re.compile(
    r"""^\s*(?:static\s+)?const\s+(?:String\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(['"]).+\2"""
)
_FIXTURE_PATH_MARKERS = ("fixture", "sample", "mock", "fake")


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/presentation",)):
        violations.extend(_check_numeric_constants(source_file))
        violations.extend(_check_string_constants(source_file))
    return violations


def _check_numeric_constants(source_file) -> list[Violation]:
    if not is_ui_file(source_file.rel_path):
        return []

    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ALLOW_LITERAL_MARKER in raw_line:
            continue
        match = _NUMERIC_CONSTANT_PATTERN.search(raw_line)
        if match is None:
            continue

        name = match.group(1)
        normalized = name.lower()
        if "iconsize" in normalized:
            violations.append(
                _violation(
                    source_file=source_file,
                    line=index,
                    rule=RULE_ICON_SIZE_CONSTANT,
                    reason=(
                        "Do not keep local icon-size constants in UI. Use context.iconSize when the size belongs to the design system, "
                        "or let the shared primitive own icon sizing."
                    ),
                )
            )
            continue

        if any(
            marker in normalized
            for marker in (
                "leadingsize",
                "emptystateheight",
                "draghandlewidth",
                "draghandleheight",
            )
        ):
            violations.append(
                _violation(
                    source_file=source_file,
                    line=index,
                    rule=RULE_COMPONENT_SIZE_CONSTANT,
                    reason=(
                        "Do not keep local component-size constants in UI. Route shared sizing through context.component or move the sizing into the shared primitive/composite that owns it."
                    ),
                )
            )
            continue

        if any(marker in normalized for marker in ("gap", "spacing")):
            violations.append(
                _violation(
                    source_file=source_file,
                    line=index,
                    rule=RULE_SPACING_CONSTANT,
                    reason=(
                        "Do not keep local spacing or gap constants in UI. Use context.spacing for design-system rhythm, or extract a semantic feature constraint only when the value is truly layout-specific."
                    ),
                )
            )
    return violations


def _check_string_constants(source_file) -> list[Violation]:
    normalized_path = source_file.rel_path.lower()
    if not normalized_path.startswith("lib/presentation/"):
        return []
    if any(marker in normalized_path for marker in _FIXTURE_PATH_MARKERS):
        return []

    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ALLOW_LITERAL_MARKER in raw_line:
            continue
        match = _STRING_CONSTANT_PATTERN.search(raw_line)
        if match is None:
            continue

        name = match.group(1).lower()
        if not any(
            marker in name
            for marker in ("title", "message", "label", "tooltip", "subtitle", "text")
        ):
            continue

        reason = (
            "User-facing local string constants in presentation are forbidden. Use AppLocalizations via context.l10n in UI, "
            "or store semantic feedback keys/enums in providers and localize at render time. Keep raw copy only in dedicated fixture/sample files."
        )
        violations.append(
            _violation(
                source_file=source_file,
                line=index,
                rule=RULE_COPY_CONSTANT,
                reason=reason,
            )
        )
    return violations


def _violation(*, source_file, line: int, rule: str, reason: str) -> Violation:
    return Violation(
        guard_id=GUARD_ID,
        rule=rule,
        severity=SEVERITY_ERROR,
        file=source_file.rel_path,
        line=line,
        reason=reason,
        snippet=source_file.lines[line - 1].strip(),
    )
