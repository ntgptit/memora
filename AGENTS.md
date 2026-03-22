# AGENTS.md

## Intent

This repository contains:

- a Flutter frontend client at the repository root
- a Spring Boot API service under `memora-api-service/`

Use installed skills first, then follow this repo-local contract for routing and verification.

## Routing

### Flutter frontend client

Use Flutter guidance when the task touches:

- `lib/**`
- `test/**`
- `tool/**`
- Flutter project files at the repository root

Preferred skills:

1. `flutter-app-development`
2. `flutter-frontend-client`

Repo rules for Flutter:

- `Riverpod Annotation + DI` is required.
- `go_router` is required.
- `retrofit + dio` is required for remote HTTP integration.
- `lib/core/theme/**` is the theme foundation root.
- `lib/presentation/shared/**` must stay UI-only.
- `lib/presentation/features/**/screens` and `lib/presentation/features/**/widgets` must stay render/intention layers.
- Do not claim a Flutter coding task is complete until the frontend guard has been run, unless the environment blocks it and that block is reported clearly.

Flutter verification after code changes:

```bash
python tool/verify_frontend_checklists.py --strict
flutter analyze
flutter test
```

The frontend guard is mandatory after Flutter code changes.

### Spring Boot backend

Use backend guidance when the task touches:

- `memora-api-service/**`

Preferred skill:

1. `spring-boot-rest-api`

Backend verification after code changes inside `memora-api-service/`:

```bash
cd memora-api-service
python tool/verify_backend_checklists.py --strict
```

## General repo rules

- Keep changes minimal and structurally correct.
- Do not invent new architecture layers without an explicit need.
- If a required verifier cannot run, state exactly which verifier failed and why.
