#!/usr/bin/env python3
"""
Backend checklist guard for Memora Spring Boot + JPA.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


RULE_CLASS_MAX_LINES = "CLASS_MAX_LINES"
RULE_PROPERTIES_PACKAGE = "CONFIGURATION_PROPERTIES_IN_PROPERTIES_PACKAGE"
RULE_CONSTANT_PACKAGE_EXISTS = "CONSTANT_PACKAGE_EXISTS"
RULE_MESSAGE_BUNDLE_EXISTS = "MESSAGE_BUNDLE_EXISTS"
RULE_CONTROLLER_REST = "CONTROLLER_REST_CONTROLLER"
RULE_CONTROLLER_TX = "CONTROLLER_NO_TRANSACTIONAL"
RULE_CONTROLLER_ENTITY_RESPONSE = "CONTROLLER_NO_ENTITY_RESPONSE"
RULE_CONTROLLER_API_VERSION = "CONTROLLER_API_VERSIONING"
RULE_CONTROLLER_API_DOC = "CONTROLLER_API_DOC_REQUIRED"
RULE_JAVADOC_CONTROLLER_REQUIRED = "JAVADOC_REQUIRED_FOR_CONTROLLER_AND_ENDPOINTS"
RULE_JAVADOC_SERVICE_REQUIRED = "JAVADOC_REQUIRED_FOR_SERVICE_METHODS"
RULE_REPOSITORY_EXTENDS_JPA = "REPOSITORY_EXTENDS_JPA_REPOSITORY"
RULE_QUERY_NATIVE_SQL_ONLY = "QUERY_MUST_USE_NATIVE_SQL"
RULE_QUERY_KEYWORD_UPPERCASE = "QUERY_SQL_KEYWORDS_MUST_BE_UPPERCASE"
RULE_ENTITY_NO_DATA = "ENTITY_NO_LOMBOK_DATA"
RULE_ENTITY_HAS_ID = "ENTITY_HAS_ID"
RULE_ENTITY_NO_LAYER_DEP = "ENTITY_NO_SERVICE_REPOSITORY_DEP"
RULE_ENTITY_RELATION_FETCH = "ENTITY_RELATION_FETCH_LAZY"
RULE_ENTITY_MANY_TO_ONE_JOIN = "ENTITY_MANY_TO_ONE_HAS_JOIN_COLUMN"
RULE_ENTITY_AUDIT_LIFECYCLE = "ENTITY_AUDIT_LIFECYCLE"
RULE_ENTITY_OPTIMISTIC_LOCK = "ENTITY_HAS_VERSION_FOR_OPTIMISTIC_LOCK"
RULE_ENTITY_ENUM_STRING = "ENTITY_ENUMERATED_STRING"
RULE_SOFT_DELETE_NO_HARD_DELETE = "SOFT_DELETE_NO_HARD_DELETE_CALL"
RULE_VALIDATION_MESSAGE_CONSTANT = "DTO_VALIDATION_MESSAGES_USE_CONSTANTS"
RULE_INLINE_EXCEPTION_MESSAGE = "NO_INLINE_EXCEPTION_MESSAGE"
RULE_IF_REQUIRES_COMMENT = "IF_STATEMENT_REQUIRES_PRECEDING_COMMENT"
RULE_THROW_REQUIRES_COMMENT = "THROW_STATEMENT_REQUIRES_PRECEDING_COMMENT"
RULE_FOR_REQUIRES_COMMENT = "FOR_STATEMENT_REQUIRES_PRECEDING_COMMENT"
RULE_STREAM_REQUIRES_COMMENT = "STREAM_CALL_REQUIRES_PRECEDING_COMMENT"
RULE_RETURN_REQUIRES_COMMENT = "RETURN_STATEMENT_REQUIRES_PRECEDING_COMMENT"

SEVERITY_ERROR = "ERROR"
SEVERITY_WARNING = "WARN"

CLASS_MAX_LINES = 300
REPORT_FILE = "backend_guard_report.json"
JAVA_EXTENSION = ".java"

ENTITY_CLASS_PATTERN = re.compile(r"@\s*Entity\b")
ID_ANNOTATION_PATTERN = re.compile(r"@\s*Id\b")
VERSION_PATTERN = re.compile(r"@\s*Version\b")
EXTENDS_PATTERN = re.compile(r"\bextends\s+(\w+)")
LOMBOK_DATA_PATTERN = re.compile(r"@\s*Data\b")
CONFIGURATION_PROPERTIES_PATTERN = re.compile(r"@\s*ConfigurationProperties\b")
REST_CONTROLLER_PATTERN = re.compile(r"^\s*@\s*RestController\b", re.MULTILINE)
REST_CONTROLLER_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*RestController\b")
TRANSACTIONAL_PATTERN = re.compile(r"^\s*@\s*Transactional\b")
MAPPING_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*(GetMapping|PostMapping|PutMapping|PatchMapping|DeleteMapping)\b")
OPERATION_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*Operation\b")
INTERFACE_PATTERN = re.compile(r"\binterface\s+\w+")
EXTENDS_JPA_PATTERN = re.compile(r"\bextends\s+[^{;]*JpaRepository<")
QUERY_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*Query\b")
PUBLIC_METHOD_START_PATTERN = re.compile(r"^\s*public\s+.+\(.+\).*")
VALIDATION_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*(NotBlank|NotNull|NotEmpty|Positive|PositiveOrZero|Size|Email)\b")
MESSAGE_ATTRIBUTE_PATTERN = re.compile(r"\bmessage\s*=")
INLINE_MESSAGE_LITERAL_PATTERN = re.compile(r'\bmessage\s*=\s*"')
INLINE_EXCEPTION_MESSAGE_PATTERN = re.compile(
    r'new\s+(BadRequestException|ConflictException|ResourceNotFoundException)\s*\(\s*"'
)
IF_STATEMENT_PATTERN = re.compile(r"^\s*if\s*\(")
THROW_STATEMENT_PATTERN = re.compile(r"^\s*throw\b")
FOR_PATTERN = re.compile(r"^\s*for\s*\(")
STREAM_CALL_PATTERN = re.compile(r"\.\s*stream\s*\(")
RETURN_STATEMENT_PATTERN = re.compile(r"^\s*return\b")
IMPORT_SERVICE_OR_REPO_PATTERN = re.compile(r"^import\s+.*\.(service|repository)\.", re.MULTILINE)
RELATION_PATTERN = re.compile(r"@\s*(OneToMany|ManyToOne|ManyToMany|OneToOne)\s*(\((.*?)\))?")
JOIN_COLUMN_PATTERN = re.compile(r"^\s*@\s*JoinColumn\b")
PRE_PERSIST_PATTERN = re.compile(r"@\s*PrePersist\b")
PRE_UPDATE_PATTERN = re.compile(r"@\s*PreUpdate\b")
CREATED_DATE_PATTERN = re.compile(r"@\s*CreatedDate\b")
LAST_MODIFIED_DATE_PATTERN = re.compile(r"@\s*LastModifiedDate\b")
ENUMERATED_PATTERN = re.compile(r"@\s*Enumerated\b")
ENUMERATED_STRING_PATTERN = re.compile(r"@\s*Enumerated\s*\(\s*EnumType\.STRING\s*\)")
ENTITY_RESPONSE_PATTERN = re.compile(r"\bResponseEntity<\s*\w+Entity\s*>")
DIRECT_ENTITY_RETURN_PATTERN = re.compile(r"\bpublic\s+(\w+Entity)\s+\w+\s*\(")
HARD_DELETE_CALL_PATTERN = re.compile(r"\.\s*delete(ById|All|AllById)?\s*\(")
AUDIT_FIELD_PATTERN = re.compile(r"\b(createdAt|updatedAt)\b")
LOWERCASE_SQL_KEYWORD_PATTERNS = [
    re.compile(r"\bselect\b"),
    re.compile(r"\bfrom\b"),
    re.compile(r"\bwhere\b"),
    re.compile(r"\bjoin\b"),
    re.compile(r"\bleft\b"),
    re.compile(r"\bright\b"),
    re.compile(r"\binner\b"),
    re.compile(r"\bon\b"),
    re.compile(r"\band\b"),
    re.compile(r"\bor\b"),
    re.compile(r"\border\s+by\b"),
    re.compile(r"\bgroup\s+by\b"),
    re.compile(r"\bupdate\b"),
    re.compile(r"\bset\b"),
    re.compile(r"\bcount\s*\("),
    re.compile(r"\blower\s*\("),
]

ENTITY_BASE_CLASSES_WITH_ID = {
    "BaseEntity",
    "AuditableEntity",
    "SoftDeletableAuditableEntity",
    "CreatedOnlyEntity",
}

ENTITY_BASE_CLASSES_WITH_VERSION = {
    "AuditableEntity",
    "SoftDeletableAuditableEntity",
}

ENTITY_BASE_CLASSES_WITHOUT_VERSION = {
    "CreatedOnlyEntity",
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


class Rule:
    name: str

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        raise NotImplementedError


class MaxClassLinesRule(Rule):
    name = RULE_CLASS_MAX_LINES

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        line_count = len(file_ctx.lines)
        if line_count <= CLASS_MAX_LINES:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=1,
                reason=f"Class file exceeds {CLASS_MAX_LINES} lines (found {line_count}).",
                snippet=file_ctx.rel_path,
            )
        ]


class ConfigurationPropertiesPackageRule(Rule):
    name = RULE_PROPERTIES_PACKAGE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if CONFIGURATION_PROPERTIES_PATTERN.search(file_ctx.text) is None:
            return []
        if "/properties/" in file_ctx.rel_path:
            return []
        line = _first_line_regex(file_ctx.lines, r"@\s*ConfigurationProperties\b")
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line if line > 0 else 1,
                reason="@ConfigurationProperties classes must live under /properties/.",
                snippet=file_ctx.lines[line - 1].strip() if line > 0 else file_ctx.rel_path,
            )
        ]


class ValidationMessageConstantRule(Rule):
    name = RULE_VALIDATION_MESSAGE_CONSTANT

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/dto/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if VALIDATION_ANNOTATION_PATTERN.search(raw) is None:
                continue
            annotation_block = _collect_annotation_block(file_ctx.lines, index, 8)
            if MESSAGE_ATTRIBUTE_PATTERN.search(annotation_block) is None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Validation annotations must declare message constants from the constant package.",
                        snippet=raw.strip(),
                    )
                )
                continue
            if INLINE_MESSAGE_LITERAL_PATTERN.search(annotation_block) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Validation annotations must use named message constants, not inline string literals.",
                    snippet=raw.strip(),
                )
            )
        return violations


class InlineExceptionMessageRule(Rule):
    name = RULE_INLINE_EXCEPTION_MESSAGE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if "new BadRequestException" not in raw and "new ConflictException" not in raw and "new ResourceNotFoundException" not in raw:
                continue
            exception_block = _collect_annotation_block(file_ctx.lines, index, 6)
            if INLINE_EXCEPTION_MESSAGE_PATTERN.search(exception_block) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Custom exceptions must use message keys or constants, not inline string literals.",
                    snippet=raw.strip(),
                )
            )
        return violations


class JavaDocControllerRule(Rule):
    name = RULE_JAVADOC_CONTROLLER_REQUIRED

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        lines = file_ctx.lines
        violations: list[Violation] = []

        for index, raw in enumerate(lines, start=1):
            if REST_CONTROLLER_ANNOTATION_PATTERN.search(raw) is None:
                continue
            if _contains_token_above(lines, index, "/**", 20):
                break
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Controller class must define JavaDoc.",
                    snippet=raw.strip(),
                )
            )
            break

        for index, raw in enumerate(lines, start=1):
            if MAPPING_ANNOTATION_PATTERN.search(raw) is None:
                continue
            if _contains_token_above(lines, index, "/**", 25):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Endpoint mapping must define JavaDoc.",
                    snippet=raw.strip(),
                )
            )

        return violations


class JavaDocServiceRule(Rule):
    name = RULE_JAVADOC_SERVICE_REQUIRED

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/service/" not in file_ctx.rel_path:
            return []
        if "/service/impl/" in file_ctx.rel_path:
            return []
        lines = file_ctx.lines
        violations: list[Violation] = []
        class_name = _detect_primary_class_name(lines)

        for index, raw in enumerate(lines, start=1):
            stripped = raw.strip()
            if not PUBLIC_METHOD_START_PATTERN.search(stripped):
                continue
            if " class " in stripped:
                continue

            signature = _collect_method_signature(lines, index, 8)
            return_type = _extract_return_type(signature)
            method_name = _extract_method_name(signature)
            if method_name == "":
                continue
            if method_name == class_name:
                continue

            param_names = _extract_param_names(signature)
            javadoc = _extract_javadoc_above(lines, index, 20)
            if javadoc == "":
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Service method must have JavaDoc with @param/@return.",
                        snippet=stripped,
                    )
                )
                continue

            for param_name in param_names:
                if f"@param {param_name}" in javadoc:
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason=f"Service JavaDoc missing @param for '{param_name}'.",
                        snippet=stripped,
                    )
                )
                break

            if return_type == "void":
                continue
            if "@return" in javadoc:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Service JavaDoc missing @return.",
                    snippet=stripped,
                )
            )

        return violations


class PrecedingCommentRule(Rule):
    def __init__(
        self,
        *,
        name: str,
        pattern: re.Pattern[str],
        reason: str,
        main_source_only: bool = False,
        rel_path_contains_any: tuple[str, ...] = (),
    ) -> None:
        self.name = name
        self._pattern = pattern
        self._reason = reason
        self._main_source_only = main_source_only
        self._rel_path_contains_any = rel_path_contains_any

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if self._main_source_only and not file_ctx.rel_path.startswith("src/main/java/"):
            return []
        if self._rel_path_contains_any and not any(token in file_ctx.rel_path for token in self._rel_path_contains_any):
            return []
        violations: list[Violation] = []
        lines = file_ctx.lines
        for index, raw in enumerate(lines, start=1):
            if self._pattern.search(raw) is None:
                continue
            if _has_comment_above(lines, index, 4):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason=self._reason,
                    snippet=raw.strip(),
                )
            )
        return violations


class ControllerRestRule(Rule):
    name = RULE_CONTROLLER_REST

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        if REST_CONTROLLER_PATTERN.search(file_ctx.text) is not None:
            return []

        line = _first_line_regex(file_ctx.lines, r"^\s*@\s*Controller\b")
        if line > 0:
            return [
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=line,
                    reason="Controller must use @RestController.",
                    snippet=file_ctx.lines[line - 1].strip(),
                )
            ]

        mapping_line = _first_line_regex(
            file_ctx.lines,
            r"^\s*@\s*(GetMapping|PostMapping|PutMapping|PatchMapping|DeleteMapping|RequestMapping)\b",
        )
        if mapping_line <= 0:
            return []

        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=mapping_line,
                reason="Controller-like file should declare @RestController.",
                snippet=file_ctx.lines[mapping_line - 1].strip(),
            )
        ]


class ControllerTransactionalRule(Rule):
    name = RULE_CONTROLLER_TX

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        line = _first_line_regex(file_ctx.lines, r"^\s*@\s*Transactional\b")
        if line <= 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line,
                reason="Do not put @Transactional in controller layer.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class ControllerEntityResponseRule(Rule):
    name = RULE_CONTROLLER_ENTITY_RESPONSE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = raw.strip()
            if ENTITY_RESPONSE_PATTERN.search(stripped) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Controller must not return Entity directly; use DTO.",
                        snippet=stripped,
                    )
                )
                continue
            if DIRECT_ENTITY_RETURN_PATTERN.search(stripped) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Controller method return type must not be Entity.",
                    snippet=stripped,
                )
            )
        return violations


class ControllerApiVersionRule(Rule):
    name = RULE_CONTROLLER_API_VERSION

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if "@RequestMapping" not in raw:
                continue
            annotation_block = _collect_annotation_block(file_ctx.lines, index, 6)
            if re.search(r'"/api/v\d+/', annotation_block) is not None:
                return []
            return [
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason='Request mapping should be versioned, example: "/api/v1/...".',
                    snippet=raw.strip(),
                )
            ]
        return []


class ControllerApiDocRule(Rule):
    name = RULE_CONTROLLER_API_DOC

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if MAPPING_ANNOTATION_PATTERN.search(raw) is None:
                continue
            previous = _previous_non_blank_lines(file_ctx.lines, index, 12)
            has_operation = any(OPERATION_ANNOTATION_PATTERN.search(text) is not None for _, text in previous)
            if has_operation:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Endpoint mapping should declare @Operation for API documentation.",
                    snippet=raw.strip(),
                )
            )
        return violations


class RepositoryJpaRule(Rule):
    name = RULE_REPOSITORY_EXTENDS_JPA

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/repository/" not in file_ctx.rel_path:
            return []
        if INTERFACE_PATTERN.search(file_ctx.text) is None:
            return []
        if EXTENDS_JPA_PATTERN.search(file_ctx.text) is not None:
            return []
        line = _first_line_regex(file_ctx.lines, r"\binterface\s+\w+")
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line if line > 0 else 1,
                reason="Repository interface should extend JpaRepository.",
                snippet=file_ctx.lines[line - 1].strip() if line > 0 else file_ctx.rel_path,
            )
        ]


class QueryMustUseNativeSqlRule(Rule):
    name = RULE_QUERY_NATIVE_SQL_ONLY

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/repository/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if QUERY_ANNOTATION_PATTERN.search(raw) is None:
                continue
            annotation_block = _collect_annotation_block(file_ctx.lines, index, 12)
            if "nativeQuery = true" in annotation_block or "nativeQuery=true" in annotation_block:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Repository @Query should use nativeQuery = true.",
                    snippet=raw.strip(),
                )
            )
        return violations


class QueryKeywordUppercaseRule(Rule):
    name = RULE_QUERY_KEYWORD_UPPERCASE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/repository/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if QUERY_ANNOTATION_PATTERN.search(raw) is None:
                continue
            annotation_block = _collect_annotation_block(file_ctx.lines, index, 20)
            for pattern in LOWERCASE_SQL_KEYWORD_PATTERNS:
                if pattern.search(annotation_block) is None:
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_WARNING,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="SQL keywords inside @Query should be uppercase.",
                        snippet=raw.strip(),
                    )
                )
                break
        return violations


class EntityNoDataRule(Rule):
    name = RULE_ENTITY_NO_DATA

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        line = _first_line_regex(file_ctx.lines, r"@\s*Data\b")
        if line <= 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line,
                reason="@Data is forbidden on JPA Entity.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class EntityHasIdRule(Rule):
    name = RULE_ENTITY_HAS_ID

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if ID_ANNOTATION_PATTERN.search(file_ctx.text) is not None:
            return []
        if _extended_class_name(file_ctx.text) in ENTITY_BASE_CLASSES_WITH_ID:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=1,
                reason="Entity must declare @Id field.",
                snippet=file_ctx.rel_path,
            )
        ]


class EntityLayerDependencyRule(Rule):
    name = RULE_ENTITY_NO_LAYER_DEP

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        match = IMPORT_SERVICE_OR_REPO_PATTERN.search(file_ctx.text)
        if match is None:
            return []
        line = _line_for_offset(file_ctx.lines, match.start())
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line,
                reason="Entity must not depend on service or repository packages.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class EntityRelationFetchRule(Rule):
    name = RULE_ENTITY_RELATION_FETCH

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if RELATION_PATTERN.search(raw) is None:
                continue
            annotation_block = _collect_annotation_block(file_ctx.lines, index, 6)
            if "fetch = FetchType.LAZY" in annotation_block or "fetch=FetchType.LAZY" in annotation_block:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Entity relation should explicitly declare fetch = FetchType.LAZY.",
                    snippet=raw.strip(),
                )
            )
        return violations


class EntityManyToOneJoinColumnRule(Rule):
    name = RULE_ENTITY_MANY_TO_ONE_JOIN

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if "@ManyToOne" not in raw:
                continue
            next_lines = _next_non_blank_lines(file_ctx.lines, index, 3)
            has_join_column = any(JOIN_COLUMN_PATTERN.search(text) is not None for _, text in next_lines)
            if has_join_column:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="@ManyToOne association should declare @JoinColumn explicitly.",
                    snippet=raw.strip(),
                )
            )
        return violations


class EntityAuditLifecycleRule(Rule):
    name = RULE_ENTITY_AUDIT_LIFECYCLE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        has_audit_field = any(AUDIT_FIELD_PATTERN.search(_strip_line_comment(line)) is not None for line in file_ctx.lines)
        if not has_audit_field:
            return []
        has_auditing = (
            PRE_PERSIST_PATTERN.search(file_ctx.text) is not None
            and PRE_UPDATE_PATTERN.search(file_ctx.text) is not None
        ) or (
            CREATED_DATE_PATTERN.search(file_ctx.text) is not None
            and LAST_MODIFIED_DATE_PATTERN.search(file_ctx.text) is not None
        )
        if has_auditing:
            return []
        line = _first_line_regex(file_ctx.lines, r"\b(createdAt|updatedAt)\b")
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=line if line > 0 else 1,
                reason="Entity audit fields require lifecycle callbacks or Spring Data auditing annotations.",
                snippet=file_ctx.lines[line - 1].strip() if line > 0 else file_ctx.rel_path,
            )
        ]


class EntityVersionRule(Rule):
    name = RULE_ENTITY_OPTIMISTIC_LOCK

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if VERSION_PATTERN.search(file_ctx.text) is not None:
            return []
        extended_class_name = _extended_class_name(file_ctx.text)
        if extended_class_name in ENTITY_BASE_CLASSES_WITH_VERSION:
            return []
        if extended_class_name in ENTITY_BASE_CLASSES_WITHOUT_VERSION:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=1,
                reason="Entity should declare @Version for optimistic locking.",
                snippet=file_ctx.rel_path,
            )
        ]


class EntityEnumeratedStringRule(Rule):
    name = RULE_ENTITY_ENUM_STRING

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if ENUMERATED_PATTERN.search(raw) is None:
                continue
            annotation_block = _collect_annotation_block(file_ctx.lines, index, 4)
            if ENUMERATED_STRING_PATTERN.search(annotation_block) is not None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Persist enums with @Enumerated(EnumType.STRING).",
                    snippet=raw.strip(),
                )
            )
        return violations


class SoftDeleteNoHardDeleteRule(Rule):
    name = RULE_SOFT_DELETE_NO_HARD_DELETE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/service/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if HARD_DELETE_CALL_PATTERN.search(raw) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_WARNING,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Service layer should avoid hard-delete repository calls unless explicitly intended.",
                    snippet=raw.strip(),
                )
            )
        return violations


def _default_rules() -> list[Rule]:
    return [
        MaxClassLinesRule(),
        ConfigurationPropertiesPackageRule(),
        ValidationMessageConstantRule(),
        InlineExceptionMessageRule(),
        JavaDocControllerRule(),
        JavaDocServiceRule(),
        ControllerRestRule(),
        ControllerTransactionalRule(),
        ControllerEntityResponseRule(),
        ControllerApiVersionRule(),
        ControllerApiDocRule(),
        RepositoryJpaRule(),
        QueryMustUseNativeSqlRule(),
        QueryKeywordUppercaseRule(),
        EntityNoDataRule(),
        EntityHasIdRule(),
        EntityLayerDependencyRule(),
        EntityRelationFetchRule(),
        EntityManyToOneJoinColumnRule(),
        EntityAuditLifecycleRule(),
        EntityVersionRule(),
        EntityEnumeratedStringRule(),
        SoftDeleteNoHardDeleteRule(),
        PrecedingCommentRule(
            name=RULE_IF_REQUIRES_COMMENT,
            pattern=IF_STATEMENT_PATTERN,
            reason="if statement must have a preceding comment explaining the condition.",
            main_source_only=True,
            rel_path_contains_any=("/service/", "/mode/", "/security/"),
        ),
        PrecedingCommentRule(
            name=RULE_THROW_REQUIRES_COMMENT,
            pattern=THROW_STATEMENT_PATTERN,
            reason="throw statement must have a preceding comment explaining the exception path.",
            main_source_only=True,
            rel_path_contains_any=("/service/", "/mode/", "/security/"),
        ),
        PrecedingCommentRule(
            name=RULE_FOR_REQUIRES_COMMENT,
            pattern=FOR_PATTERN,
            reason="for statement must have a preceding comment explaining the loop intent.",
            main_source_only=True,
            rel_path_contains_any=("/service/", "/mode/", "/security/"),
        ),
        PrecedingCommentRule(
            name=RULE_STREAM_REQUIRES_COMMENT,
            pattern=STREAM_CALL_PATTERN,
            reason="stream call must have a preceding comment explaining the stream pipeline intent.",
            main_source_only=True,
            rel_path_contains_any=("/service/", "/mode/", "/security/"),
        ),
        PrecedingCommentRule(
            name=RULE_RETURN_REQUIRES_COMMENT,
            pattern=RETURN_STATEMENT_PATTERN,
            reason="return statement must have a preceding comment explaining the return path.",
            main_source_only=True,
            rel_path_contains_any=("/service/", "/mode/", "/security/"),
        ),
    ]


def _project_rule_names() -> set[str]:
    return {
        RULE_CONSTANT_PACKAGE_EXISTS,
        RULE_MESSAGE_BUNDLE_EXISTS,
    }


def _project_violations(root: Path, selected_rule_names: set[str]) -> list[Violation]:
    violations: list[Violation] = []
    should_run_all = len(selected_rule_names) == 0

    constant_dir = root / "src" / "main" / "java" / "com" / "memora" / "app" / "constant"
    if should_run_all or RULE_CONSTANT_PACKAGE_EXISTS in selected_rule_names:
        has_constant_java_file = constant_dir.exists() and any(constant_dir.rglob(f"*{JAVA_EXTENSION}"))
        if not has_constant_java_file:
            violations.append(
                Violation(
                    rule=RULE_CONSTANT_PACKAGE_EXISTS,
                    severity=SEVERITY_ERROR,
                    file="src/main/java/com/memora/app/constant",
                    line=1,
                    reason="Constant package must exist and contain backend constants.",
                    snippet="src/main/java/com/memora/app/constant",
                )
            )

    resources_dir = root / "src" / "main" / "resources"
    if should_run_all or RULE_MESSAGE_BUNDLE_EXISTS in selected_rule_names:
        required_files = [
            resources_dir / "messages.properties",
            resources_dir / "messages_vi.properties",
        ]
        for required_file in required_files:
            if required_file.exists():
                continue
            violations.append(
                Violation(
                    rule=RULE_MESSAGE_BUNDLE_EXISTS,
                    severity=SEVERITY_ERROR,
                    file=required_file.relative_to(root).as_posix(),
                    line=1,
                    reason="I18n message bundle is required for backend user-facing messages.",
                    snippet=required_file.name,
                )
            )

    return violations


def _collect_java_files(root: Path) -> list[FileContext]:
    source_roots = [
        root / "src" / "main" / "java",
        root / "src" / "test" / "java",
    ]
    files: list[FileContext] = []
    for source_root in source_roots:
        if not source_root.exists():
            continue
        for path in source_root.rglob(f"*{JAVA_EXTENSION}"):
            text = path.read_text(encoding="utf-8")
            rel_path = path.relative_to(root).as_posix()
            files.append(
                FileContext(
                    path=path,
                    rel_path=rel_path,
                    text=text,
                    lines=text.splitlines(),
                )
            )
    files.sort(key=lambda item: item.rel_path)
    return files


def _first_line_regex(lines: list[str], regex: str) -> int:
    pattern = re.compile(regex)
    for index, raw in enumerate(lines, start=1):
        if pattern.search(raw) is not None:
            return index
    return -1


def _extended_class_name(text: str) -> str | None:
    match = EXTENDS_PATTERN.search(text)
    if match is None:
        return None
    return match.group(1)


def _detect_primary_class_name(lines: list[str]) -> str:
    class_pattern = re.compile(r"\bclass\s+([A-Z]\w*)\b")
    for raw in lines:
        match = class_pattern.search(raw)
        if match is None:
            continue
        return match.group(1)
    return ""


def _line_for_offset(lines: list[str], offset: int) -> int:
    running = 0
    for index, raw in enumerate(lines, start=1):
        running += len(raw) + 1
        if offset < running:
            return index
    return 1


def _next_non_blank_lines(lines: list[str], start_line: int, limit: int) -> list[tuple[int, str]]:
    results: list[tuple[int, str]] = []
    index = start_line
    while index < len(lines):
        raw = lines[index]
        if raw.strip() == "":
            index += 1
            continue
        results.append((index + 1, raw))
        if len(results) >= limit:
            return results
        index += 1
    return results


def _previous_non_blank_lines(lines: list[str], start_line: int, limit: int) -> list[tuple[int, str]]:
    results: list[tuple[int, str]] = []
    index = start_line - 2
    while index >= 0:
        raw = lines[index]
        if raw.strip() == "":
            index -= 1
            continue
        results.append((index + 1, raw))
        if len(results) >= limit:
            return results
        index -= 1
    return results


def _collect_annotation_block(lines: list[str], start_line: int, max_lines: int) -> str:
    parts: list[str] = []
    open_paren = 0
    seen_paren = False
    index = start_line - 1
    end = min(len(lines), index + max_lines)
    while index < end:
        line = lines[index]
        parts.append(line)
        open_paren += line.count("(")
        open_paren -= line.count(")")
        if line.count("(") > 0:
            seen_paren = True
        if seen_paren and open_paren <= 0:
            break
        if not seen_paren and index > start_line - 1:
            break
        index += 1
    return " ".join(parts)


def _strip_line_comment(line: str) -> str:
    index = line.find("//")
    if index < 0:
        return line
    return line[:index]


def _has_javadoc_above(lines: list[str], start_line: int, max_lookback: int) -> bool:
    start_index = start_line - 2
    end_index = max(-1, start_index - max_lookback)
    for index in range(start_index, end_index, -1):
        raw = lines[index].strip()
        if raw == "":
            continue
        if raw in {")", "}", "})", "});", "},"}:
            continue
        if raw.startswith("/**"):
            return True
        if raw.startswith("*") or raw.startswith("*/") or raw.startswith("@"):
            continue
        return False
    return False


def _has_comment_above(lines: list[str], start_line: int, max_lookback: int) -> bool:
    start_index = start_line - 2
    end_index = max(-1, start_index - max_lookback)
    for index in range(start_index, end_index, -1):
        raw = lines[index].strip()
        if raw == "":
            continue
        if raw.startswith("//"):
            return True
        if raw.startswith("@"):
            continue
        return False
    return False


def _contains_token_above(lines: list[str], start_line: int, token: str, max_lookback: int) -> bool:
    start_index = start_line - 2
    end_index = max(-1, start_index - max_lookback)
    for index in range(start_index, end_index, -1):
        raw = lines[index].strip()
        if raw == "":
            continue
        if token in raw:
            return True
    return False


def _extract_javadoc_above(lines: list[str], start_line: int, max_lookback: int) -> str:
    start_index = start_line - 2
    end_index = max(-1, start_index - max_lookback)
    parts: list[str] = []
    in_javadoc = False
    for index in range(start_index, end_index, -1):
        raw = lines[index].strip()
        if raw == "":
            if in_javadoc:
                continue
            continue
        if raw in {")", "}", "})", "});", "},"}:
            continue
        if raw.startswith("/**"):
            parts.append(raw)
            in_javadoc = True
            break
        if raw.startswith("*") or raw.startswith("*/"):
            parts.append(raw)
            in_javadoc = True
            continue
        if raw.startswith("@"):
            continue
        if in_javadoc:
            continue
        return ""
    if not in_javadoc:
        return ""
    parts.reverse()
    return "\n".join(parts)


def _collect_method_signature(lines: list[str], start_line: int, max_lines: int) -> str:
    index = start_line - 1
    end = min(len(lines), index + max_lines)
    parts: list[str] = []
    while index < end:
        raw = lines[index].strip()
        parts.append(raw)
        if raw.endswith("{") or raw.endswith(";"):
            break
        index += 1
    return " ".join(parts)


def _extract_return_type(signature: str) -> str:
    normalized = " ".join(signature.split())
    match = re.search(
        r"\bpublic\s+(?:default\s+)?(?:static\s+)?(?:final\s+)?([A-Za-z0-9_<>\[\], ?]+?)\s+[A-Za-z_][A-Za-z0-9_]*\s*\(",
        normalized,
    )
    if match is None:
        return ""
    return match.group(1).strip()


def _extract_method_name(signature: str) -> str:
    normalized = " ".join(signature.split())
    match = re.search(
        r"\bpublic\s+(?:default\s+)?(?:static\s+)?(?:final\s+)?[A-Za-z0-9_<>\[\], ?]+\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(",
        normalized,
    )
    if match is None:
        return ""
    return match.group(1)


def _extract_param_names(signature: str) -> list[str]:
    normalized = " ".join(signature.split())
    start = normalized.find("(")
    end = normalized.rfind(")")
    if start < 0 or end < 0 or end <= start:
        return []
    params_segment = normalized[start + 1:end].strip()
    if params_segment == "":
        return []
    params = [chunk.strip() for chunk in params_segment.split(",")]
    param_names: list[str] = []
    for param in params:
        tokens = [token for token in param.split(" ") if token not in {"final"} and not token.startswith("@")]
        if len(tokens) == 0:
            continue
        candidate = tokens[-1].replace("...", "").strip()
        if candidate == "":
            continue
        param_names.append(candidate)
    return param_names


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
        print("Backend checklist guard passed.")
        return

    errors = sum(1 for item in violations if item.severity == SEVERITY_ERROR)
    warnings = sum(1 for item in violations if item.severity == SEVERITY_WARNING)
    if errors > 0:
        print(f"Backend checklist guard failed. errors={errors}, warnings={warnings}")
    else:
        print(f"Backend checklist guard completed with warnings. warnings={warnings}")
    for item in violations:
        print(item.to_console())


def _rule_group_aliases() -> dict[str, set[str]]:
    return {
        "api": {
            RULE_CONTROLLER_REST,
            RULE_CONTROLLER_TX,
            RULE_CONTROLLER_ENTITY_RESPONSE,
            RULE_CONTROLLER_API_VERSION,
            RULE_CONTROLLER_API_DOC,
            RULE_JAVADOC_CONTROLLER_REQUIRED,
        },
        "docs": {
            RULE_JAVADOC_CONTROLLER_REQUIRED,
            RULE_JAVADOC_SERVICE_REQUIRED,
            RULE_IF_REQUIRES_COMMENT,
            RULE_THROW_REQUIRES_COMMENT,
            RULE_FOR_REQUIRES_COMMENT,
            RULE_STREAM_REQUIRES_COMMENT,
            RULE_RETURN_REQUIRES_COMMENT,
        },
        "i18n": {
            RULE_CONSTANT_PACKAGE_EXISTS,
            RULE_MESSAGE_BUNDLE_EXISTS,
            RULE_VALIDATION_MESSAGE_CONSTANT,
            RULE_INLINE_EXCEPTION_MESSAGE,
        },
        "jpa": {
            RULE_REPOSITORY_EXTENDS_JPA,
            RULE_ENTITY_NO_DATA,
            RULE_ENTITY_HAS_ID,
            RULE_ENTITY_NO_LAYER_DEP,
            RULE_ENTITY_RELATION_FETCH,
            RULE_ENTITY_MANY_TO_ONE_JOIN,
            RULE_ENTITY_AUDIT_LIFECYCLE,
            RULE_ENTITY_OPTIMISTIC_LOCK,
            RULE_ENTITY_ENUM_STRING,
            RULE_SOFT_DELETE_NO_HARD_DELETE,
        },
        "query": {
            RULE_QUERY_NATIVE_SQL_ONLY,
            RULE_QUERY_KEYWORD_UPPERCASE,
        },
        "config": {
            RULE_PROPERTIES_PACKAGE,
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
    parser = argparse.ArgumentParser(description="Memora Spring Boot backend checklist guard.")
    parser.add_argument("--root", default=".", help="Project root directory. Default: current directory.")
    parser.add_argument(
        "--only",
        default="",
        help="Run only selected rule ids or rule groups (comma separated). Example: --only=api",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Fail when warning violations exist.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    java_files = _collect_java_files(root)
    if len(java_files) == 0:
        print("No Java files found under src/main/java or src/test/java.")
        return 1

    rules = _filter_rules(_default_rules(), _parse_only_filters(args.only))

    violations: list[Violation] = []
    selected_rule_names = _resolve_selected_rule_names(_parse_only_filters(args.only))
    violations.extend(_project_violations(root, selected_rule_names))
    for file_ctx in java_files:
        for rule in rules:
            violations.extend(rule.check(file_ctx))

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
