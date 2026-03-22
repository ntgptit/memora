# Folder Mapping

Source of truth: `folder_struct.md`

This file maps the current project tree to the contract in `folder_struct.md`.

## Status legend

- `implemented`: folder exists and is already wired into the running app
- `scaffolded`: folder and file names match the contract, but most contents are still shell-level
- `placeholder`: folder exists only to reserve architecture space

## Top-Level Mapping

| Contract | Project path | Status | Notes |
| --- | --- | --- | --- |
| `lib/main.dart` | `lib/main.dart` | implemented | Entry point runs `AppInitializer` then boots `App`. |
| `lib/app/` | `lib/app/` | implemented | App bootstrap, lifecycle, router, and app-wide providers are active. |
| `lib/core/` | `lib/core/` | implemented | Core foundation exists and powers runtime theme, DI, config, errors, and network base. |
| `lib/presentation/` | `lib/presentation/` | scaffolded | Contract tree is present for shared UI and features; only a small runtime shell is active. |
| `lib/domain/` | `lib/domain/` | placeholder | `.gitkeep` only; no client domain logic yet. |
| `lib/data/` | `lib/data/` | placeholder | `.gitkeep` only; no backend integration implementation yet. |
| `lib/l10n/` | `lib/l10n/` | scaffolded | ARB and config files exist, but localization is not wired into app bootstrap yet. |

## App Mapping

| `folder_struct.md` | Current path | Status | Notes |
| --- | --- | --- | --- |
| `app/app.dart` | `lib/app/app.dart` | implemented | Root `ProviderScope` and `MaterialApp.router` live here. |
| `app/app_router.dart` | `lib/app/app_router.dart` | implemented | Uses Riverpod annotation provider and `go_router`. |
| `app/app_routes.dart` | `lib/app/app_routes.dart` | implemented | Route path and route name constants exist. |
| `app/app_providers.dart` | `lib/app/app_providers.dart` | implemented | App-level Riverpod annotation providers and notifiers exist. |
| `app/app_initializer.dart` | `lib/app/app_initializer.dart` | implemented | Startup initialization hook exists. |
| `app/app_lifecycle_handler.dart` | `lib/app/app_lifecycle_handler.dart` | implemented | App lifecycle observer is active. |

## Core Mapping

| `folder_struct.md` subtree | Current path | Status | Notes |
| --- | --- | --- | --- |
| `core/config/` | `lib/core/config/` | implemented | Env, keys, constants, debounce, durations, assets, strings, limits, icons are present. |
| `core/theme/` | `lib/core/theme/` | implemented | Tokens, responsive layer, extensions, and component themes are in place and used by app runtime. |
| `core/extensions/` | `lib/core/extensions/` | scaffolded | Structure matches the contract; only common context extension is currently meaningful. |
| `core/enums/` | `lib/core/enums/` | implemented | Shared enums exist and are usable now. |
| `core/errors/` | `lib/core/errors/` | implemented | Base failures and error mapper exist. |
| `core/network/` | `lib/core/network/` | implemented | Client-facing API wrapper and interceptor placeholders exist; no real HTTP stack integration yet. |
| `core/storage/` | `lib/core/storage/` | scaffolded | Structure exists but no real persistence implementation yet. |
| `core/services/` | `lib/core/services/` | scaffolded | Service layer is reserved but still shell-level. |
| `core/di/` | `lib/core/di/` | implemented | Riverpod annotation based DI foundation exists in `core_providers.dart`. |
| `core/utils/` | `lib/core/utils/` | scaffolded | Utility contract exists, but most files are still placeholders. |

## Presentation Mapping

| `folder_struct.md` subtree | Current path | Status | Notes |
| --- | --- | --- | --- |
| `presentation/shared/` | `lib/presentation/shared/` | scaffolded | Full shared UI tree exists exactly as contracted. |
| `presentation/shared/layouts/` | `lib/presentation/shared/layouts/` | implemented | `app_scaffold.dart` is already used by runtime screens. |
| `presentation/shared/screens/` | `lib/presentation/shared/screens/` | implemented | `not_found`, `offline`, `maintenance`, and `splash` shell screens exist. |
| `presentation/shared/primitives/` | `lib/presentation/shared/primitives/` | scaffolded | Folder contract is complete, but widgets are not implemented yet. |
| `presentation/shared/composites/` | `lib/presentation/shared/composites/` | scaffolded | Folder contract is complete, but patterns are not implemented yet. |
| `presentation/shared/controllers/` | `lib/presentation/shared/controllers/` | scaffolded | Reserved for shared UI state helpers. |
| `presentation/shared/mixins/` | `lib/presentation/shared/mixins/` | scaffolded | Reserved only. |
| `presentation/shared/presenters/` | `lib/presentation/shared/presenters/` | scaffolded | Reserved only. |
| `presentation/features/dashboard/` | `lib/presentation/features/dashboard/` | implemented | `dashboard_screen.dart` acts as current runtime shell. |
| `presentation/features/folder/` | `lib/presentation/features/folder/` | scaffolded | Feature tree matches contract; no real client flow yet. |
| `presentation/features/deck/` | `lib/presentation/features/deck/` | scaffolded | Feature tree matches contract; no real client flow yet. |
| `presentation/features/flashcard/` | `lib/presentation/features/flashcard/` | scaffolded | Feature tree matches contract; no real client flow yet. |
| `presentation/features/study/` | `lib/presentation/features/study/` | scaffolded | Main study tree and mode subtrees exist but are still shell-level. |
| `presentation/features/progress/` | `lib/presentation/features/progress/` | scaffolded | Structure only. |
| `presentation/features/reminder/` | `lib/presentation/features/reminder/` | scaffolded | Structure only. |
| `presentation/features/settings/` | `lib/presentation/features/settings/` | scaffolded | Structure only. |
| `presentation/features/auth/` | `lib/presentation/features/auth/` | scaffolded | Structure only. |
| `presentation/features/onboarding/` | `lib/presentation/features/onboarding/` | scaffolded | Structure only. |

## Exact Structure Match Summary

- Top-level contract folders are present: `app`, `core`, `presentation`, `domain`, `data`, `l10n`
- Shared presentation contract folders are present: `primitives`, `composites`, `layouts`, `screens`, `mixins`, `controllers`, `presenters`
- Feature contract folders are present for: `dashboard`, `folder`, `deck`, `flashcard`, `study`, `progress`, `reminder`, `settings`, `auth`, `onboarding`
- Study mode folders are present: `review`, `match`, `guess`, `recall`, `fill`
- No backend-only `lib/core/database` subtree remains in the client structure

## Current Gaps Against Intended Depth

- `domain/` and `data/` are only placeholders and still need real client contracts and backend integration.
- Most files under `presentation/shared/primitives`, `presentation/shared/composites`, and feature `widgets/providers` are still scaffold-level.
- `core/services`, `core/storage`, `core/utils`, and some `core/extensions` files are reserved architecture, not production implementations yet.
- `l10n/` files exist, but app localization is not registered in `MaterialApp.router` yet.

## Generated Files

- Riverpod annotation generated files such as `*.g.dart` exist alongside provider sources.
- These generated files are ignored by the root `.gitignore` and are not part of the architecture contract itself.

## Suggested Next Fill Order

1. `presentation/shared/primitives`
2. `presentation/shared/composites`
3. `data/` + `domain/` for first real backend-backed slice
4. `presentation/features/folder`
5. `presentation/features/deck`
