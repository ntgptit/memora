from __future__ import annotations

import re
from pathlib import Path

from frontend_guard.common import SEVERITY_ERROR, Violation, collect_source_files


GUARD_ID = "serialization-codegen"
FILE_NAME = "tool/frontend_guard/guards/serialization_codegen.py"
DESCRIPTION = "Data transport models and Retrofit bodies must use generated serialization."

RULE_DATA_MODEL_REQUIRES_CODEGEN = "DATA_MODEL_REQUIRES_JSON_SERIALIZABLE_CODEGEN"
RULE_DATA_MODEL_NO_MANUAL_SERIALIZATION = "DATA_MODEL_NO_MANUAL_FROMJSON_TOJSON"
RULE_RETROFIT_BODY_TYPED_MODEL = "RETROFIT_BODY_REQUIRES_TYPED_REQUEST_MODEL"

_JSON_SERIALIZABLE_PATTERN = re.compile(r"@\s*(JsonSerializable|freezed)\b")
_PART_G_PATTERN = re.compile(r"""^\s*part\s+['"][^'"]+\.g\.dart['"];""", re.MULTILINE)
_MANUAL_FROM_JSON_PATTERN = re.compile(r"factory\s+[A-Za-z_][A-Za-z0-9_]*\.fromJson\s*\([^)]*\)\s*\{")
_MANUAL_TO_JSON_PATTERN = re.compile(
    r"(?:Map<String,\s*dynamic>|Map<String,\s*Object\?>)\s+toJson\s*\(\)\s*\{"
)
_BODY_MAP_PATTERN = re.compile(r"@Body\(\)\s+Map\s*<")


def run(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    violations.extend(_check_data_models(root))
    violations.extend(_check_retrofit_body_types(root))
    return violations


def _check_data_models(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/data/models",)):
        if _PART_G_PATTERN.search(source_file.text) is None:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_DATA_MODEL_REQUIRES_CODEGEN,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=1,
                    reason="Data transport models must declare a generated part file and use generated serialization.",
                    snippet=source_file.file_name,
                )
            )
        if _JSON_SERIALIZABLE_PATTERN.search(source_file.text) is None:
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_DATA_MODEL_REQUIRES_CODEGEN,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=1,
                    reason="Data transport models must use @JsonSerializable or @freezed instead of plain handwritten serialization classes.",
                    snippet=source_file.file_name,
                )
            )

        violations.extend(
            _check_manual_serialization(
                source_file,
                pattern=_MANUAL_FROM_JSON_PATTERN,
                rule=RULE_DATA_MODEL_NO_MANUAL_SERIALIZATION,
                reason="Do not keep handwritten fromJson bodies in lib/data/models. Use generated serialization instead.",
            )
        )
        violations.extend(
            _check_manual_serialization(
                source_file,
                pattern=_MANUAL_TO_JSON_PATTERN,
                rule=RULE_DATA_MODEL_NO_MANUAL_SERIALIZATION,
                reason="Do not keep handwritten toJson bodies in lib/data/models. Use generated serialization instead.",
            )
        )
    return violations


def _check_manual_serialization(source_file, *, pattern: re.Pattern[str], rule: str, reason: str) -> list[Violation]:
    violations: list[Violation] = []
    for match in pattern.finditer(source_file.text):
        line = source_file.text.count("\n", 0, match.start()) + 1
        violations.append(
            Violation(
                guard_id=GUARD_ID,
                rule=rule,
                severity=SEVERITY_ERROR,
                file=source_file.rel_path,
                line=line,
                reason=reason,
                snippet=source_file.lines[line - 1].strip(),
            )
        )
    return violations


def _check_retrofit_body_types(root: Path) -> list[Violation]:
    violations: list[Violation] = []
    for source_file in collect_source_files(root, ("lib/data/datasources",)):
        for index, raw_line in enumerate(source_file.lines, start=1):
            if _BODY_MAP_PATTERN.search(raw_line) is None:
                continue
            violations.append(
                Violation(
                    guard_id=GUARD_ID,
                    rule=RULE_RETROFIT_BODY_TYPED_MODEL,
                    severity=SEVERITY_ERROR,
                    file=source_file.rel_path,
                    line=index,
                    reason="Retrofit @Body parameters must use typed request DTO classes instead of raw Map bodies.",
                    snippet=raw_line.strip(),
                )
            )
    return violations
