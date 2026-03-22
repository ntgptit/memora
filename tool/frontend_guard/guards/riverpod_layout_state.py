from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "riverpod-layout-state"
FILE_NAME = "tool/frontend_guard/guards/riverpod_layout_state.py"
DESCRIPTION = "Shared render layers stay provider-agnostic and receive state from above."

RULE_SHARED_UI_NO_RIVERPOD_IMPORT = "SHARED_UI_NO_RIVERPOD_IMPORT"
RULE_SHARED_UI_NO_CONSUMER_API = "SHARED_UI_NO_CONSUMER_API"
RULE_SHARED_UI_NO_PROVIDER_IMPORT = "SHARED_UI_NO_PROVIDER_IMPORT"

_IMPORT_PATTERN = re.compile(r"""^\s*import\s+['"]([^'"]+)['"];""", re.MULTILINE)
_CONSUMER_API_PATTERN = re.compile(
    r"\b(WidgetRef|ConsumerWidget|ConsumerStatefulWidget|ConsumerState|Consumer)\b"
)
_REF_API_PATTERN = re.compile(r"\bref\.(watch|read|listen|invalidate|refresh)\b")
_SCAN_ROOTS = (
    "lib/presentation/shared/primitives",
    "lib/presentation/shared/composites",
    "lib/presentation/shared/layouts",
    "lib/presentation/shared/screens",
)
_RIVERPOD_IMPORT_MARKERS = (
    "package:flutter_riverpod/flutter_riverpod.dart",
    "package:riverpod_annotation/riverpod_annotation.dart",
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, _SCAN_ROOTS):
        violations.extend(_check_imports(source_file))
        violations.extend(_check_consumer_api_usage(source_file))
    return violations


def _check_imports(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for match in _IMPORT_PATTERN.finditer(source_file.text):
        import_path = match.group(1)
        line = source_file.text.count("\n", 0, match.start()) + 1
        if import_path in _RIVERPOD_IMPORT_MARKERS:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_SHARED_UI_NO_RIVERPOD_IMPORT,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=line,
                    reason="Shared primitives, composites, layouts, and screens must stay provider-agnostic.",
                    snippet=import_path,
                )
            )
        if "/providers/" in import_path or import_path.endswith("_provider.dart"):
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_SHARED_UI_NO_PROVIDER_IMPORT,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=line,
                    reason="Shared render layers must receive data via parameters instead of importing provider files.",
                    snippet=import_path,
                )
            )
    return violations


def _check_consumer_api_usage(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines, start=1):
        if _CONSUMER_API_PATTERN.search(raw_line) is None and _REF_API_PATTERN.search(raw_line) is None:
            continue
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=RULE_SHARED_UI_NO_CONSUMER_API,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=index,
                reason="Shared render layers must not own Riverpod read/watch/listen concerns.",
                snippet=raw_line.strip(),
            )
        )
    return violations
