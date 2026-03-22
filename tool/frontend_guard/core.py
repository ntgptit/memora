#!/usr/bin/env python3
"""
Frontend checklist guard orchestrator for Memora Flutter frontend client.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from frontend_guard.common import (
    SEVERITY_ERROR,
    SEVERITY_WARNING,
    GuardTask,
    Violation,
    write_report,
)
from frontend_guard.guards import (
    feature_surface,
    l10n_usage,
    navigation,
    riverpod_annotation,
    ui_logic_separation,
)


def _build_tasks() -> list[GuardTask]:
    return [
        GuardTask(
            id=riverpod_annotation.GUARD_ID,
            file_name=riverpod_annotation.FILE_NAME,
            description=riverpod_annotation.DESCRIPTION,
            run=riverpod_annotation.run,
        ),
        GuardTask(
            id=ui_logic_separation.GUARD_ID,
            file_name=ui_logic_separation.FILE_NAME,
            description=ui_logic_separation.DESCRIPTION,
            run=ui_logic_separation.run,
        ),
        GuardTask(
            id=navigation.GUARD_ID,
            file_name=navigation.FILE_NAME,
            description=navigation.DESCRIPTION,
            run=navigation.run,
        ),
        GuardTask(
            id=l10n_usage.GUARD_ID,
            file_name=l10n_usage.FILE_NAME,
            description=l10n_usage.DESCRIPTION,
            run=l10n_usage.run,
        ),
        GuardTask(
            id=feature_surface.GUARD_ID,
            file_name=feature_surface.FILE_NAME,
            description=feature_surface.DESCRIPTION,
            run=feature_surface.run,
        ),
    ]


def _parse_args(args: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Memora Flutter frontend checklist guard.")
    parser.add_argument("--root", default=".", help="Project root directory. Default: current directory.")
    parser.add_argument("--only", default="", help="Run only selected guard ids or groups (comma separated).")
    parser.add_argument("--strict", action="store_true", help="Fail when warning violations exist.")
    parser.add_argument("--list", action="store_true", help="List available guards and exit.")
    parser.add_argument("--fail-fast", action="store_true", help="Stop after the first failed guard.")
    return parser.parse_args(args)


def _group_aliases() -> dict[str, set[str]]:
    return {
        "class1": {
            riverpod_annotation.GUARD_ID,
            ui_logic_separation.GUARD_ID,
            navigation.GUARD_ID,
            l10n_usage.GUARD_ID,
            feature_surface.GUARD_ID,
        },
        "state": {riverpod_annotation.GUARD_ID},
        "ui": {ui_logic_separation.GUARD_ID, feature_surface.GUARD_ID},
        "navigation": {navigation.GUARD_ID},
        "l10n": {l10n_usage.GUARD_ID},
    }


def _resolve_selected_ids(raw_only: str, all_tasks: list[GuardTask]) -> set[str]:
    tokens = {token.strip() for token in raw_only.split(",") if token.strip() != ""}
    if not tokens:
        return {task.id for task in all_tasks}

    available = {task.id for task in all_tasks}
    groups = _group_aliases()
    selected: set[str] = set()
    for token in tokens:
        if token in groups:
            selected.update(groups[token])
            continue
        selected.add(token)

    unknown = selected.difference(available)
    if unknown:
        names = ", ".join(sorted(unknown))
        raise ValueError(f"Unknown guard id(s): {names}")
    return selected


def _print_task_list(tasks: list[GuardTask]) -> None:
    print("Available frontend guards:")
    for task in tasks:
        print(f"- {task.id}: {task.description} ({task.file_name})")


def _sort_violations(violations: list[Violation]) -> list[Violation]:
    severity_order = {
        SEVERITY_ERROR: 0,
        SEVERITY_WARNING: 1,
    }
    return sorted(
        violations,
        key=lambda item: (
            severity_order.get(item.severity, 99),
            item.guard_id,
            item.file,
            item.line,
        ),
    )


def _print_summary(tasks: list[GuardTask], violations: list[Violation]) -> None:
    if not violations:
        print(f"Frontend checklist guard passed ({len(tasks)} guard(s)).")
        return

    errors = sum(1 for item in violations if item.severity == SEVERITY_ERROR)
    warnings = sum(1 for item in violations if item.severity == SEVERITY_WARNING)
    if errors > 0:
        print(f"Frontend checklist guard failed. guards={len(tasks)}, errors={errors}, warnings={warnings}")
    else:
        print(f"Frontend checklist guard completed with warnings. guards={len(tasks)}, warnings={warnings}")

    for violation in violations:
        print(violation.to_console())


def main() -> int:
    options = _parse_args(sys.argv[1:])
    all_tasks = _build_tasks()

    if options.list:
        _print_task_list(all_tasks)
        return 0

    try:
        selected_ids = _resolve_selected_ids(options.only, all_tasks)
    except ValueError as error:
        print(error)
        print("Use --list to see valid guard ids.")
        return 1

    selected_tasks = [task for task in all_tasks if task.id in selected_ids]
    if not selected_tasks:
        print("No guard selected.")
        return 1

    root = Path(options.root).resolve()
    violations: list[Violation] = []
    for task in selected_tasks:
        task_violations = task.run(root)
        violations.extend(task_violations)
        if options.fail_fast and task_violations:
            break

    violations = _sort_violations(violations)
    write_report(root, selected_tasks, violations)
    _print_summary(selected_tasks, violations)

    has_errors = any(item.severity == SEVERITY_ERROR for item in violations)
    if has_errors:
        return 1
    if options.strict and violations:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
