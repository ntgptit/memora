from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files, is_feature_ui_file


GUARD_ID = "feature-surface"
FILE_NAME = "tool/frontend_guard/guards/feature_surface.py"
DESCRIPTION = "Feature screens must rely on theme surface/background tokens."

RULE_FEATURE_SURFACE_BACKGROUND = "FEATURE_SURFACE_BACKGROUND_USES_THEME_SURFACE"

_SCAFFOLD_PATTERN = re.compile(r"\bScaffold\s*\(")
_BACKGROUND_COLOR_PATTERN = re.compile(r"\bbackgroundColor\s*:")
_ALLOWED_SURFACE_PATTERNS = (
    re.compile(r"\bcolorScheme\.(background|surface|surfaceContainer(?:Lowest|Low|High|Highest)?)\b"),
    re.compile(r"\bcontext\.colorScheme\.(background|surface|surfaceContainer(?:Lowest|Low|High|Highest)?)\b"),
    re.compile(r"\bcontext\.theme\.colorScheme\.(background|surface|surfaceContainer(?:Lowest|Low|High|Highest)?)\b"),
    re.compile(r"\bColors\.transparent\b"),
    re.compile(r"\bcolorScheme\.scrim\b"),
    re.compile(r"\bcontext\.colorScheme\.scrim\b"),
)


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/presentation/features",)):
        if not is_feature_ui_file(source_file.rel_path):
            continue
        violations.extend(_check_file(source_file))
    return violations


def _check_file(source_file) -> list[Violation]:
    violations: list[Violation] = []
    for index, raw_line in enumerate(source_file.lines):
        if _SCAFFOLD_PATTERN.search(raw_line) is None:
            continue
        block_end = _find_block_end(lines=source_file.lines, start_index=index)
        for block_index in range(index, block_end + 1):
            line = source_file.lines[block_index]
            if _BACKGROUND_COLOR_PATTERN.search(line) is None:
                continue
            expression = _extract_expression(line)
            if any(pattern.search(expression) is not None for pattern in _ALLOWED_SURFACE_PATTERNS):
                continue
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_FEATURE_SURFACE_BACKGROUND,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=block_index + 1,
                    reason="Scaffold.backgroundColor in feature UI must use theme surface/background tokens.",
                    snippet=line.strip(),
                )
            )
    return violations


def _find_block_end(*, lines: list[str], start_index: int) -> int:
    balance = 0
    for index in range(start_index, len(lines)):
        balance += lines[index].count("(")
        balance -= lines[index].count(")")
        if balance <= 0:
            return index
    return len(lines) - 1


def _extract_expression(line: str) -> str:
    parts = line.split(":", 1)
    if len(parts) != 2:
        return line.strip()
    return parts[1].strip().rstrip(",")
