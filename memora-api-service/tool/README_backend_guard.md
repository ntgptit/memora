# Backend Guard (Memora Spring Boot + JPA)

## Run

```bash
python tool/verify_backend_checklists.py
python tool/verify_backend_checklists.py --strict
python tool/verify_backend_checklists.py --only=api
```

## Output

- Console: `file:line: [SEVERITY] RULE - reason`
- JSON report: `backend_guard_report.json` in the project root

## Rule Coverage

- `CLASS_MAX_LINES`
- `CONFIGURATION_PROPERTIES_IN_PROPERTIES_PACKAGE`
- `CONTROLLER_REST_CONTROLLER`
- `CONTROLLER_NO_TRANSACTIONAL`
- `CONTROLLER_NO_ENTITY_RESPONSE`
- `CONTROLLER_API_VERSIONING`
- `CONTROLLER_API_DOC_REQUIRED`
- `REPOSITORY_EXTENDS_JPA_REPOSITORY`
- `QUERY_MUST_USE_NATIVE_SQL`
- `QUERY_SQL_KEYWORDS_MUST_BE_UPPERCASE`
- `ENTITY_NO_LOMBOK_DATA`
- `ENTITY_HAS_ID`
- `ENTITY_NO_SERVICE_REPOSITORY_DEP`
- `ENTITY_RELATION_FETCH_LAZY`
- `ENTITY_MANY_TO_ONE_HAS_JOIN_COLUMN`
- `ENTITY_AUDIT_LIFECYCLE`
- `ENTITY_HAS_VERSION_FOR_OPTIMISTIC_LOCK`
- `ENTITY_ENUMERATED_STRING`
- `SOFT_DELETE_NO_HARD_DELETE_CALL`

## Notes

- Guard này bắt chước cấu trúc của Lumos nhưng được rút gọn cho Memora.
- Các rule i18n, MapStruct, JavaDoc bắt buộc, comment-before-if và các quy ước repo-specific khác chưa được bật ở Memora.
- `--strict` sẽ fail khi có cả warning.
