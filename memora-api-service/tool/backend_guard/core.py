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
RULE_PROPERTIES_NO_INTERNAL_DEFAULT = "CONFIGURATION_PROPERTIES_NO_INTERNAL_DEFAULTS"
RULE_PROPERTIES_DEFINED_IN_APPLICATION_YML = "CONFIGURATION_PROPERTIES_KEYS_DEFINED_IN_APPLICATION_YML"
RULE_CONSTANT_PACKAGE_EXISTS = "CONSTANT_PACKAGE_EXISTS"
RULE_MESSAGE_BUNDLE_EXISTS = "MESSAGE_BUNDLE_EXISTS"
RULE_CONTROLLER_REST = "CONTROLLER_REST_CONTROLLER"
RULE_CONTROLLER_TX = "CONTROLLER_NO_TRANSACTIONAL"
RULE_TRANSACTIONAL_SERVICE_ONLY = "TRANSACTIONAL_ONLY_IN_SERVICE_LAYER"
RULE_CONTROLLER_SERVICE_ONLY = "CONTROLLER_DEPENDS_ON_SERVICE_LAYER_ONLY"
RULE_SERVICE_NO_CONTROLLER_DEP = "SERVICE_NO_CONTROLLER_DEPENDENCY"
RULE_CONTROLLER_ENTITY_RESPONSE = "CONTROLLER_NO_ENTITY_RESPONSE"
RULE_CONTROLLER_ENTITY_SIGNATURE = "CONTROLLER_NO_ENTITY_IN_SIGNATURE"
RULE_CONTROLLER_API_VERSION = "CONTROLLER_API_VERSIONING"
RULE_CONTROLLER_API_DOC = "CONTROLLER_API_DOC_REQUIRED"
RULE_DTO_PACKAGE_STRUCTURE = "DTO_PACKAGE_STRUCTURE"
RULE_DTO_ROOT_NO_DIRECT_CLASS = "DTO_ROOT_HAS_NO_DIRECT_CLASS"
RULE_COMMON_DTO_SHARED_USAGE = "COMMON_DTO_MUST_BE_SHARED_REUSABLE_MODEL"
RULE_ENUM_PACKAGE_STRUCTURE = "ENUM_PACKAGE_STRUCTURE"
RULE_ENUM_ROOT_NO_DIRECT_CLASS = "ENUM_ROOT_HAS_NO_DIRECT_CLASS"
RULE_MAPPER_USES_MAPSTRUCT = "MAPPER_USES_MAPSTRUCT_SPRING_INTERFACE"
RULE_CONTROLLER_REQUEST_BODY_DTO = "CONTROLLER_REQUEST_BODY_USES_DTO"
RULE_CONTROLLER_REQUEST_BODY_VALID = "CONTROLLER_REQUEST_BODY_REQUIRES_VALID"
RULE_REQUEST_DTO_BEAN_VALIDATION = "REQUEST_DTO_HAS_BEAN_VALIDATION"
RULE_CONTROLLER_NO_REQUEST_DTO_RESPONSE = "CONTROLLER_NO_REQUEST_DTO_RESPONSE"
RULE_MAPPER_NO_REQUEST_DTO_OUTPUT = "MAPPER_NO_REQUEST_DTO_OUTPUT"
RULE_SERVICE_CONTRACT_DTO_DIRECTION = "SERVICE_CONTRACT_DTO_DIRECTION"
RULE_JAVADOC_CONTROLLER_REQUIRED = "JAVADOC_REQUIRED_FOR_CONTROLLER_AND_ENDPOINTS"
RULE_JAVADOC_SERVICE_REQUIRED = "JAVADOC_REQUIRED_FOR_SERVICE_METHODS"
RULE_REPOSITORY_EXTENDS_JPA = "REPOSITORY_EXTENDS_JPA_REPOSITORY"
RULE_QUERY_NATIVE_SQL_ONLY = "QUERY_MUST_USE_NATIVE_SQL"
RULE_QUERY_KEYWORD_UPPERCASE = "QUERY_SQL_KEYWORDS_MUST_BE_UPPERCASE"
RULE_REPOSITORY_NO_ORDERBY_DERIVED_QUERY = "REPOSITORY_NO_ORDERBY_DERIVED_QUERY"
RULE_JPA_SPECIFICATION_ONLY_IN_REPOSITORY_SPECIFICATION = (
    "JPA_SPECIFICATION_ONLY_IN_REPOSITORY_SPECIFICATION_PACKAGE"
)
RULE_NO_DEPRECATED_SPECIFICATION_WHERE = "NO_DEPRECATED_SPECIFICATION_WHERE"
RULE_ENTITY_NO_DATA = "ENTITY_NO_LOMBOK_DATA"
RULE_ENTITY_HAS_ID = "ENTITY_HAS_ID"
RULE_ENTITY_NO_LAYER_DEP = "ENTITY_NO_SERVICE_REPOSITORY_DEP"
RULE_ENTITY_RELATION_FETCH = "ENTITY_RELATION_FETCH_LAZY"
RULE_ENTITY_MANY_TO_ONE_JOIN = "ENTITY_MANY_TO_ONE_HAS_JOIN_COLUMN"
RULE_ENTITY_AUDIT_LIFECYCLE = "ENTITY_AUDIT_LIFECYCLE"
RULE_ENTITY_OPTIMISTIC_LOCK = "ENTITY_HAS_VERSION_FOR_OPTIMISTIC_LOCK"
RULE_ENTITY_ENUM_STRING = "ENTITY_ENUMERATED_STRING"
RULE_ENTITY_COMMON_STRUCTURE = "ENTITY_COMMON_PACKAGE_STRUCTURE"
RULE_SOFT_DELETE_NO_HARD_DELETE = "SOFT_DELETE_NO_HARD_DELETE_CALL"
RULE_VALIDATION_MESSAGE_CONSTANT = "DTO_VALIDATION_MESSAGES_USE_CONSTANTS"
RULE_INLINE_EXCEPTION_MESSAGE = "NO_INLINE_EXCEPTION_MESSAGE"
RULE_NO_ELSE = "NO_ELSE_ALLOWED"
RULE_NESTED_FOR_STREAM = "NESTED_FOR_SHOULD_USE_STREAM_INNER_LOOP"
RULE_LOMBOK_REQUIRED_ARGS_CONSTRUCTOR = "LOMBOK_REQUIRED_ARGS_CONSTRUCTOR_FOR_SPRING_BEAN"
RULE_LOMBOK_ENTITY_GETTER_SETTER = "LOMBOK_ENTITY_GETTER_SETTER_REQUIRED"
RULE_LOMBOK_BUILDER_PREFERRED = "LOMBOK_BUILDER_PREFERRED_FOR_DTO_CLASS"
RULE_SHARED_MAPPED_SUPERCLASS = "ENTITY_SHARED_FIELDS_MAPPED_SUPERCLASS"
RULE_AUDIT_ENTITY_SEPARATE_CLASS = "AUDIT_FIELDS_ENTITY_MUST_USE_SEPARATE_BASE_CLASS"
RULE_AUDIT_DTO_SEPARATE_CLASS = "AUDIT_FIELDS_DTO_MUST_USE_SEPARATE_MODEL"
RULE_EXCEPTION_SERIAL_VERSION_UID = "EXCEPTION_MUST_DECLARE_SERIAL_VERSION_UID"
RULE_IF_REQUIRES_COMMENT = "IF_STATEMENT_REQUIRES_PRECEDING_COMMENT"
RULE_THROW_REQUIRES_COMMENT = "THROW_STATEMENT_REQUIRES_PRECEDING_COMMENT"
RULE_FOR_REQUIRES_COMMENT = "FOR_STATEMENT_REQUIRES_PRECEDING_COMMENT"
RULE_STREAM_REQUIRES_COMMENT = "STREAM_CALL_REQUIRES_PRECEDING_COMMENT"
RULE_RETURN_REQUIRES_COMMENT = "RETURN_STATEMENT_REQUIRES_PRECEDING_COMMENT"
RULE_EXCEPTION_MESSAGE_I18N = "EXCEPTION_MESSAGE_MUST_USE_I18N_KEY"
RULE_MESSAGE_KEYS_BUNDLE = "ERROR_MESSAGE_KEYS_MUST_EXIST_IN_MESSAGE_BUNDLES"
RULE_VI_MESSAGES_ACCENTED = "VI_MESSAGES_MUST_BE_VIETNAMESE_ACCENTED"
RULE_REST_CONTROLLER_ADVICE_REQUIRED = "REST_CONTROLLER_ADVICE_REQUIRED"
RULE_CONTROLLER_NO_MANUAL_EXCEPTION_MAPPING = "CONTROLLER_NO_MANUAL_EXCEPTION_MAPPING"
RULE_NO_DIRECT_TRIM = "NO_DIRECT_TRIM_USE_STRINGUTILS"
RULE_NO_DIRECT_BLANK_CHECK = "NO_DIRECT_BLANK_CHECK_USE_STRINGUTILS"
RULE_NO_DIRECT_STRING_PREDICATE = "NO_DIRECT_STRING_PREDICATE_USE_STRINGUTILS"
RULE_NO_DIRECT_COLLECTION_EMPTY_CHECK = "NO_DIRECT_COLLECTION_EMPTY_CHECK_USE_COLLECTIONUTILS"
RULE_ONE_TOP_LEVEL_TYPE = "ONE_TOP_LEVEL_TYPE_PER_FILE"
RULE_NO_INNER_API_TYPES = "NO_INNER_DTO_ENUM_EXCEPTION_TYPES"
RULE_NO_MANUAL_LOGGER = "NO_MANUAL_LOGGER_USE_SLF4J"
RULE_CONSTANT_UTILITY_CLASS = "CONSTANT_CLASS_USES_UTILITYCLASS"

SEVERITY_ERROR = "ERROR"
SEVERITY_WARNING = "WARN"

CLASS_MAX_LINES = 300
REPORT_FILE = "backend_guard_report.json"
JAVA_EXTENSION = ".java"
I18N_ALLOW_TECHNICAL_LITERAL_MARKER = "backend-guard: allow-technical-literal"
MESSAGE_BUNDLE_FILES = (
    "src/main/resources/messages.properties",
    "src/main/resources/messages_vi.properties",
)
DTO_REQUEST_ACTION_PREFIXES = (
    "Create",
    "Update",
    "Delete",
    "Rename",
    "Patch",
    "Put",
    "Post",
    "List",
    "Search",
    "Sync",
    "Assign",
    "Unassign",
)

ENTITY_CLASS_PATTERN = re.compile(r"@\s*Entity\b")
ID_ANNOTATION_PATTERN = re.compile(r"@\s*Id\b")
VERSION_PATTERN = re.compile(r"@\s*Version\b")
EXTENDS_PATTERN = re.compile(r"\bextends\s+(\w+)")
LOMBOK_DATA_PATTERN = re.compile(r"@\s*Data\b")
CONFIGURATION_PROPERTIES_PATTERN = re.compile(r"@\s*ConfigurationProperties\b")
CONFIGURATION_PROPERTIES_PREFIX_PATTERN = re.compile(r'@\s*ConfigurationProperties\s*\(\s*prefix\s*=\s*"([^"]+)"')
REST_CONTROLLER_PATTERN = re.compile(r"^\s*@\s*RestController\b", re.MULTILINE)
REST_CONTROLLER_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*RestController\b")
TRANSACTIONAL_PATTERN = re.compile(r"^\s*@\s*Transactional\b")
MAPPING_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*(GetMapping|PostMapping|PutMapping|PatchMapping|DeleteMapping)\b")
OPERATION_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*Operation\b")
INTERFACE_PATTERN = re.compile(r"\binterface\s+\w+")
EXTENDS_JPA_PATTERN = re.compile(r"\bextends\s+[^{;]*JpaRepository<")
QUERY_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*Query\b")
DERIVED_QUERY_ORDERBY_PATTERN = re.compile(
    r"\b(?:find|read|get|query|search|stream|count|exists|delete|remove)[A-Za-z0-9_]*OrderBy[A-Z][A-Za-z0-9_]*\s*\("
)
SPECIFICATION_IMPORT_PATTERN = re.compile(r"^import\s+org\.springframework\.data\.jpa\.domain\.Specification\s*;$", re.MULTILINE)
CRITERIA_IMPORT_PATTERN = re.compile(r"^import\s+jakarta\.persistence\.criteria\.", re.MULTILINE)
SPECIFICATION_WHERE_PATTERN = re.compile(r"\bSpecification\s*\.\s*where\s*\(")
SPECIFICATION_FACTORY_METHOD_PATTERN = re.compile(r"\bSpecification\s*<[^>]+>\s+\w+\s*\(")
SPECIFICATION_LAMBDA_PATTERN = re.compile(r"\(\s*root\s*,\s*query\s*,\s*builder\s*\)\s*->")
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
SHARED_FIELD_DECLARATION_PATTERN = re.compile(r"\b(id|createdAt|updatedAt|deletedAt|version)\b")
AUDIT_FIELD_DECLARATION_PATTERN = re.compile(r"\b(createdAt|updatedAt|deletedAt)\b")
SPRING_BEAN_PATTERN = re.compile(r"@\s*(Service|Component|RestController|Controller|Configuration|RestControllerAdvice)\b")
REQUIRED_ARGS_CONSTRUCTOR_PATTERN = re.compile(r"@\s*RequiredArgsConstructor\b")
FINAL_FIELD_PATTERN = re.compile(r"^\s*private\s+final\s+[\w<>, ?\[\]]+\s+\w+\s*;")
LOMBOK_GETTER_OR_SETTER_PATTERN = re.compile(r"@\s*(Getter|Setter)\b")
MANUAL_GETTER_OR_SETTER_PATTERN = re.compile(r"^\s*public\s+[\w<>, ?\[\]]+\s+(get|set|is)[A-Z]\w*\s*\(")
LOMBOK_BUILDER_PATTERN = re.compile(r"@\s*Builder\b")
RECORD_PATTERN = re.compile(r"\brecord\s+[A-Z]\w*\s*\(")
PRIVATE_FIELD_PATTERN = re.compile(r"^\s*private\s+[\w<>, ?\[\]]+\s+\w+\s*;")
FINAL_FIELD_CAPTURE_PATTERN = re.compile(r"^\s*private\s+final\s+([\w<>, ?\[\].]+)\s+(\w+)\s*;")
ELSE_PATTERN = re.compile(r"\belse\b")
MAPPED_SUPERCLASS_PATTERN = re.compile(r"@\s*MappedSuperclass\b")
EXCEPTION_CLASS_PATTERN = re.compile(r"\bclass\s+([A-Z]\w*Exception)\s+extends\s+[\w.]*Exception\b")
SERIAL_VERSION_UID_PATTERN = re.compile(r"private\s+static\s+final\s+long\s+serialVersionUID\s*=\s*[-]?\d+L\s*;")
VIETNAMESE_ACCENTED_CHAR_PATTERN = re.compile(r"[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ]")
THROW_NEW_EXCEPTION_LITERAL_PATTERN = re.compile(r'throw\s+new\s+[A-Za-z_][A-Za-z0-9_]*Exception\s*\([^)]*"([^"]+)"')
RESPONSE_STATUS_EXCEPTION_LITERAL_PATTERN = re.compile(r'new\s+ResponseStatusException\s*\([^)]*"([^"]+)"')
MESSAGE_SOURCE_LITERAL_PATTERN = re.compile(r'messageSource\s*\.\s*getMessage\s*\(\s*"([^"]+)"')
MESSAGE_KEY_CONSTANT_PATTERN = re.compile(r'public\s+static\s+final\s+String\s+[A-Z0-9_]+\s*=\s*"([^"]+)";')
DIRECT_TRIM_PATTERN = re.compile(r"\.\s*trim\s*\(")
DIRECT_IS_BLANK_PATTERN = re.compile(r"\.\s*isBlank\s*\(")
NULL_OR_BLANK_PATTERN = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*==\s*null\s*\|\|\s*!?\s*\1\s*\.\s*isBlank\s*\(")
DIRECT_STARTS_WITH_PATTERN = re.compile(r"\.\s*startsWith\s*\(")
DIRECT_ENDS_WITH_PATTERN = re.compile(r"\.\s*endsWith\s*\(")
DIRECT_EQUALS_IGNORE_CASE_PATTERN = re.compile(r"\.\s*equalsIgnoreCase\s*\(")
NULL_OR_EMPTY_SAME_VAR_PATTERN = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*==\s*null\s*\|\|\s*\1\s*\.\s*isEmpty\s*\(")
NOT_NULL_AND_NOT_EMPTY_SAME_VAR_PATTERN = re.compile(
    r"\b([A-Za-z_][A-Za-z0-9_]*)\s*!=\s*null\s*&&\s*!\s*\1\s*\.\s*isEmpty\s*\("
)
DIRECT_IS_EMPTY_CALL_PATTERN = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\s*\.\s*isEmpty\s*\(")
IMPORT_STATEMENT_PATTERN = re.compile(r"^\s*import\s+([\w.]+)\s*;\s*$")
TYPE_DECLARATION_PATTERN = re.compile(
    r"^\s*(?:public|protected|private)?\s*(?:(?:abstract|final|sealed|non-sealed|static)\s+)*(class|record|enum|interface)\s+([A-Z]\w*)\b"
)
REQUEST_BODY_TYPE_PATTERN = re.compile(r"@RequestBody\s+(?:final\s+)?([A-Z]\w+)")
BEAN_VALIDATION_ANNOTATION_PATTERN = re.compile(
    r"@\s*(Valid|Validated|NotBlank|NotNull|NotEmpty|Positive|PositiveOrZero|Size|Email|Pattern|Min|Max|Past|PastOrPresent|Future|FutureOrPresent|AssertTrue|AssertFalse|DecimalMin|DecimalMax)\b"
)
REST_CONTROLLER_ADVICE_PATTERN = re.compile(r"^\s*@\s*RestControllerAdvice\b", re.MULTILINE)
EXCEPTION_HANDLER_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*ExceptionHandler\b")
WRITE_MAPPING_PATTERN = re.compile(r"^\s*@\s*(PostMapping|PutMapping|PatchMapping)\b")
MANUAL_EXCEPTION_CATCH_PATTERN = re.compile(
    r"catch\s*\(\s*(?:final\s+)?(?:[\w.]+\.)?(ApiException|BadRequestException|ConflictException|ResourceNotFoundException|UnauthorizedException|ResponseStatusException|RuntimeException|Exception)\s+\w+\s*\)"
)
MANUAL_LOGGER_IMPORT_PATTERN = re.compile(r"^import\s+org\.slf4j\.(Logger|LoggerFactory)\s*;$", re.MULTILINE)
LOGGER_FACTORY_PATTERN = re.compile(r"\bLoggerFactory\.getLogger\s*\(")
LOGGER_FIELD_PATTERN = re.compile(r"\bLogger\s+[A-Za-z_][A-Za-z0-9_]*\s*=")
UTILITY_CLASS_PATTERN = re.compile(r"@\s*UtilityClass\b")
MAPPER_ANNOTATION_PATTERN = re.compile(r"^\s*@\s*Mapper\b", re.MULTILINE)
PROPERTIES_INTERNAL_CONSTANT_PATTERN = re.compile(r"^\s*private\s+static\s+final\b")
PROPERTIES_INTERNAL_FALLBACK_PATTERN = re.compile(
    r"defaultIfBlank\s*\(|defaultIfEmpty\s*\(|defaultString\s*\(|"
    r"Objects\.requireNonNullElse(?:Get)?\s*\(|Optional\.ofNullable\s*\(.*\)\.orElse(?:Get)?\s*\(|"
    r"\?\s*(?:List\.of\s*\(|Set\.of\s*\(|Map\.of\s*\(|Collections\.\w+\s*\(|Locale\.\w+|"
    r'"[^"]*"|\'[^\']*\'|\d+L?\b|true\b|false\b|[A-Z][A-Z0-9_]*\b)'
)
RESPONSE_STATUS_EXCEPTION_PATTERN = re.compile(r"\bResponseStatusException\b")
COLLECTION_DECLARATION_PATTERN_TEMPLATE = r"\b(?:List|Set|Collection|Iterable|ArrayList|LinkedList|HashSet|LinkedHashSet)\s*<[^;=()]+>\s+{name}\b"
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


@dataclass(frozen=True)
class TypeDeclaration:
    kind: str
    name: str
    line: int
    indent: int


class Rule:
    name: str

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        raise NotImplementedError


class MaxClassLinesRule(Rule):
    name = RULE_CLASS_MAX_LINES

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        line_count = _effective_logic_line_count(file_ctx.lines)
        if line_count <= CLASS_MAX_LINES:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_WARNING,
                file=file_ctx.rel_path,
                line=1,
                reason=(
                    f"Class file exceeds {CLASS_MAX_LINES} logic lines after excluding imports, blanks, "
                    f"comments, JavaDoc, annotations, and top-level field declarations (found {line_count})."
                ),
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


class ConfigurationPropertiesNoInternalDefaultRule(Rule):
    name = RULE_PROPERTIES_NO_INTERNAL_DEFAULT

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if CONFIGURATION_PROPERTIES_PATTERN.search(file_ctx.text) is None:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = _strip_line_comment(raw).strip()
            if stripped == "":
                continue
            if PROPERTIES_INTERNAL_CONSTANT_PATTERN.search(stripped) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="ConfigurationProperties classes must not define internal constant defaults. Define values in application.yml instead.",
                        snippet=stripped,
                    )
                )
                continue
            if PROPERTIES_INTERNAL_FALLBACK_PATTERN.search(stripped) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="ConfigurationProperties classes must not hardcode fallback values. Define the property in application.yml instead.",
                    snippet=stripped,
                )
            )
        return violations


class ConfigurationPropertiesYamlDefinitionRule(Rule):
    name = RULE_PROPERTIES_DEFINED_IN_APPLICATION_YML

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if CONFIGURATION_PROPERTIES_PATTERN.search(file_ctx.text) is None:
            return []
        prefix = _configuration_properties_prefix(file_ctx.text)
        if prefix == "":
            return []
        component_names = _configuration_properties_component_names(file_ctx.text)
        if not component_names:
            return []
        project_root = _project_root_for_path(file_ctx.path)
        defined_keys = _application_yaml_defined_keys(project_root)
        violations: list[Violation] = []
        for component_name in component_names:
            expected_key = f"{prefix}.{_camel_to_kebab(component_name)}"
            if expected_key in defined_keys:
                continue
            line = _first_line_regex(file_ctx.lines, rf"\b{re.escape(component_name)}\b")
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=line if line > 0 else 1,
                    reason=f'ConfigurationProperties key "{expected_key}" must be defined in src/main/resources/application.yml.',
                    snippet=component_name,
                )
            )
        return violations


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


class NoElseRule(Rule):
    name = RULE_NO_ELSE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue
            if ELSE_PATTERN.search(line) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="else/else-if is forbidden. Use guard clauses and early return.",
                    snippet=raw.strip(),
                )
            )
        return violations


class NestedForShouldUseStreamRule(Rule):
    name = RULE_NESTED_FOR_STREAM

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        lines = file_ctx.lines
        for index, raw in enumerate(lines, start=1):
            if FOR_PATTERN.search(raw) is None:
                continue
            outer_indent = _indent_level(raw)
            window = _next_non_blank_lines(lines, index, 30)
            for line_no, candidate in window:
                if line_no <= index:
                    continue
                if FOR_PATTERN.search(candidate) is None:
                    continue
                inner_indent = _indent_level(candidate)
                if inner_indent <= outer_indent:
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=line_no,
                        reason="Nested for-loop detected; prefer Stream for inner iteration to reduce nesting.",
                        snippet=candidate.strip(),
                    )
                )
                break
        return violations


class LombokRequiredArgsConstructorRule(Rule):
    name = RULE_LOMBOK_REQUIRED_ARGS_CONSTRUCTOR

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if SPRING_BEAN_PATTERN.search(file_ctx.text) is None:
            return []
        final_fields = [raw for raw in file_ctx.lines if FINAL_FIELD_PATTERN.search(raw) is not None]
        if len(final_fields) == 0:
            return []
        if REQUIRED_ARGS_CONSTRUCTOR_PATTERN.search(file_ctx.text) is not None:
            return []
        class_name = _detect_primary_class_name(file_ctx.lines)
        has_constructor = False
        if class_name != "":
            constructor_regex = re.compile(rf"^\s*public\s+{re.escape(class_name)}\s*\(")
            has_constructor = any(constructor_regex.search(raw) is not None for raw in file_ctx.lines)
        if has_constructor:
            return [
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=1,
                    reason="Spring bean uses constructor injection; prefer @RequiredArgsConstructor to reduce boilerplate.",
                    snippet=file_ctx.rel_path,
                )
            ]
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=1,
                reason="Spring bean with final dependencies should use @RequiredArgsConstructor.",
                snippet=file_ctx.rel_path,
            )
        ]


class LombokEntityGetterSetterRule(Rule):
    name = RULE_LOMBOK_ENTITY_GETTER_SETTER

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if LOMBOK_GETTER_OR_SETTER_PATTERN.search(file_ctx.text) is not None:
            return []
        manual_methods = [raw for raw in file_ctx.lines if MANUAL_GETTER_OR_SETTER_PATTERN.search(raw) is not None]
        if len(manual_methods) < 4:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=1,
                reason="Entity has many manual getters/setters; prefer Lombok @Getter/@Setter.",
                snippet=file_ctx.rel_path,
            )
        ]


class LombokBuilderPreferredRule(Rule):
    name = RULE_LOMBOK_BUILDER_PREFERRED

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/dto/" not in file_ctx.rel_path:
            return []
        if RECORD_PATTERN.search(file_ctx.text) is not None:
            return []
        if " class " not in f" {file_ctx.text} ":
            return []
        if LOMBOK_BUILDER_PATTERN.search(file_ctx.text) is not None:
            return []
        field_count = sum(1 for raw in file_ctx.lines if PRIVATE_FIELD_PATTERN.search(raw) is not None)
        if field_count < 3:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=1,
                reason="DTO class has multiple fields; prefer Lombok @Builder for object construction.",
                snippet=file_ctx.rel_path,
            )
        ]


class SharedMappedSuperclassRule(Rule):
    name = RULE_SHARED_MAPPED_SUPERCLASS

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/entity/" not in file_ctx.rel_path:
            return []
        shared_field_lines = _find_shared_field_lines(file_ctx.lines)
        if len(shared_field_lines) < 2:
            return []
        if MAPPED_SUPERCLASS_PATTERN.search(file_ctx.text) is not None:
            return []
        line_number, raw = shared_field_lines[0]
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line_number,
                reason="Shared entity fields must live in a @MappedSuperclass base class.",
                snippet=raw.strip(),
            )
        ]


class AuditEntitySeparateClassRule(Rule):
    name = RULE_AUDIT_ENTITY_SEPARATE_CLASS

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if ENTITY_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if MAPPED_SUPERCLASS_PATTERN.search(file_ctx.text) is not None:
            return []
        extends_name = _extended_class_name(file_ctx.text) or ""
        if "Audit" in extends_name:
            return []
        audit_field_lines = _find_audit_field_lines(file_ctx.lines)
        if len(audit_field_lines) == 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=audit_field_lines[0][0],
                reason="Entity must place audit fields in a separate base class (MappedSuperclass).",
                snippet=audit_field_lines[0][1].strip(),
            )
        ]


class AuditDtoSeparateClassRule(Rule):
    name = RULE_AUDIT_DTO_SEPARATE_CLASS

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/dto/" not in file_ctx.rel_path:
            return []
        if RECORD_PATTERN.search(file_ctx.text) is not None:
            return []
        if "Audit" in file_ctx.rel_path:
            return []
        audit_field_lines = _find_audit_field_lines(file_ctx.lines)
        if len(audit_field_lines) == 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=audit_field_lines[0][0],
                reason="DTO must use a separate audit model instead of inline audit fields.",
                snippet=audit_field_lines[0][1].strip(),
            )
        ]


class ExceptionSerialVersionUidRule(Rule):
    name = RULE_EXCEPTION_SERIAL_VERSION_UID

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/exception/" not in file_ctx.rel_path:
            return []
        if EXCEPTION_CLASS_PATTERN.search(file_ctx.text) is None:
            return []
        if SERIAL_VERSION_UID_PATTERN.search(file_ctx.text) is not None:
            return []
        line = _first_line_regex(file_ctx.lines, r"\bclass\s+[A-Z]\w*Exception\b")
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line if line > 0 else 1,
                reason="Exception class must declare static final long serialVersionUID.",
                snippet=file_ctx.lines[line - 1].strip() if line > 0 else file_ctx.rel_path,
            )
        ]


class ExceptionMessageI18nRule(Rule):
    name = RULE_EXCEPTION_MESSAGE_I18N

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []
        if not any(
            token in file_ctx.rel_path
            for token in ("/controller/", "/service/", "/util/", "/mode/", "/security/", "/exception/")
        ):
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if I18N_ALLOW_TECHNICAL_LITERAL_MARKER in raw:
                continue
            if _has_comment_marker_above(file_ctx.lines, index, I18N_ALLOW_TECHNICAL_LITERAL_MARKER, 2):
                continue
            stripped = _strip_line_comment(raw).strip()
            if stripped == "":
                continue
            literal = _find_exception_literal(stripped)
            if literal is None:
                continue
            if _looks_like_message_key(literal):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Exception or message-source path must use i18n message keys instead of hardcoded user-facing text.",
                    snippet=raw.strip(),
                )
            )
        return violations


class NoDirectTrimRule(Rule):
    name = RULE_NO_DIRECT_TRIM

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue
            if "StringUtils.trim(" in line:
                continue
            if DIRECT_TRIM_PATTERN.search(line) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Direct .trim() is forbidden. Use StringUtils from Apache Commons Lang3.",
                    snippet=raw.strip(),
                )
            )
        return violations


class NoDirectBlankCheckRule(Rule):
    name = RULE_NO_DIRECT_BLANK_CHECK

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue
            if "StringUtils.isBlank(" in line or "StringUtils.isNotBlank(" in line:
                continue
            if NULL_OR_BLANK_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct null/blank check is forbidden. Use StringUtils.isBlank/isNotBlank.",
                        snippet=raw.strip(),
                    )
                )
                continue
            if DIRECT_IS_BLANK_PATTERN.search(line) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Direct .isBlank() is forbidden. Use StringUtils.isBlank/isNotBlank.",
                    snippet=raw.strip(),
                )
            )
        return violations


class NoDirectStringPredicateRule(Rule):
    name = RULE_NO_DIRECT_STRING_PREDICATE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue
            if (
                "StringUtils.isEmpty(" in line
                or "StringUtils.isNotEmpty(" in line
                or "StringUtils.startsWith(" in line
                or "StringUtils.endsWith(" in line
                or "StringUtils.equalsIgnoreCase(" in line
            ):
                continue
            if NULL_OR_EMPTY_SAME_VAR_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct null/empty check is forbidden. Use StringUtils.isEmpty/isNotEmpty.",
                        snippet=raw.strip(),
                    )
                )
                continue
            if DIRECT_STARTS_WITH_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct .startsWith() is forbidden. Use StringUtils.startsWith.",
                        snippet=raw.strip(),
                    )
                )
                continue
            if DIRECT_ENDS_WITH_PATTERN.search(line) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct .endsWith() is forbidden. Use StringUtils.endsWith.",
                        snippet=raw.strip(),
                    )
                )
                continue
            if DIRECT_EQUALS_IGNORE_CASE_PATTERN.search(line) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Direct .equalsIgnoreCase() is forbidden. Use StringUtils.equalsIgnoreCase.",
                    snippet=raw.strip(),
                )
            )
        return violations


class NoDirectCollectionEmptyCheckRule(Rule):
    name = RULE_NO_DIRECT_COLLECTION_EMPTY_CHECK

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            line = _strip_line_comment(raw).strip()
            if line == "":
                continue
            if "CollectionUtils.isEmpty(" in line or "CollectionUtils.isNotEmpty(" in line:
                continue

            same_var_match = NULL_OR_EMPTY_SAME_VAR_PATTERN.search(line)
            if same_var_match is not None:
                variable_name = same_var_match.group(1)
                if not _looks_like_collection_variable(file_ctx.lines, index, variable_name):
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct null/empty collection check is forbidden. Use CollectionUtils.isEmpty/isNotEmpty from Apache Commons Collections4.",
                        snippet=raw.strip(),
                    )
                )
                continue

            not_empty_match = NOT_NULL_AND_NOT_EMPTY_SAME_VAR_PATTERN.search(line)
            if not_empty_match is not None:
                variable_name = not_empty_match.group(1)
                if not _looks_like_collection_variable(file_ctx.lines, index, variable_name):
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Direct null/empty collection check is forbidden. Use CollectionUtils.isEmpty/isNotEmpty from Apache Commons Collections4.",
                        snippet=raw.strip(),
                    )
                )
                continue

            direct_empty_match = DIRECT_IS_EMPTY_CALL_PATTERN.search(line)
            if direct_empty_match is None:
                continue
            variable_name = direct_empty_match.group(1)
            if not _looks_like_collection_variable(file_ctx.lines, index, variable_name):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Direct collection .isEmpty() is forbidden. Use CollectionUtils.isEmpty/isNotEmpty from Apache Commons Collections4.",
                    snippet=raw.strip(),
                )
            )
        return violations


class OneTopLevelTypePerFileRule(Rule):
    name = RULE_ONE_TOP_LEVEL_TYPE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []
        declarations = _type_declarations(file_ctx.lines)
        top_level = [item for item in declarations if item.indent == 0]
        if len(top_level) <= 1:
            return []
        duplicate = top_level[1]
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=duplicate.line,
                reason="Java source file must declare exactly one top-level type.",
                snippet=file_ctx.lines[duplicate.line - 1].strip(),
            )
        ]


class NoInnerApiTypesRule(Rule):
    name = RULE_NO_INNER_API_TYPES

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []
        violations: list[Violation] = []
        for declaration in _type_declarations(file_ctx.lines):
            if declaration.indent == 0:
                continue
            if declaration.kind == "enum" or declaration.name.endswith(("Dto", "Request", "Response", "Exception")):
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=declaration.line,
                        reason="Keep DTOs, request or response models, exceptions, and enums as top-level types.",
                        snippet=file_ctx.lines[declaration.line - 1].strip(),
                    )
                )
        return violations


class ManualLoggerRule(Rule):
    name = RULE_NO_MANUAL_LOGGER

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        line = _first_line_regex(file_ctx.lines, r"^\s*import\s+org\.slf4j\.(Logger|LoggerFactory)\s*;")
        if line > 0:
            return [
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=line,
                    reason="Manual SLF4J logger wiring is forbidden. Use Lombok @Slf4j when logging is required.",
                    snippet=file_ctx.lines[line - 1].strip(),
                )
            ]

        line = _first_line_regex(file_ctx.lines, r"\bLoggerFactory\.getLogger\s*\(")
        if line > 0:
            return [
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=line,
                    reason="Manual LoggerFactory usage is forbidden. Use Lombok @Slf4j when logging is required.",
                    snippet=file_ctx.lines[line - 1].strip(),
                )
            ]

        line = _first_line_regex(file_ctx.lines, r"\bLogger\s+[A-Za-z_][A-Za-z0-9_]*\s*=")
        if line <= 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line,
                reason="Manual Logger fields are forbidden. Use Lombok @Slf4j when logging is required.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class ConstantUtilityClassRule(Rule):
    name = RULE_CONSTANT_UTILITY_CLASS

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/constant/" not in file_ctx.rel_path:
            return []
        declarations = [item for item in _type_declarations(file_ctx.lines) if item.indent == 0]
        if len(declarations) == 0:
            return []
        primary = declarations[0]
        if primary.kind != "class":
            return []
        if UTILITY_CLASS_PATTERN.search(file_ctx.text) is not None:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=primary.line,
                reason="Constant holder classes must use Lombok @UtilityClass.",
                snippet=file_ctx.lines[primary.line - 1].strip(),
            )
        ]


class MapperUsesMapStructRule(Rule):
    name = RULE_MAPPER_USES_MAPSTRUCT

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/mapper/" not in file_ctx.rel_path:
            return []
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []

        declarations = [item for item in _type_declarations(file_ctx.lines) if item.indent == 0]
        primary = declarations[0] if len(declarations) > 0 else None
        violations: list[Violation] = []

        if MAPPER_ANNOTATION_PATTERN.search(file_ctx.text) is None:
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=primary.line if primary is not None else 1,
                    reason="Mapper package must use MapStruct @Mapper types instead of manual mapping utilities.",
                    snippet=file_ctx.lines[primary.line - 1].strip() if primary is not None else file_ctx.rel_path,
                )
            )
            return violations

        if "componentModel = MappingConstants.ComponentModel.SPRING" not in file_ctx.text:
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=primary.line if primary is not None else 1,
                    reason="MapStruct mappers must use Spring componentModel for dependency injection.",
                    snippet=file_ctx.lines[primary.line - 1].strip() if primary is not None else file_ctx.rel_path,
                )
            )

        if UTILITY_CLASS_PATTERN.search(file_ctx.text) is not None:
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=primary.line if primary is not None else 1,
                    reason="Mapper package must not use Lombok @UtilityClass manual mappers once MapStruct is adopted.",
                    snippet=file_ctx.lines[primary.line - 1].strip() if primary is not None else file_ctx.rel_path,
                )
            )

        if primary is not None and primary.kind != "interface":
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=primary.line,
                    reason="MapStruct mappers in this repo must be declared as interfaces.",
                    snippet=file_ctx.lines[primary.line - 1].strip(),
                )
            )

        return violations


class DtoPackageStructureRule(Rule):
    name = RULE_DTO_PACKAGE_STRUCTURE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/dto/" not in file_ctx.rel_path:
            return []
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []

        declarations = [item for item in _type_declarations(file_ctx.lines) if item.indent == 0]
        primary = declarations[0] if len(declarations) > 0 else None
        violations: list[Violation] = []

        package_line = _first_line_regex(file_ctx.lines, r"^\s*package\s+com\.memora\.app\.dto(?:\.[a-z][a-z0-9_]*)*\s*;")
        package_text = file_ctx.lines[package_line - 1].strip() if package_line > 0 else ""

        allowed_segments = ("/dto/common/", "/dto/request/", "/dto/response/")
        if not any(segment in file_ctx.rel_path for segment in allowed_segments):
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=package_line if package_line > 0 else 1,
                    reason="DTO files must live under dto/common, dto/request, or dto/response.",
                    snippet=package_text if package_text != "" else file_ctx.rel_path,
                )
            )
            return violations

        relative_to_dto = file_ctx.rel_path.split("/dto/", 1)[1]
        package_segments = relative_to_dto.split("/")[:-1]
        expected_package = f"package com.memora.app.dto.{'.'.join(package_segments)};" if len(package_segments) > 0 else ""

        if package_text != expected_package:
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=package_line if package_line > 0 else 1,
                    reason="DTO package declaration must match its dto/common, dto/request, or dto/response folder.",
                    snippet=package_text if package_text != "" else file_ctx.rel_path,
                )
            )

        invalid_segment = next((segment for segment in package_segments if not _is_valid_package_segment(segment)), None)
        if invalid_segment is not None:
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=package_line if package_line > 0 else 1,
                    reason="DTO package segments must use lowercase or snake_case only; camelCase and uppercase package names are forbidden.",
                    snippet=invalid_segment,
                )
            )

        if primary is None:
            return violations

        if "/dto/request/" in file_ctx.rel_path:
            request_relative = relative_to_dto.split("request/", 1)[1]
            if "/" not in request_relative:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=primary.line,
                        reason="dto/request must group DTOs under an object package such as dto/request/deck or dto/request/auth.",
                        snippet=file_ctx.lines[primary.line - 1].strip(),
                    )
                )
            else:
                object_segment = request_relative.split("/", 1)[0]
                expected_object_segment = _expected_dto_object_segment(file_ctx, "request")
                if expected_object_segment is not None and object_segment != expected_object_segment:
                    violations.append(
                        Violation(
                            rule=self.name,
                            severity=SEVERITY_ERROR,
                            file=file_ctx.rel_path,
                            line=package_line if package_line > 0 else primary.line,
                            reason=(
                                "dto/request object package must use the canonical snake_case name derived "
                                f"from its DTO types. Expected '{expected_object_segment}'."
                            ),
                            snippet=object_segment,
                        )
                    )

        if "/dto/request/" in file_ctx.rel_path and not primary.name.endswith("Request"):
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=primary.line,
                    reason="dto/request may contain request contract types only, and each type must end with Request.",
                    snippet=file_ctx.lines[primary.line - 1].strip(),
                )
            )

        if "/dto/response/" in file_ctx.rel_path:
            response_relative = relative_to_dto.split("response/", 1)[1]
            if "/" not in response_relative:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=primary.line,
                        reason="dto/response must group DTOs under an object package such as dto/response/deck or dto/response/auth.",
                        snippet=file_ctx.lines[primary.line - 1].strip(),
                    )
                )
            else:
                object_segment = response_relative.split("/", 1)[0]
                expected_object_segment = _expected_dto_object_segment(file_ctx, "response")
                if expected_object_segment is not None and object_segment != expected_object_segment:
                    violations.append(
                        Violation(
                            rule=self.name,
                            severity=SEVERITY_ERROR,
                            file=file_ctx.rel_path,
                            line=package_line if package_line > 0 else primary.line,
                            reason=(
                                "dto/response object package must use the canonical snake_case name derived "
                                f"from its DTO types. Expected '{expected_object_segment}'."
                            ),
                            snippet=object_segment,
                        )
                    )

        if "/dto/response/" in file_ctx.rel_path and not primary.name.endswith("Response"):
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=primary.line,
                    reason="dto/response may contain response contract types only, and each type must end with Response.",
                    snippet=file_ctx.lines[primary.line - 1].strip(),
                )
            )

        if "/dto/common/" in file_ctx.rel_path and primary.name.endswith("Request"):
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=primary.line,
                    reason="Request contract types must live under dto/request, not dto/common.",
                    snippet=file_ctx.lines[primary.line - 1].strip(),
                )
            )

        return violations


class EnumPackageStructureRule(Rule):
    name = RULE_ENUM_PACKAGE_STRUCTURE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/enums/" not in file_ctx.rel_path:
            return []
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []

        declarations = [item for item in _type_declarations(file_ctx.lines) if item.indent == 0]
        primary = declarations[0] if len(declarations) > 0 else None
        violations: list[Violation] = []

        package_line = _first_line_regex(file_ctx.lines, r"^\s*package\s+com\.memora\.app\.enums(?:\.[a-z][a-z0-9_]*)*\s*;")
        package_text = file_ctx.lines[package_line - 1].strip() if package_line > 0 else ""

        relative_to_enums = file_ctx.rel_path.split("/enums/", 1)[1]
        package_segments = relative_to_enums.split("/")[:-1]
        expected_package = f"package com.memora.app.enums.{'.'.join(package_segments)};" if len(package_segments) > 0 else "package com.memora.app.enums;"

        if package_text != expected_package:
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=package_line if package_line > 0 else 1,
                    reason="Enum package declaration must match its enums/<domain> folder.",
                    snippet=package_text if package_text != "" else file_ctx.rel_path,
                )
            )

        invalid_segment = next((segment for segment in package_segments if not _is_valid_package_segment(segment)), None)
        if invalid_segment is not None:
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=package_line if package_line > 0 else 1,
                    reason="Enum package segments must use lowercase or snake_case only; camelCase and uppercase package names are forbidden.",
                    snippet=invalid_segment,
                )
            )

        if primary is None:
            return violations

        if len(package_segments) == 0:
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=primary.line,
                    reason="Enum types must live under enums/<domain> subpackages, not directly under enums.",
                    snippet=file_ctx.lines[primary.line - 1].strip(),
                )
            )

        return violations


class ControllerServiceOnlyDependencyRule(Rule):
    name = RULE_CONTROLLER_SERVICE_ONLY

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        imports = _imports_by_simple_name(file_ctx.lines)
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = _strip_line_comment(raw).strip()
            if stripped == "":
                continue

            import_match = IMPORT_STATEMENT_PATTERN.match(stripped)
            if import_match is not None:
                fqcn = import_match.group(1)
                if not fqcn.startswith("com.memora.app."):
                    continue
                if not any(token in fqcn for token in (".repository.", ".entity.", ".mapper.", ".service.impl.", ".controller.")):
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Controller layer must depend on service contracts, not repository, entity, mapper, implementation, or controller packages.",
                        snippet=stripped,
                    )
                )
                continue

            field_match = FINAL_FIELD_CAPTURE_PATTERN.match(stripped)
            if field_match is None:
                continue
            type_name = _extract_simple_type_name(field_match.group(1))
            if type_name == "":
                continue
            fqcn = imports.get(type_name, "")
            if fqcn == "":
                if not type_name.endswith(("Repository", "Mapper", "Entity", "Controller")):
                    continue
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Injected controller dependencies must be service contracts.",
                        snippet=stripped,
                    )
                )
                continue
            if not fqcn.startswith("com.memora.app."):
                continue
            if ".service." in fqcn and ".service.impl." not in fqcn:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Injected project dependencies in controller layer must come from the service package.",
                    snippet=stripped,
                )
            )
        return violations


class ServiceNoControllerDependencyRule(Rule):
    name = RULE_SERVICE_NO_CONTROLLER_DEP

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/service/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        imports = _imports_by_simple_name(file_ctx.lines)
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = _strip_line_comment(raw).strip()
            if stripped == "":
                continue

            import_match = IMPORT_STATEMENT_PATTERN.match(stripped)
            if import_match is not None and ".controller." in import_match.group(1):
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Service layer must not depend on controller types.",
                        snippet=stripped,
                    )
                )
                continue

            field_match = FINAL_FIELD_CAPTURE_PATTERN.match(stripped)
            if field_match is None:
                continue
            type_name = _extract_simple_type_name(field_match.group(1))
            if type_name == "":
                continue
            fqcn = imports.get(type_name, "")
            if fqcn == "" and not type_name.endswith("Controller"):
                continue
            if fqcn != "" and ".controller." not in fqcn:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Service layer must not inject controller collaborators.",
                    snippet=stripped,
                )
            )
        return violations


class TransactionalServiceOnlyRule(Rule):
    name = RULE_TRANSACTIONAL_SERVICE_ONLY

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []
        if "/service/" in file_ctx.rel_path:
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
                reason="@Transactional is allowed only in the service layer.",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


class ControllerEntitySignatureRule(Rule):
    name = RULE_CONTROLLER_ENTITY_SIGNATURE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        imports = _imports_by_simple_name(file_ctx.lines)
        entity_types = {simple for simple, fqcn in imports.items() if ".entity." in fqcn}
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = raw.strip()
            if not PUBLIC_METHOD_START_PATTERN.search(stripped):
                continue
            if " class " in stripped:
                continue
            signature = _collect_method_signature(file_ctx.lines, index, 12)
            signature_entity_types = {
                match.group(0)
                for match in re.finditer(r"\b[A-Z]\w*Entity\b", signature)
                if match.group(0) != "ResponseEntity"
            }
            if len(signature_entity_types) == 0 and not any(
                re.search(rf"\b{re.escape(type_name)}\b", signature) is not None for type_name in entity_types
            ):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Controller method signatures must expose DTOs or scalar contract types, not JPA entities.",
                    snippet=stripped,
                )
            )
        return violations


class ControllerRequestBodyDtoRule(Rule):
    name = RULE_CONTROLLER_REQUEST_BODY_DTO

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        imports = _imports_by_simple_name(file_ctx.lines)
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if "@RequestBody" not in raw:
                continue
            context = _collect_local_context(file_ctx.lines, index, before=1, after=3)
            type_name = _extract_request_body_type(context)
            if type_name == "":
                continue
            fqcn = imports.get(type_name, "")
            if type_name.endswith("Entity") or ".entity." in fqcn:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Controller request bodies must use DTO request models, not entities.",
                        snippet=raw.strip(),
                    )
                )
                continue
            if fqcn != "" and ".dto.request." in fqcn:
                continue
            if fqcn == "" and type_name.endswith("Request"):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Controller @RequestBody parameters must use types from the dto.request package.",
                    snippet=raw.strip(),
                )
            )
        return violations


class ControllerRequestBodyValidRule(Rule):
    name = RULE_CONTROLLER_REQUEST_BODY_VALID

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if "@RequestBody" not in raw:
                continue
            context = _collect_local_context(file_ctx.lines, index, before=1, after=1)
            if "@Valid" in context or "@Validated" in context:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Controller @RequestBody parameters must declare @Valid or @Validated.",
                    snippet=raw.strip(),
                )
            )
        return violations


class RequestDtoBeanValidationRule(Rule):
    name = RULE_REQUEST_DTO_BEAN_VALIDATION

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        imports = _imports_by_simple_name(file_ctx.lines)
        project_root = _project_root_for_path(file_ctx.path)
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            if "@RequestBody" not in raw:
                continue
            context = _collect_local_context(file_ctx.lines, index, before=2, after=3)
            type_name = _extract_request_body_type(context)
            if type_name == "":
                continue
            fqcn = imports.get(type_name, "")
            if type_name.endswith("Entity") or ".entity." in fqcn:
                continue
            if fqcn == "" and not type_name.endswith("Request"):
                continue
            if fqcn != "" and ".dto." not in fqcn:
                continue
            dto_path = _resolve_project_type_path(project_root, fqcn, fallback_simple_name=type_name, package_name="dto")
            if dto_path is None or not dto_path.exists():
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason=f'Cannot resolve request DTO source for "{type_name}" to verify Bean Validation annotations.',
                        snippet=raw.strip(),
                    )
                )
                continue
            if _has_bean_validation(dto_path):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason=f'Request DTO "{type_name}" must declare Bean Validation constraints.',
                    snippet=raw.strip(),
                )
            )
        return violations


class ControllerRequestDtoResponseRule(Rule):
    name = RULE_CONTROLLER_NO_REQUEST_DTO_RESPONSE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        imports = _imports_by_simple_name(file_ctx.lines)
        request_types = {simple for simple, fqcn in imports.items() if ".dto.request." in fqcn}
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = raw.strip()
            if not PUBLIC_METHOD_START_PATTERN.search(stripped):
                continue
            if " class " in stripped:
                continue
            signature = _collect_method_signature(file_ctx.lines, index, 12)
            return_type = _extract_return_type(signature)
            if return_type == "":
                continue
            if _segment_mentions_package_type(return_type, request_types, "com.memora.app.dto.request."):
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Controller responses must not use dto.request types. Use dto.response or dto.common models instead.",
                        snippet=stripped,
                    )
                )
        return violations


class MapperRequestDtoOutputRule(Rule):
    name = RULE_MAPPER_NO_REQUEST_DTO_OUTPUT

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/mapper/" not in file_ctx.rel_path:
            return []
        imports = _imports_by_simple_name(file_ctx.lines)
        request_types = {simple for simple, fqcn in imports.items() if ".dto.request." in fqcn}
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = raw.strip()
            if not PUBLIC_METHOD_START_PATTERN.search(stripped):
                continue
            if " class " in stripped:
                continue
            signature = _collect_method_signature(file_ctx.lines, index, 12)
            return_type = _extract_return_type(signature)
            if return_type == "":
                continue
            if _segment_mentions_package_type(return_type, request_types, "com.memora.app.dto.request."):
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Mapper output must not expose dto.request types. Map outward models to dto.response or dto.common only.",
                        snippet=stripped,
                    )
                )
        return violations


class ServiceContractDtoDirectionRule(Rule):
    name = RULE_SERVICE_CONTRACT_DTO_DIRECTION

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/service/" not in file_ctx.rel_path:
            return []
        if "/service/impl/" in file_ctx.rel_path:
            return []
        imports = _imports_by_simple_name(file_ctx.lines)
        request_types = {simple for simple, fqcn in imports.items() if ".dto.request." in fqcn}
        response_types = {simple for simple, fqcn in imports.items() if ".dto.response." in fqcn}
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = raw.strip()
            if not PUBLIC_METHOD_START_PATTERN.search(stripped):
                continue
            if " class " in stripped:
                continue
            signature = _collect_method_signature(file_ctx.lines, index, 12)
            return_type = _extract_return_type(signature)
            params_segment = _extract_params_segment(signature)

            if _segment_mentions_package_type(return_type, request_types, "com.memora.app.dto.request."):
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Service public contract must not return dto.request types.",
                        snippet=stripped,
                    )
                )

            if not _segment_mentions_package_type(params_segment, response_types, "com.memora.app.dto.response."):
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Service public contract must not accept dto.response types as input parameters.",
                    snippet=stripped,
                )
            )
        return violations


class ControllerManualExceptionMappingRule(Rule):
    name = RULE_CONTROLLER_NO_MANUAL_EXCEPTION_MAPPING

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/controller/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = _strip_line_comment(raw).strip()
            if stripped == "":
                continue
            if EXCEPTION_HANDLER_ANNOTATION_PATTERN.search(stripped) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Controller layer must not declare local exception handlers. Use the centralized RestControllerAdvice.",
                        snippet=stripped,
                    )
                )
                continue
            if MANUAL_EXCEPTION_CATCH_PATTERN.search(stripped) is not None:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=index,
                        reason="Controller layer must not catch business or broad exceptions to build manual responses.",
                        snippet=stripped,
                    )
                )
                continue
            if RESPONSE_STATUS_EXCEPTION_PATTERN.search(stripped) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Controller layer must delegate exception mapping to the centralized RestControllerAdvice strategy.",
                    snippet=stripped,
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


class RepositoryNoOrderByDerivedQueryRule(Rule):
    name = RULE_REPOSITORY_NO_ORDERBY_DERIVED_QUERY

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if "/repository/" not in file_ctx.rel_path:
            return []
        violations: list[Violation] = []
        for index, raw in enumerate(file_ctx.lines, start=1):
            stripped = _strip_line_comment(raw).strip()
            if stripped.startswith("@Query"):
                continue
            if DERIVED_QUERY_ORDERBY_PATTERN.search(stripped) is None:
                continue
            violations.append(
                Violation(
                    rule=self.name,
                    severity=SEVERITY_ERROR,
                    file=file_ctx.rel_path,
                    line=index,
                    reason="Repository derived query methods must not encode ORDER BY in the method name. Use Sort or Pageable instead.",
                    snippet=stripped,
                )
            )
        return violations


class JpaSpecificationRepositoryPackageRule(Rule):
    name = RULE_JPA_SPECIFICATION_ONLY_IN_REPOSITORY_SPECIFICATION

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []
        if "/repository/specification/" in file_ctx.rel_path:
            return []

        violations: list[Violation] = []
        if "/service/" in file_ctx.rel_path:
            import_line = _first_line_regex(file_ctx.lines, r"import\s+org\.springframework\.data\.jpa\.domain\.Specification")
            if import_line > 0:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=import_line,
                        reason="Service layer must not import Specification. Move all specification composition into com.memora.app.repository.specification.",
                        snippet=file_ctx.lines[import_line - 1].strip(),
                    )
                )
            where_line = _first_line_regex(file_ctx.lines, r"Specification\s*\.\s*where\s*\(")
            if where_line > 0:
                violations.append(
                    Violation(
                        rule=self.name,
                        severity=SEVERITY_ERROR,
                        file=file_ctx.rel_path,
                        line=where_line,
                        reason="Service layer must not call Specification.where(...). Compose specifications inside com.memora.app.repository.specification.",
                        snippet=file_ctx.lines[where_line - 1].strip(),
                    )
                )

        if CRITERIA_IMPORT_PATTERN.search(file_ctx.text) is None and SPECIFICATION_LAMBDA_PATTERN.search(file_ctx.text) is None:
            if SPECIFICATION_FACTORY_METHOD_PATTERN.search(file_ctx.text) is None:
                return violations

        line = _first_line_regex(
            file_ctx.lines,
            r"import\s+jakarta\.persistence\.criteria\.|\(\s*root\s*,\s*query\s*,\s*builder\s*\)\s*->|\bSpecification\s*<[^>]+>\s+\w+\s*\(",
        )
        violations.append(
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line if line > 0 else 1,
                reason="JpaSpecificationExecutor predicate logic must live under com.memora.app.repository.specification.",
                snippet=file_ctx.lines[line - 1].strip() if line > 0 else file_ctx.rel_path,
            )
        )
        return violations


class NoDeprecatedSpecificationWhereRule(Rule):
    name = RULE_NO_DEPRECATED_SPECIFICATION_WHERE

    def check(self, file_ctx: FileContext) -> Iterable[Violation]:
        if not file_ctx.rel_path.startswith("src/main/java/"):
            return []
        line = _first_line_regex(file_ctx.lines, r"Specification\s*\.\s*where\s*\(")
        if line <= 0:
            return []
        return [
            Violation(
                rule=self.name,
                severity=SEVERITY_ERROR,
                file=file_ctx.rel_path,
                line=line,
                reason="Specification.where(...) is deprecated and marked for removal. Use Specification.allOf(...) or Specification.anyOf(...).",
                snippet=file_ctx.lines[line - 1].strip(),
            )
        ]


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
        ConfigurationPropertiesNoInternalDefaultRule(),
        ConfigurationPropertiesYamlDefinitionRule(),
        OneTopLevelTypePerFileRule(),
        NoInnerApiTypesRule(),
        ManualLoggerRule(),
        ConstantUtilityClassRule(),
        MapperUsesMapStructRule(),
        DtoPackageStructureRule(),
        EnumPackageStructureRule(),
        ValidationMessageConstantRule(),
        InlineExceptionMessageRule(),
        JavaDocControllerRule(),
        JavaDocServiceRule(),
        ControllerServiceOnlyDependencyRule(),
        ServiceNoControllerDependencyRule(),
        ControllerRestRule(),
        ControllerTransactionalRule(),
        TransactionalServiceOnlyRule(),
        ControllerEntityResponseRule(),
        ControllerEntitySignatureRule(),
        ControllerApiVersionRule(),
        ControllerApiDocRule(),
        ControllerRequestBodyDtoRule(),
        ControllerRequestBodyValidRule(),
        RequestDtoBeanValidationRule(),
        ControllerRequestDtoResponseRule(),
        MapperRequestDtoOutputRule(),
        ServiceContractDtoDirectionRule(),
        ControllerManualExceptionMappingRule(),
        RepositoryJpaRule(),
        QueryMustUseNativeSqlRule(),
        QueryKeywordUppercaseRule(),
        RepositoryNoOrderByDerivedQueryRule(),
        JpaSpecificationRepositoryPackageRule(),
        NoDeprecatedSpecificationWhereRule(),
        EntityNoDataRule(),
        EntityHasIdRule(),
        EntityLayerDependencyRule(),
        EntityRelationFetchRule(),
        EntityManyToOneJoinColumnRule(),
        EntityAuditLifecycleRule(),
        EntityVersionRule(),
        EntityEnumeratedStringRule(),
        SoftDeleteNoHardDeleteRule(),
        NoElseRule(),
        NestedForShouldUseStreamRule(),
        LombokRequiredArgsConstructorRule(),
        LombokEntityGetterSetterRule(),
        LombokBuilderPreferredRule(),
        SharedMappedSuperclassRule(),
        AuditEntitySeparateClassRule(),
        AuditDtoSeparateClassRule(),
        ExceptionSerialVersionUidRule(),
        ExceptionMessageI18nRule(),
        NoDirectTrimRule(),
        NoDirectBlankCheckRule(),
        NoDirectStringPredicateRule(),
        NoDirectCollectionEmptyCheckRule(),
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
        RULE_MESSAGE_KEYS_BUNDLE,
        RULE_VI_MESSAGES_ACCENTED,
        RULE_REST_CONTROLLER_ADVICE_REQUIRED,
        RULE_DTO_ROOT_NO_DIRECT_CLASS,
        RULE_COMMON_DTO_SHARED_USAGE,
        RULE_ENUM_ROOT_NO_DIRECT_CLASS,
        RULE_ENTITY_COMMON_STRUCTURE,
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
        required_files = [root / Path(relative_path) for relative_path in MESSAGE_BUNDLE_FILES]
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

    if should_run_all or RULE_MESSAGE_KEYS_BUNDLE in selected_rule_names:
        violations.extend(_check_error_message_keys_in_bundles(root))

    if should_run_all or RULE_VI_MESSAGES_ACCENTED in selected_rule_names:
        violations.extend(_check_vietnamese_messages(root))

    if should_run_all or RULE_REST_CONTROLLER_ADVICE_REQUIRED in selected_rule_names:
        has_rest_controller_advice = any(
            REST_CONTROLLER_ADVICE_PATTERN.search(path.read_text(encoding="utf-8")) is not None
            for path in (root / "src" / "main" / "java").rglob(f"*{JAVA_EXTENSION}")
        )
        if not has_rest_controller_advice:
            violations.append(
                Violation(
                    rule=RULE_REST_CONTROLLER_ADVICE_REQUIRED,
                    severity=SEVERITY_ERROR,
                    file="src/main/java",
                    line=1,
                    reason="Backend must define a centralized @RestControllerAdvice exception strategy.",
                    snippet="@RestControllerAdvice",
                )
            )

    if should_run_all or RULE_DTO_ROOT_NO_DIRECT_CLASS in selected_rule_names:
        dto_root = root / "src" / "main" / "java" / "com" / "memora" / "app" / "dto"
        if dto_root.exists():
            direct_java_files = sorted(path for path in dto_root.glob(f"*{JAVA_EXTENSION}") if path.is_file())
            for direct_java_file in direct_java_files:
                violations.append(
                    Violation(
                        rule=RULE_DTO_ROOT_NO_DIRECT_CLASS,
                        severity=SEVERITY_ERROR,
                        file=direct_java_file.relative_to(root).as_posix(),
                        line=1,
                        reason="The dto root folder must not contain Java classes directly. Move files into dto/common, dto/request, or dto/response.",
                        snippet=direct_java_file.name,
                    )
                )

    if should_run_all or RULE_ENUM_ROOT_NO_DIRECT_CLASS in selected_rule_names:
        enums_root = root / "src" / "main" / "java" / "com" / "memora" / "app" / "enums"
        if enums_root.exists():
            direct_java_files = sorted(path for path in enums_root.glob(f"*{JAVA_EXTENSION}") if path.is_file())
            for direct_java_file in direct_java_files:
                violations.append(
                    Violation(
                        rule=RULE_ENUM_ROOT_NO_DIRECT_CLASS,
                        severity=SEVERITY_ERROR,
                        file=direct_java_file.relative_to(root).as_posix(),
                        line=1,
                        reason="The enums root folder must not contain Java types directly. Move files into enums/<domain> packages.",
                        snippet=direct_java_file.name,
                    )
                )

    if should_run_all or RULE_COMMON_DTO_SHARED_USAGE in selected_rule_names:
        violations.extend(_check_common_dto_usage(root))

    if should_run_all or RULE_ENTITY_COMMON_STRUCTURE in selected_rule_names:
        violations.extend(_check_entity_common_structure(root))

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


def _imports_by_simple_name(lines: list[str]) -> dict[str, str]:
    imports: dict[str, str] = {}
    for raw in lines:
        match = IMPORT_STATEMENT_PATTERN.match(raw.strip())
        if match is None:
            continue
        fqcn = match.group(1)
        imports[fqcn.split(".")[-1]] = fqcn
    return imports


def _extract_simple_type_name(type_expression: str) -> str:
    normalized = re.sub(r"<.*?>", "", type_expression)
    normalized = normalized.replace("[]", "").strip()
    if normalized == "":
        return ""
    return normalized.split(".")[-1].split(" ")[-1].strip("?")


def _collect_local_context(lines: list[str], line_number: int, *, before: int, after: int) -> str:
    start = max(0, line_number - 1 - before)
    end = min(len(lines), line_number + after)
    return " ".join(lines[start:end])


def _extract_request_body_type(context: str) -> str:
    match = REQUEST_BODY_TYPE_PATTERN.search(" ".join(context.split()))
    if match is None:
        return ""
    return match.group(1)


def _project_root_for_path(path: Path) -> Path:
    current = path if path.is_dir() else path.parent
    for candidate in (current, *current.parents):
        if (candidate / "pom.xml").exists():
            return candidate
    return current


def _resolve_project_type_path(
    root: Path,
    fqcn: str,
    *,
    fallback_simple_name: str,
    package_name: str,
) -> Path | None:
    if fqcn != "" and fqcn.startswith("com.memora.app."):
        return root / "src" / "main" / "java" / Path(*fqcn.split(".")).with_suffix(".java")
    if fallback_simple_name == "":
        return None
    return root / "src" / "main" / "java" / "com" / "memora" / "app" / package_name / f"{fallback_simple_name}.java"


def _configuration_properties_prefix(text: str) -> str:
    match = CONFIGURATION_PROPERTIES_PREFIX_PATTERN.search(text)
    if match is None:
        return ""
    return match.group(1).strip()


def _configuration_properties_component_names(text: str) -> list[str]:
    record_marker = re.search(r"\brecord\s+[A-Z]\w*\s*\(", text)
    if record_marker is None:
        return []
    start = record_marker.end()
    depth = 1
    angle_depth = 0
    index = start
    while index < len(text):
        current = text[index]
        if current == "<":
            angle_depth += 1
        elif current == ">" and angle_depth > 0:
            angle_depth -= 1
        elif current == "(" and angle_depth == 0:
            depth += 1
        elif current == ")" and angle_depth == 0:
            depth -= 1
            if depth == 0:
                break
        index += 1
    if depth != 0:
        return []
    header = text[start:index]
    component_names: list[str] = []
    for component in _split_top_level_csv(header):
        normalized = re.sub(r"@\w+(?:\([^)]*\))?\s*", "", " ".join(component.split()))
        if normalized == "":
            continue
        name = normalized.rsplit(" ", 1)[-1].strip()
        if re.match(r"^[A-Za-z_][A-Za-z0-9_]*$", name) is None:
            continue
        component_names.append(name)
    return component_names


def _split_top_level_csv(raw: str) -> list[str]:
    parts: list[str] = []
    current: list[str] = []
    angle_depth = 0
    paren_depth = 0
    bracket_depth = 0

    for char in raw:
        if char == "<":
            angle_depth += 1
        elif char == ">" and angle_depth > 0:
            angle_depth -= 1
        elif char == "(":
            paren_depth += 1
        elif char == ")" and paren_depth > 0:
            paren_depth -= 1
        elif char == "[":
            bracket_depth += 1
        elif char == "]" and bracket_depth > 0:
            bracket_depth -= 1

        if char == "," and angle_depth == 0 and paren_depth == 0 and bracket_depth == 0:
            part = "".join(current).strip()
            if part != "":
                parts.append(part)
            current = []
            continue
        current.append(char)

    tail = "".join(current).strip()
    if tail != "":
        parts.append(tail)
    return parts


def _camel_to_kebab(name: str) -> str:
    return re.sub(r"(?<!^)(?=[A-Z])", "-", name).lower()


def _application_yaml_defined_keys(root: Path) -> set[str]:
    path = root / "src" / "main" / "resources" / "application.yml"
    if not path.exists():
        return set()
    keys: set[str] = set()
    stack: list[tuple[int, str]] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.split("#", 1)[0].rstrip()
        if line.strip() == "":
            continue
        stripped = line.lstrip()
        if stripped.startswith("- "):
            continue
        indent = len(line) - len(stripped)
        while stack and stack[-1][0] >= indent:
            stack.pop()
        if ":" not in stripped:
            continue
        key, remainder = stripped.split(":", 1)
        key = key.strip().strip('"').strip("'")
        if key == "":
            continue
        full_key = ".".join([item[1] for item in stack] + [key])
        keys.add(full_key)
        if remainder.strip() == "":
            stack.append((indent, key))
    return keys


def _has_bean_validation(path: Path) -> bool:
    text = path.read_text(encoding="utf-8")
    if BEAN_VALIDATION_ANNOTATION_PATTERN.search(text) is not None:
        return True
    return "import jakarta.validation." in text


def _type_declarations(lines: list[str]) -> list[TypeDeclaration]:
    declarations: list[TypeDeclaration] = []
    for index, raw in enumerate(lines, start=1):
        stripped = _strip_line_comment(raw).strip()
        if stripped == "":
            continue
        match = TYPE_DECLARATION_PATTERN.match(raw)
        if match is None:
            continue
        declarations.append(
            TypeDeclaration(
                kind=match.group(1),
                name=match.group(2),
                line=index,
                indent=_indent_level(raw),
            )
        )
    return declarations


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


def _effective_logic_line_count(lines: list[str]) -> int:
    count = 0
    brace_depth = 0
    executable_entry_depth: int | None = None
    pending_signature = ""
    in_block_comment = False

    for raw in lines:
        stripped_line, in_block_comment = _strip_java_comments(raw, in_block_comment)
        current_depth = brace_depth
        stripped = stripped_line.strip()

        if executable_entry_depth is not None and current_depth < executable_entry_depth:
            executable_entry_depth = None

        if stripped != "":
            normalized = " ".join(stripped.split())

            if stripped.startswith("package ") or stripped.startswith("import ") or stripped.startswith("@"):
                pass
            elif executable_entry_depth is not None and current_depth >= executable_entry_depth:
                if not _is_braces_only_line(stripped):
                    count += 1
            elif current_depth == 1:
                if pending_signature != "":
                    pending_signature = f"{pending_signature} {normalized}".strip()
                    if "{" in normalized or normalized.endswith(";"):
                        executable_entry_depth, count = _open_executable_block(
                            pending_signature,
                            stripped_line,
                            current_depth,
                            count,
                        )
                        pending_signature = ""
                elif _looks_like_initializer_block(normalized):
                    executable_entry_depth, count = _open_executable_block(
                        normalized,
                        stripped_line,
                        current_depth,
                        count,
                    )
                elif _looks_like_executable_member_signature_start(normalized):
                    if "{" in normalized or normalized.endswith(";"):
                        executable_entry_depth, count = _open_executable_block(
                            normalized,
                            stripped_line,
                            current_depth,
                            count,
                        )
                    else:
                        pending_signature = normalized

        brace_depth += _brace_delta(stripped_line)
        if executable_entry_depth is not None and brace_depth < executable_entry_depth:
            executable_entry_depth = None

    return count


def _open_executable_block(
    normalized: str,
    stripped_line: str,
    current_depth: int,
    count: int,
) -> tuple[int | None, int]:
    if not _looks_like_executable_member_signature(normalized) and not _looks_like_initializer_block(normalized):
        return None, count
    next_depth = current_depth + _brace_delta(stripped_line)
    if _has_inline_logic_after_open_brace(normalized):
        count += 1
    if next_depth > current_depth:
        return next_depth, count
    return None, count


def _strip_java_comments(line: str, in_block_comment: bool) -> tuple[str, bool]:
    result: list[str] = []
    index = 0
    active_string: str | None = None
    escaped = False

    while index < len(line):
        if in_block_comment:
            end_index = line.find("*/", index)
            if end_index < 0:
                return "".join(result), True
            index = end_index + 2
            in_block_comment = False
            continue

        current = line[index]
        next_two = line[index:index + 2]

        if active_string is not None:
            result.append(current)
            if current == active_string and not escaped:
                active_string = None
            escaped = current == "\\" and not escaped
            index += 1
            continue

        if next_two == "//":
            break
        if next_two == "/*":
            in_block_comment = True
            index += 2
            continue
        if current in {'"', "'"}:
            active_string = current
            escaped = False
            result.append(current)
            index += 1
            continue

        result.append(current)
        index += 1

    return "".join(result), in_block_comment


def _brace_delta(line: str) -> int:
    delta = 0
    active_string: str | None = None
    escaped = False

    for current in line:
        if active_string is not None:
            if current == active_string and not escaped:
                active_string = None
            escaped = current == "\\" and not escaped
            continue
        if current in {'"', "'"}:
            active_string = current
            escaped = False
            continue
        if current == "{":
            delta += 1
        elif current == "}":
            delta -= 1

    return delta


def _looks_like_executable_member_signature_start(normalized: str) -> bool:
    if normalized == "":
        return False
    if normalized.startswith(("package ", "import ", "@")):
        return False
    if re.search(r"\b(class|interface|enum|record)\b", normalized) is not None:
        return False
    if "(" not in normalized:
        return False
    prefix = normalized.split("(", 1)[0]
    if "=" in prefix:
        return False
    if re.match(r"^(if|for|while|switch|catch|return|throw|new|else|do|try)\b", normalized) is not None:
        return False
    return True


def _looks_like_executable_member_signature(normalized: str) -> bool:
    if not _looks_like_executable_member_signature_start(normalized):
        return False
    return "{" in normalized or not normalized.endswith(";")


def _looks_like_initializer_block(normalized: str) -> bool:
    return normalized in {"{", "static {"} or normalized.startswith("static {")


def _has_inline_logic_after_open_brace(normalized: str) -> bool:
    if "{" not in normalized:
        return False
    trailing = normalized.split("{", 1)[1].strip()
    trailing = trailing.rstrip("}").strip()
    return trailing != ""


def _is_braces_only_line(stripped: str) -> bool:
    token = stripped.replace(";", "").replace(",", "").strip()
    return token != "" and set(token) <= {"{", "}"}


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


def _extract_params_segment(signature: str) -> str:
    normalized = " ".join(signature.split())
    start = normalized.find("(")
    end = normalized.rfind(")")
    if start < 0 or end < 0 or end <= start:
        return ""
    return normalized[start + 1:end].strip()


def _segment_mentions_package_type(segment: str, simple_names: set[str], package_prefix: str) -> bool:
    if segment == "":
        return False
    if package_prefix in segment:
        return True
    return any(re.search(rf"\b{re.escape(simple_name)}\b", segment) is not None for simple_name in simple_names)


def _is_valid_package_segment(segment: str) -> bool:
    return re.fullmatch(r"[a-z][a-z0-9_]*", segment) is not None


def _expected_dto_object_segment(file_ctx: FileContext, dto_scope: str) -> str | None:
    sibling_type_names = sorted(item.stem for item in file_ctx.path.parent.glob(f"*{JAVA_EXTENSION}"))
    normalized_word_sets: list[list[str]] = []
    for type_name in sibling_type_names:
        normalized_stem = _normalize_dto_object_stem(type_name, dto_scope)
        stem_words = _split_type_words(normalized_stem)
        if len(stem_words) == 0:
            continue
        normalized_word_sets.append(stem_words)
    if len(normalized_word_sets) == 0:
        return None
    common_words = list(normalized_word_sets[0])
    for stem_words in normalized_word_sets[1:]:
        shared_length = 0
        limit = min(len(common_words), len(stem_words))
        while shared_length < limit and common_words[shared_length] == stem_words[shared_length]:
            shared_length += 1
        common_words = common_words[:shared_length]
        if len(common_words) == 0:
            break
    if len(common_words) == 0:
        common_words = list(normalized_word_sets[0])
    return "_".join(word.lower() for word in common_words)


def _normalize_dto_object_stem(type_name: str, dto_scope: str) -> str:
    stem = type_name
    if dto_scope == "request" and stem.endswith("Request"):
        stem = stem[: -len("Request")]
        for prefix in DTO_REQUEST_ACTION_PREFIXES:
            if not stem.startswith(prefix) or len(stem) <= len(prefix):
                continue
            candidate = stem[len(prefix) :]
            if candidate != "" and candidate[0].isupper():
                return candidate
        return stem
    if dto_scope == "response" and stem.endswith("Response"):
        return stem[: -len("Response")]
    return stem


def _split_type_words(name: str) -> list[str]:
    return re.findall(r"[A-Z]+(?=[A-Z][a-z0-9]|$)|[A-Z]?[a-z0-9]+", name)


def _indent_level(raw: str) -> int:
    return len(raw) - len(raw.lstrip(" \t"))


def _find_shared_field_lines(lines: list[str]) -> list[tuple[int, str]]:
    results: list[tuple[int, str]] = []
    for index, raw in enumerate(lines, start=1):
        stripped = _strip_line_comment(raw).strip()
        if stripped == "":
            continue
        if SHARED_FIELD_DECLARATION_PATTERN.search(stripped) is None:
            continue
        results.append((index, raw))
    return results


def _find_audit_field_lines(lines: list[str]) -> list[tuple[int, str]]:
    results: list[tuple[int, str]] = []
    for index, raw in enumerate(lines, start=1):
        stripped = _strip_line_comment(raw).strip()
        if stripped == "":
            continue
        if AUDIT_FIELD_DECLARATION_PATTERN.search(stripped) is None:
            continue
        results.append((index, raw))
    return results


def _has_comment_marker_above(lines: list[str], start_line: int, marker: str, max_lookback: int) -> bool:
    start_index = start_line - 2
    end_index = max(-1, start_index - max_lookback)
    for index in range(start_index, end_index, -1):
        raw = lines[index].strip()
        if raw == "":
            continue
        if marker in raw:
            return True
        if raw.startswith("//") or raw.startswith("*") or raw.startswith("/*"):
            continue
        return False
    return False


def _find_exception_literal(stripped: str) -> str | None:
    for pattern in (
        THROW_NEW_EXCEPTION_LITERAL_PATTERN,
        RESPONSE_STATUS_EXCEPTION_LITERAL_PATTERN,
        MESSAGE_SOURCE_LITERAL_PATTERN,
    ):
        match = pattern.search(stripped)
        if match is None:
            continue
        return match.group(1)
    return None


def _looks_like_message_key(value: str) -> bool:
    return re.fullmatch(r"[a-z0-9]+(?:[.-][a-z0-9]+)+", value) is not None


def _looks_like_collection_variable(lines: list[str], line_number: int, variable_name: str) -> bool:
    declaration_pattern = re.compile(COLLECTION_DECLARATION_PATTERN_TEMPLATE.format(name=re.escape(variable_name)))
    record_pattern = re.compile(rf"\bList\s*<[^;=()]+>\s+{re.escape(variable_name)}\b")
    start_index = max(0, line_number - 40)
    end_index = min(len(lines), line_number)
    for index in range(start_index, end_index):
        stripped = _strip_line_comment(lines[index]).strip()
        if stripped == "":
            continue
        if declaration_pattern.search(stripped) is not None:
            return True
        if record_pattern.search(stripped) is not None:
            return True
    return False


def _load_message_bundle_keys(bundle_path: Path) -> set[str]:
    keys: set[str] = set()
    for raw in bundle_path.read_text(encoding="utf-8").splitlines():
        stripped = raw.strip()
        if stripped == "" or stripped.startswith("#") or "=" not in stripped:
            continue
        key, _ = stripped.split("=", 1)
        keys.add(key.strip())
    return keys


def _check_vietnamese_messages(root: Path) -> list[Violation]:
    file_path = root / "src" / "main" / "resources" / "messages_vi.properties"
    if not file_path.exists():
        return [
            Violation(
                rule=RULE_VI_MESSAGES_ACCENTED,
                severity=SEVERITY_ERROR,
                file="src/main/resources/messages_vi.properties",
                line=1,
                reason="Missing messages_vi.properties.",
                snippet="messages_vi.properties",
            )
        ]

    violations: list[Violation] = []
    relative = file_path.relative_to(root).as_posix()
    for index, raw in enumerate(file_path.read_text(encoding="utf-8").splitlines(), start=1):
        stripped = raw.strip()
        if stripped == "" or stripped.startswith("#") or "=" not in stripped:
            continue
        _, value = stripped.split("=", 1)
        normalized = value.strip()
        if normalized == "":
            continue
        if not any(ch.isalpha() for ch in normalized):
            continue
        if VIETNAMESE_ACCENTED_CHAR_PATTERN.search(normalized) is not None:
            continue
        violations.append(
            Violation(
                rule=RULE_VI_MESSAGES_ACCENTED,
                severity=SEVERITY_ERROR,
                file=relative,
                line=index,
                reason="Vietnamese message must contain accented Vietnamese characters.",
                snippet=raw.strip(),
            )
        )
    return violations


def _check_error_message_keys_in_bundles(root: Path) -> list[Violation]:
    key_file = root / "src" / "main" / "java" / "com" / "memora" / "app" / "constant" / "ApiMessageKey.java"
    if not key_file.exists():
        return [
            Violation(
                rule=RULE_MESSAGE_KEYS_BUNDLE,
                severity=SEVERITY_ERROR,
                file="src/main/java/com/memora/app/constant/ApiMessageKey.java",
                line=1,
                reason="Missing ApiMessageKey.java for backend i18n contract.",
                snippet="ApiMessageKey.java",
            )
        ]

    key_text = key_file.read_text(encoding="utf-8")
    key_lines = key_text.splitlines()
    defined_keys: list[tuple[int, str]] = []
    for match in MESSAGE_KEY_CONSTANT_PATTERN.finditer(key_text):
        defined_keys.append((_line_for_offset(key_lines, match.start()), match.group(1)))

    bundle_entries: dict[str, set[str]] = {}
    for relative_path in MESSAGE_BUNDLE_FILES:
        bundle_path = root / Path(relative_path)
        bundle_entries[relative_path] = _load_message_bundle_keys(bundle_path) if bundle_path.exists() else set()

    violations: list[Violation] = []
    key_relative = key_file.relative_to(root).as_posix()
    for line_number, key in defined_keys:
        for relative_path in MESSAGE_BUNDLE_FILES:
            if key in bundle_entries[relative_path]:
                continue
            violations.append(
                Violation(
                    rule=RULE_MESSAGE_KEYS_BUNDLE,
                    severity=SEVERITY_ERROR,
                    file=key_relative,
                    line=line_number,
                    reason=f'Message key "{key}" must exist in {relative_path}.',
                    snippet=key,
                )
            )
    return violations


def _check_common_dto_usage(root: Path) -> list[Violation]:
    common_root = root / "src" / "main" / "java" / "com" / "memora" / "app" / "dto" / "common"
    if not common_root.exists():
        return []

    java_files = _collect_java_files(root)
    violations: list[Violation] = []

    for common_file in sorted(common_root.rglob(f"*{JAVA_EXTENSION}")):
        lines = common_file.read_text(encoding="utf-8").splitlines()
        declarations = [item for item in _type_declarations(lines) if item.indent == 0]
        primary = declarations[0] if len(declarations) > 0 else None
        if primary is None:
            continue

        referencing_files = [
            file_ctx
            for file_ctx in java_files
            if file_ctx.path != common_file and re.search(rf"\b{re.escape(primary.name)}\b", file_ctx.text) is not None
        ]
        non_mapper_main_refs = [
            file_ctx
            for file_ctx in referencing_files
            if file_ctx.rel_path.startswith("src/main/java/") and "/mapper/" not in file_ctx.rel_path
        ]
        if len(non_mapper_main_refs) > 0:
            continue

        violations.append(
            Violation(
                rule=RULE_COMMON_DTO_SHARED_USAGE,
                severity=SEVERITY_ERROR,
                file=common_file.relative_to(root).as_posix(),
                line=primary.line,
                reason=(
                    "dto/common is reserved for shared reusable DTOs referenced by non-mapper main code. "
                    "Move object-specific DTOs out of dto/common or delete dead mapper-only artifacts."
                ),
                snippet=primary.name,
            )
        )

    return violations


def _check_entity_common_structure(root: Path) -> list[Violation]:
    entity_root = root / "src" / "main" / "java" / "com" / "memora" / "app" / "entity"
    common_root = entity_root / "common"
    violations: list[Violation] = []

    if not common_root.exists() or not common_root.is_dir():
        violations.append(
            Violation(
                rule=RULE_ENTITY_COMMON_STRUCTURE,
                severity=SEVERITY_ERROR,
                file="src/main/java/com/memora/app/entity/common",
                line=1,
                reason="entity/common package is required for shared base entities and mapped superclasses.",
                snippet="src/main/java/com/memora/app/entity/common",
            )
        )
        return violations

    common_java_files = sorted(common_root.rglob(f"*{JAVA_EXTENSION}"))
    if len(common_java_files) == 0:
        violations.append(
            Violation(
                rule=RULE_ENTITY_COMMON_STRUCTURE,
                severity=SEVERITY_ERROR,
                file="src/main/java/com/memora/app/entity/common",
                line=1,
                reason="entity/common must contain shared base entity classes or mapped superclasses.",
                snippet="entity/common",
            )
        )

    for common_file in common_java_files:
        text = common_file.read_text(encoding="utf-8")
        lines = text.splitlines()
        declarations = [item for item in _type_declarations(lines) if item.indent == 0]
        primary = declarations[0] if len(declarations) > 0 else None
        relative_path = common_file.relative_to(root).as_posix()

        if ENTITY_CLASS_PATTERN.search(text) is not None:
            violations.append(
                Violation(
                    rule=RULE_ENTITY_COMMON_STRUCTURE,
                    severity=SEVERITY_ERROR,
                    file=relative_path,
                    line=primary.line if primary is not None else 1,
                    reason="Concrete @Entity classes must not live under entity/common.",
                    snippet=primary.name if primary is not None else common_file.name,
                )
            )

        if MAPPED_SUPERCLASS_PATTERN.search(text) is None:
            violations.append(
                Violation(
                    rule=RULE_ENTITY_COMMON_STRUCTURE,
                    severity=SEVERITY_ERROR,
                    file=relative_path,
                    line=primary.line if primary is not None else 1,
                    reason="entity/common may contain only shared @MappedSuperclass base entities.",
                    snippet=primary.name if primary is not None else common_file.name,
                )
            )

    direct_entity_files = sorted(path for path in entity_root.glob(f"*{JAVA_EXTENSION}") if path.is_file())
    for direct_entity_file in direct_entity_files:
        text = direct_entity_file.read_text(encoding="utf-8")
        if MAPPED_SUPERCLASS_PATTERN.search(text) is None:
            continue
        lines = text.splitlines()
        declarations = [item for item in _type_declarations(lines) if item.indent == 0]
        primary = declarations[0] if len(declarations) > 0 else None
        violations.append(
            Violation(
                rule=RULE_ENTITY_COMMON_STRUCTURE,
                severity=SEVERITY_ERROR,
                file=direct_entity_file.relative_to(root).as_posix(),
                line=primary.line if primary is not None else 1,
                reason="Shared @MappedSuperclass base entities must live under entity/common, not the entity root package.",
                snippet=primary.name if primary is not None else direct_entity_file.name,
            )
        )

    return violations


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
            RULE_CONTROLLER_SERVICE_ONLY,
            RULE_CONTROLLER_REST,
            RULE_CONTROLLER_TX,
            RULE_TRANSACTIONAL_SERVICE_ONLY,
            RULE_CONTROLLER_ENTITY_RESPONSE,
            RULE_CONTROLLER_ENTITY_SIGNATURE,
            RULE_CONTROLLER_API_VERSION,
            RULE_CONTROLLER_API_DOC,
            RULE_CONTROLLER_REQUEST_BODY_DTO,
            RULE_CONTROLLER_REQUEST_BODY_VALID,
            RULE_REQUEST_DTO_BEAN_VALIDATION,
            RULE_CONTROLLER_NO_MANUAL_EXCEPTION_MAPPING,
            RULE_REST_CONTROLLER_ADVICE_REQUIRED,
            RULE_JAVADOC_CONTROLLER_REQUIRED,
        },
        "layer": {
            RULE_CONTROLLER_SERVICE_ONLY,
            RULE_SERVICE_NO_CONTROLLER_DEP,
            RULE_CONTROLLER_ENTITY_SIGNATURE,
            RULE_JPA_SPECIFICATION_ONLY_IN_REPOSITORY_SPECIFICATION,
        },
        "transaction": {
            RULE_CONTROLLER_TX,
            RULE_TRANSACTIONAL_SERVICE_ONLY,
        },
        "contract": {
            RULE_DTO_PACKAGE_STRUCTURE,
            RULE_DTO_ROOT_NO_DIRECT_CLASS,
            RULE_COMMON_DTO_SHARED_USAGE,
            RULE_ENUM_PACKAGE_STRUCTURE,
            RULE_ENUM_ROOT_NO_DIRECT_CLASS,
            RULE_MAPPER_USES_MAPSTRUCT,
            RULE_CONTROLLER_ENTITY_RESPONSE,
            RULE_CONTROLLER_ENTITY_SIGNATURE,
            RULE_CONTROLLER_REQUEST_BODY_DTO,
            RULE_CONTROLLER_REQUEST_BODY_VALID,
            RULE_REQUEST_DTO_BEAN_VALIDATION,
            RULE_CONTROLLER_NO_REQUEST_DTO_RESPONSE,
            RULE_MAPPER_NO_REQUEST_DTO_OUTPUT,
            RULE_SERVICE_CONTRACT_DTO_DIRECTION,
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
        "flow": {
            RULE_NO_ELSE,
            RULE_NESTED_FOR_STREAM,
        },
        "commons": {
            RULE_NO_DIRECT_TRIM,
            RULE_NO_DIRECT_BLANK_CHECK,
            RULE_NO_DIRECT_STRING_PREDICATE,
            RULE_NO_DIRECT_COLLECTION_EMPTY_CHECK,
        },
        "i18n": {
            RULE_CONSTANT_PACKAGE_EXISTS,
            RULE_MESSAGE_BUNDLE_EXISTS,
            RULE_VALIDATION_MESSAGE_CONSTANT,
            RULE_INLINE_EXCEPTION_MESSAGE,
            RULE_EXCEPTION_MESSAGE_I18N,
            RULE_MESSAGE_KEYS_BUNDLE,
            RULE_VI_MESSAGES_ACCENTED,
        },
        "jpa": {
            RULE_JPA_SPECIFICATION_ONLY_IN_REPOSITORY_SPECIFICATION,
            RULE_NO_DEPRECATED_SPECIFICATION_WHERE,
            RULE_REPOSITORY_EXTENDS_JPA,
            RULE_ENTITY_NO_DATA,
            RULE_ENTITY_HAS_ID,
            RULE_ENTITY_NO_LAYER_DEP,
            RULE_ENTITY_RELATION_FETCH,
            RULE_ENTITY_MANY_TO_ONE_JOIN,
            RULE_ENTITY_AUDIT_LIFECYCLE,
            RULE_ENTITY_OPTIMISTIC_LOCK,
            RULE_ENTITY_ENUM_STRING,
            RULE_ENTITY_COMMON_STRUCTURE,
            RULE_SHARED_MAPPED_SUPERCLASS,
            RULE_AUDIT_ENTITY_SEPARATE_CLASS,
            RULE_AUDIT_DTO_SEPARATE_CLASS,
            RULE_SOFT_DELETE_NO_HARD_DELETE,
        },
        "lombok": {
            RULE_LOMBOK_REQUIRED_ARGS_CONSTRUCTOR,
            RULE_LOMBOK_ENTITY_GETTER_SETTER,
            RULE_LOMBOK_BUILDER_PREFERRED,
            RULE_CONSTANT_UTILITY_CLASS,
        },
        "exception": {
            RULE_EXCEPTION_SERIAL_VERSION_UID,
            RULE_EXCEPTION_MESSAGE_I18N,
            RULE_REST_CONTROLLER_ADVICE_REQUIRED,
            RULE_CONTROLLER_NO_MANUAL_EXCEPTION_MAPPING,
        },
        "query": {
            RULE_QUERY_NATIVE_SQL_ONLY,
            RULE_QUERY_KEYWORD_UPPERCASE,
            RULE_REPOSITORY_NO_ORDERBY_DERIVED_QUERY,
            RULE_JPA_SPECIFICATION_ONLY_IN_REPOSITORY_SPECIFICATION,
            RULE_NO_DEPRECATED_SPECIFICATION_WHERE,
        },
        "config": {
            RULE_PROPERTIES_PACKAGE,
            RULE_PROPERTIES_NO_INTERNAL_DEFAULT,
            RULE_PROPERTIES_DEFINED_IN_APPLICATION_YML,
        },
        "shape": {
            RULE_DTO_PACKAGE_STRUCTURE,
            RULE_DTO_ROOT_NO_DIRECT_CLASS,
            RULE_COMMON_DTO_SHARED_USAGE,
            RULE_ENUM_PACKAGE_STRUCTURE,
            RULE_ENUM_ROOT_NO_DIRECT_CLASS,
            RULE_MAPPER_USES_MAPSTRUCT,
            RULE_ENTITY_COMMON_STRUCTURE,
            RULE_ONE_TOP_LEVEL_TYPE,
            RULE_NO_INNER_API_TYPES,
        },
        "logging": {
            RULE_NO_MANUAL_LOGGER,
            RULE_CONSTANT_UTILITY_CLASS,
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
