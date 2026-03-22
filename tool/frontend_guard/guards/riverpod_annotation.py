from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import (
    SEVERITY_ERROR,
    Violation,
    collect_source_files,
    line_for_offset,
)


GUARD_ID = "riverpod-annotation"
FILE_NAME = "tool/frontend_guard/guards/riverpod_annotation.py"
DESCRIPTION = "Riverpod annotation, generated part, and notifier contract."

RULE_NO_MANUAL_PROVIDER_DECLARATION = "NO_MANUAL_RIVERPOD_PROVIDER_DECLARATION"
RULE_RIVERPOD_PART_DIRECTIVE = "RIVERPOD_ANNOTATED_FILE_HAS_PART_DIRECTIVE"
RULE_GENERATED_CLASS_NEEDS_ANNOTATION = "GENERATED_RIVERPOD_CLASS_REQUIRES_ANNOTATION"
RULE_NO_LEGACY_NOTIFIER_BASE = "NO_LEGACY_RIVERPOD_NOTIFIER_BASE"
RULE_NO_MOUNTED_CHECK = "NO_MOUNTED_CHECK_IN_RIVERPOD_FILE"

_MANUAL_PROVIDER_PATTERN = re.compile(
    r"\b(Provider|StateProvider|FutureProvider|StreamProvider|"
    r"ChangeNotifierProvider|StateNotifierProvider|NotifierProvider|"
    r"AsyncNotifierProvider)\s*(<|\()"
)
_RIVERPOD_ANNOTATION_PATTERN = re.compile(r"^\s*@(?:riverpod|Riverpod)\b", re.MULTILINE)
_GENERATED_CLASS_PATTERN = re.compile(r"\bclass\s+\w+\s+extends\s+_\$\w+\b")
_LEGACY_NOTIFIER_PATTERN = re.compile(r"\b(StateNotifier|ChangeNotifier)\b")
_MOUNTED_PATTERN = re.compile(r"\bmounted\b")
_REF_MOUNTED_PATTERN = re.compile(r"\bref\.mounted\b")

_SCOPED_MARKERS = (
    "/providers/",
    "/controllers/",
    "/repositories/",
    "/repository/",
    "/datasources/",
    "/datasource/",
    "/usecases/",
    "/service/",
    "/services/",
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib",)):
        violations.extend(_check_manual_provider_declarations(source_file))
        violations.extend(_check_part_directive(source_file))
        violations.extend(_check_generated_class_annotation(source_file))
        violations.extend(_check_legacy_notifier_bases(source_file))
        violations.extend(_check_mounted_usage(source_file))
    return violations


def _check_manual_provider_declarations(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _MANUAL_PROVIDER_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NO_MANUAL_PROVIDER_DECLARATION,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Use @riverpod/@Riverpod generated providers instead of manual provider declarations.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_part_directive(source_file) -> list[Violation]:
    if _RIVERPOD_ANNOTATION_PATTERN.search(source_file.text) is None:
        return []

    expected_part = f"part '{source_file.file_stem}.g.dart';"
    if expected_part in source_file.text:
        return []

    return [
        Violation(
            guard_id=GUARD_ID,
            rule=RULE_RIVERPOD_PART_DIRECTIVE,
            severity=SEVERITY_ERROR,
            file=source_file.rel_path,
            line=1,
            reason="Files with @riverpod/@Riverpod must declare the generated part directive.",
            snippet=expected_part,
        )
    ]


def _check_generated_class_annotation(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for match in _GENERATED_CLASS_PATTERN.finditer(source_file.text):
        start_line = line_for_offset(source_file.text, match.start())
        if _has_nearby_annotation(source_file.lines, start_line):
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_GENERATED_CLASS_NEEDS_ANNOTATION,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=start_line,
                reason="Generated Riverpod classes must be preceded by @riverpod/@Riverpod.",
                snippet=source_file.lines[start_line - 1].strip(),
            )
        )
    return violations


def _has_nearby_annotation(lines: list[str], class_line: int) -> bool:
    start = max(0, class_line - 4)
    end = class_line - 1
    for index in range(start, end):
        if _RIVERPOD_ANNOTATION_PATTERN.search(lines[index]) is not None:
            return True
    return False


def _check_legacy_notifier_bases(source_file) -> list[Violation]:
    if not any(marker in source_file.rel_path for marker in _SCOPED_MARKERS):
        return []

    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _LEGACY_NOTIFIER_PATTERN.search(raw_line) is None:
            continue
        if "_$" in raw_line:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NO_LEGACY_NOTIFIER_BASE,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="StateNotifier and ChangeNotifier are forbidden in Riverpod annotation first architecture.",
                snippet=raw_line.strip(),
            )
        )
    return violations


def _check_mounted_usage(source_file) -> list[Violation]:
    if _RIVERPOD_ANNOTATION_PATTERN.search(source_file.text) is None and _GENERATED_CLASS_PATTERN.search(
        source_file.text
    ) is None:
        return []

    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _MOUNTED_PATTERN.search(raw_line) is None:
            continue
        if _REF_MOUNTED_PATTERN.search(raw_line) is not None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_NO_MOUNTED_CHECK,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Do not use mounted checks in Riverpod generated notifier files. Use ref.mounted or ref.onDispose flow.",
                snippet=raw_line.strip(),
            )
        )
    return violations
