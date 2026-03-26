# Backend Guard (Memora Spring Boot + JPA)

## Run

```bash
python tool/verify_backend_checklists.py
python tool/verify_backend_checklists.py --strict
python tool/verify_backend_checklists.py --only=api
python tool/verify_backend_checklists.py --only=layer,contract
```

## Output

- Console: `file:line: [SEVERITY] RULE - reason`
- JSON report: `backend_guard_report.json` in the project root

## Rule Coverage

The guard currently verifies these categories:

- Structure and shape: class max logic lines only, excluding imports, blank lines, comments, JavaDoc, annotations, and top-level field declarations; one top-level type per file; no inner DTO or exception or enum API types; `dto/` root must not contain Java classes directly; request and response DTOs must be grouped under object packages such as `dto/request/deck` or `dto/response/auth`; object package names must use the canonical `snake_case` derived from the DTO type stem such as `review_profile`, `review_profile_box`, `deck_review_settings`, or `user_account`; package segments must use lowercase or `snake_case` only; DTO files must live under `dto/common`, `dto/request`, or `dto/response`; request types must end with `Request`; response types must end with `Response`; `dto/common` is reserved for shared reusable DTOs referenced by non-mapper main code rather than mapper-only object models; shared base entities or `@MappedSuperclass` classes must live under `entity/common` while concrete `@Entity` classes must stay outside that package; enum types must live under `enums/<domain>` packages such as `enums/review`, `enums/study`, `enums/flashcard`, or `enums/user_account` instead of directly under `enums`; files under `mapper/` must be MapStruct `@Mapper` interfaces with Spring component model rather than manual utility mappers; mapper `@Mapping` annotations must not rename dto/entity fields such as `entity.term -> dto.frontText` because DTO vocabulary must align directly with entity fields; and classes under `com.memora.app.properties` must not define internal fallback constants because every bound key must be declared in `src/main/resources/application.yml`.
- Layering and contracts: controller depends on service only, service must not depend on controller, controller signatures must not expose entities, `@RequestBody` must use `dto.request` models with Bean Validation, controllers must not return `dto.request` types, mappers must not produce `dto.request` output, service public contracts must not accept `dto.response` as input or return `dto.request`, controller must use `@RestController`, versioned routes, OpenAPI operation docs, and DTO responses. JpaSpecificationExecutor predicate logic, `Specification.where(...)`, criteria imports, and specification factory methods must live under `com.memora.app.repository.specification`, not in service classes. `Specification.where(...)` is deprecated and forbidden everywhere; use `Specification.allOf(...)` or `Specification.anyOf(...)` instead. Repository derived query methods must not encode `OrderBy...` in the method name; use `Sort` or `Pageable` instead.
- Transaction boundaries: `@Transactional` is forbidden in controller and allowed only in service layer.
- Exception strategy: centralized `@RestControllerAdvice` is required, and controllers must not do manual exception mapping.
- Testing expectations: public methods in `service.impl` must have at least as many JUnit test cases as the number of `if` statements in the method body; controller endpoints must have at least as many JUnit test cases as the number of distinct HTTP statuses documented or returned by the endpoint.
- JPA and repository rules: repository extends `JpaRepository`, query rules, entity lifecycle and relation rules, optimistic locking, enum persistence, and soft delete behavior.
- i18n and validation: validation messages use constants, exception messages use i18n keys, message keys must exist in bundles, and Vietnamese bundles must contain accented Vietnamese text.
- Lombok and utility conventions: `@RequiredArgsConstructor`, entity getter or setter conventions, entity and mapped-superclass models must expose Lombok `@SuperBuilder`, DTO builder preference, object construction for entities or other builder-capable mutable models must use builder instead of `new ...` plus setter chains, no manual logger wiring, and `@UtilityClass` for constant holders.
- Flow and commons rules: no `else`, nested loop guidance, string or collection helper usage rules, and string concatenation must not use `+` or `+=`; use `StringBuilder` or an equivalent API such as `String.format`, `String.join`, or `StringUtils.wrap`.

## Notes

- Guard này vẫn là bản Memora-specific cho Spring Boot + JPA, không phải backend guard generic cho mọi repo.
- Các alias `--only` hiện có gồm: `api`, `layer`, `transaction`, `contract`, `docs`, `flow`, `commons`, `i18n`, `jpa`, `lombok`, `exception`, `query`, `config`, `shape`, `logging`, `testing`.
- `--strict` sẽ fail khi có cả warning.
