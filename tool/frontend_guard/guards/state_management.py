from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "state-management"
FILE_NAME = "tool/frontend_guard/guards/state_management.py"
DESCRIPTION = "State ownership rules for providers, DI, and shared controllers."

RULE_NO_ELSE_IN_STATE_FILES = "STATE_FILES_NO_ELSE"
RULE_NO_SET_STATE_IN_STATE_FILES = "STATE_FILES_NO_SET_STATE"
RULE_PROVIDER_NO_UI_IMPORT = "PROVIDER_FILES_NO_UI_IMPORT"
RULE_PROVIDER_NO_LEGACY_NOTIFIER = "PROVIDER_FILES_NO_LEGACY_NOTIFIER"

_IMPORT_PATTERN = re.compile(r"""^\s*import\s+['"]([^'"]+)['"];""", re.MULTILINE)
_ELSE_PATTERN = re.compile(r"\belse\b")
_SET_STATE_PATTERN = re.compile(r"\bsetState\s*\(")
_LEGACY_NOTIFIER_PATTERN = re.compile(r"\b(StateNotifier|ChangeNotifier|ValueNotifier)\b")

_SCAN_ROOTS = (
    "lib/app",
    "lib/core/di",
    "lib/presentation/features",
    "lib/presentation/shared/controllers",
)
_FORBIDDEN_UI_IMPORT_MARKERS = (
    "/screens/",
    "/widgets/",
    "/primitives/",
    "/composites/",
    "/layouts/",
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, _SCAN_ROOTS):
        if not _is_state_file(source_file.rel_path):
            continue
        violations.extend(_check_else_usage(source_file))
        violations.extend(_check_set_state_usage(source_file))
        if _is_provider_file(source_file.rel_path):
            violations.extend(_check_provider_imports(source_file))
            violations.extend(_check_legacy_notifiers(source_file))
    return violations


def _is_state_file(path: str) -> bool:
    if _is_provider_file(path):
        return True
    return path.startswith("lib/presentation/shared/controllers/")


def _is_provider_file(path: str) -> bool:
    if path == "lib/app/app_providers.dart":
        return True
    if path.startswith("lib/core/di/"):
        return True
    if "/providers/" in path:
        return True
    return path.endswith("_provider.dart")


def _check_else_usage(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _ELSE_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NO_ELSE_IN_STATE_FILES,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="State files should prefer early return and explicit branches instead of else blocks.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_set_state_usage(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _SET_STATE_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NO_SET_STATE_IN_STATE_FILES,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Provider, DI, and shared controller files must not use setState.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_provider_imports(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for match in _IMPORT_PATTERN.finditer(source_file.text):
        import_path = match.group(1)
        if not any(marker in import_path for marker in _FORBIDDEN_UI_IMPORT_MARKERS):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_PROVIDER_NO_UI_IMPORT,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=source_file.text.count("\n", 0, match.start()) + 1,
                reason="Provider and DI files must not depend on UI layers.",
                snippet=import_path,
            )
        )
    return violations


def _check_legacy_notifiers(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _LEGACY_NOTIFIER_PATTERN.search(raw_line) is None:
            continue
        if "_$" in raw_line:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_PROVIDER_NO_LEGACY_NOTIFIER,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Provider and DI files must follow Riverpod annotation first architecture instead of legacy notifiers.",
                snippet=raw_line.strip(),
            )
        )
    return violations
