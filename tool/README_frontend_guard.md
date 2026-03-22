# Frontend Guard (Memora Flutter Client)

## Run

```bash
python tool/verify_frontend_checklists.py
python tool/verify_frontend_checklists.py --strict
python tool/verify_frontend_checklists.py --only=state
```

## Output

- Console: `file:line: [SEVERITY] RULE - reason :: snippet`
- JSON report: `frontend_guard_report.json` in the project root

## Rule Coverage

- `REQUIRED_APP_BOOTSTRAP_FILES_EXIST`
- `REQUIRED_FRONTEND_STRUCTURE_EXISTS`
- `REQUIRED_THEME_STRUCTURE_EXISTS`
- `REQUIRED_L10N_BUNDLES_EXIST`
- `REQUIRED_RUNTIME_DEPENDENCIES_PRESENT`
- `REQUIRED_DEV_DEPENDENCIES_PRESENT`
- `GENERATED_FILES_ARE_GITIGNORED`
- `NO_MANUAL_RIVERPOD_PROVIDER_DECLARATION`
- `RIVERPOD_ANNOTATED_FILE_HAS_PART_DIRECTIVE`
- `UI_LAYER_NO_PROVIDER_DECLARATION`
- `UI_LAYER_NO_DATA_OR_NETWORK_IMPORT`
- `NAVIGATION_MUST_USE_GO_ROUTER`
- `SHARED_WIDGETS_NO_NAVIGATION`
- `PRESENTATION_AVOID_RAW_THEME_ACCESS`

## Rule Groups

- `structure`: app bootstrap, folder contract, theme structure, l10n bundles
- `deps`: required dependencies and generated-file ignore rules
- `state`: Riverpod annotation and UI/provider boundaries
- `ui`: render-layer import boundaries and raw theme usage
- `navigation`: `go_router` routing and shared-widget navigation boundaries
- `theme`: theme foundation structure and raw theme usage

## Notes

- Guard này giữ pattern vận hành và runtime của backend guard nhưng đổi rule contract sang Flutter frontend client.
- `--strict` sẽ fail khi có cả warning.
- Rule `PRESENTATION_AVOID_RAW_THEME_ACCESS` đang là `WARN` để hỗ trợ siết dần theme usage thay vì chặn cứng ngay.
