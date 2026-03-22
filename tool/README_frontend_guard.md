# Frontend Guard (Memora Flutter Client)

## Run

```bash
python tool/verify_frontend_checklists.py
python tool/verify_frontend_checklists.py --strict
python tool/verify_frontend_checklists.py --list
python tool/verify_frontend_checklists.py --only=class1
python tool/verify_frontend_checklists.py --only=class2
python tool/verify_frontend_checklists.py --only=class3
python tool/verify_frontend_checklists.py --only=riverpod-annotation,navigation
```

## Output

- Console: `file:line: [SEVERITY] RULE - reason :: snippet`
- JSON report: `frontend_guard_report.json` in the project root

## Guard Coverage

- `riverpod-annotation`
- `ui-logic-separation`
- `navigation`
- `l10n-usage`
- `feature-surface`
- `state-management`
- `riverpod-layout-state`
- `common-widget-boundaries`
- `component-theme`
- `ui-constants`
- `spacing-ownership`
- `ui-design`
- `code-quality`
- `accessibility`
- `opacity-contract`

## Rule Groups

- `class1`: 5 guard ưu tiên đầu tiên cho frontend client
- `class2`: provider/shared-layer boundaries dựa trên `folder_struct.md`
- `class3`: theme/token/design-system hardening cho feature UI
- `state`: `riverpod-annotation` + `state-management` + `riverpod-layout-state`
- `ui`: `ui-logic-separation` + `feature-surface` + `common-widget-boundaries` + `ui-design`
- `navigation`: `navigation`
- `l10n`: `l10n-usage`
- `theme`: `feature-surface` + `component-theme` + `ui-constants` + `opacity-contract`
- `quality`: `code-quality` + `accessibility` + `spacing-ownership`

## Notes

- Guard này giữ pattern vận hành và runtime của backend guard nhưng đổi rule contract sang Flutter frontend client.
- `--strict` sẽ fail khi có cả warning.
- Lớp 1 hiện tập trung vào Riverpod annotation, render-boundary, navigation, text literal, và feature surface contract.
- Lớp 2 map trực tiếp từ `folder_struct.md`: `presentation/features/**/providers`, `presentation/shared/primitives`, `presentation/shared/composites`, `presentation/shared/layouts`, `presentation/shared/screens`.
- Lớp 3 siết các convention mà repo đã có sẵn nền tảng: shared primitives, theme tokens, opacity tokens, accessibility baseline, và feature UI usage.
