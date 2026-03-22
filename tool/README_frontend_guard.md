# Frontend Guard (Memora Flutter Client)

## Run

```bash
python tool/verify_frontend_checklists.py
python tool/verify_frontend_checklists.py --strict
python tool/verify_frontend_checklists.py --list
python tool/verify_frontend_checklists.py --only=class1
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

## Rule Groups

- `class1`: 5 guard ưu tiên đầu tiên cho frontend client
- `state`: `riverpod-annotation`
- `ui`: `ui-logic-separation` + `feature-surface`
- `navigation`: `navigation`
- `l10n`: `l10n-usage`

## Notes

- Guard này giữ pattern vận hành và runtime của backend guard nhưng đổi rule contract sang Flutter frontend client.
- `--strict` sẽ fail khi có cả warning.
- Lớp 1 hiện tập trung vào Riverpod annotation, render-boundary, navigation, text literal, và feature surface contract.
