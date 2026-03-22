from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Callable, Sequence


SEVERITY_ERROR = "ERROR"
SEVERITY_WARNING = "WARN"
REPORT_FILE = "frontend_guard_report.json"

_DART_SUFFIX = ".dart"
_GENERATED_SUFFIXES = (".g.dart", ".freezed.dart")
_GO_ROUTER_DEPENDENCY_PATTERN = re.compile(r"^\s*go_router\s*:", re.MULTILINE)


@dataclass(frozen=True)
class Violation:
    guard_id: str
    rule: str
    severity: str
    file: str
    line: int
    reason: str
    snippet: str

    def to_console(self) -> str:
        return (
            f"{self.file}:{self.line}: [{self.severity}] "
            f"{self.rule} - {self.reason} :: {self.snippet}"
        )

    def to_json(self) -> dict[str, object]:
        return {
            "guard": self.guard_id,
            "rule": self.rule,
            "severity": self.severity,
            "file": self.file,
            "line": self.line,
            "reason": self.reason,
            "snippet": self.snippet,
        }


@dataclass(frozen=True)
class SourceFile:
    path: Path
    rel_path: str
    text: str
    lines: list[str]

    @property
    def file_name(self) -> str:
        return self.path.name

    @property
    def file_stem(self) -> str:
        return self.path.stem


@dataclass(frozen=True)
class GuardTask:
    id: str
    file_name: str
    description: str
    run: Callable[[Path], list[Violation]]


def normalize_path(path: str | Path) -> str:
    return str(path).replace("\\", "/")


def is_generated_path(path: str) -> bool:
    return any(path.endswith(suffix) for suffix in _GENERATED_SUFFIXES)


def collect_source_files(root: Path, scan_roots: Sequence[str]) -> list[SourceFile]:
    files: list[SourceFile] = []
    seen_paths: set[str] = set()

    for scan_root in scan_roots:
        target = root / Path(scan_root)
        if not target.exists():
            continue

        if target.is_file():
            _append_source_file(root=root, file_path=target, files=files, seen_paths=seen_paths)
            continue

        for file_path in sorted(target.rglob(f"*{_DART_SUFFIX}")):
            _append_source_file(root=root, file_path=file_path, files=files, seen_paths=seen_paths)

    return files


def _append_source_file(
    *,
    root: Path,
    file_path: Path,
    files: list[SourceFile],
    seen_paths: set[str],
) -> None:
    rel_path = file_path.relative_to(root).as_posix()
    if is_generated_path(rel_path):
        return
    if rel_path in seen_paths:
        return

    text = file_path.read_text(encoding="utf-8")
    files.append(
        SourceFile(
            path=file_path,
            rel_path=rel_path,
            text=text,
            lines=text.splitlines(),
        )
    )
    seen_paths.add(rel_path)


def strip_line_comment(source_line: str) -> str:
    comment_index = source_line.find("//")
    if comment_index < 0:
        return source_line
    return source_line[:comment_index]


def line_for_offset(source_text: str, offset: int) -> int:
    if offset <= 0:
        return 1
    return source_text.count("\n", 0, offset) + 1


def line_content_at(lines: list[str], line_number: int) -> str:
    if line_number <= 0:
        return ""
    if line_number > len(lines):
        return ""
    return lines[line_number - 1].strip()


def has_go_router_dependency(root: Path) -> bool:
    pubspec_file = root / "pubspec.yaml"
    if not pubspec_file.exists():
        return False
    return _GO_ROUTER_DEPENDENCY_PATTERN.search(pubspec_file.read_text(encoding="utf-8")) is not None


def is_feature_ui_file(path: str) -> bool:
    if not path.startswith("lib/presentation/features/"):
        return False
    return "/screens/" in path or "/widgets/" in path


def is_shared_ui_file(path: str) -> bool:
    return path.startswith("lib/presentation/shared/")


def is_ui_file(path: str) -> bool:
    if not path.startswith("lib/presentation/"):
        return False
    return any(
        marker in path
        for marker in (
            "/screens/",
            "/widgets/",
            "/primitives/",
            "/composites/",
            "/layouts/",
        )
    )


def is_shared_widget_file(path: str) -> bool:
    return path.startswith("lib/presentation/shared/primitives/") or path.startswith(
        "lib/presentation/shared/composites/"
    )


def write_report(root: Path, tasks: Sequence[GuardTask], violations: Sequence[Violation]) -> None:
    payload = {
        "summary": {
            "guards": len(tasks),
            "total": len(violations),
            "errors": sum(1 for item in violations if item.severity == SEVERITY_ERROR),
            "warnings": sum(1 for item in violations if item.severity == SEVERITY_WARNING),
        },
        "guards": [
            {
                "id": task.id,
                "file": task.file_name,
                "description": task.description,
            }
            for task in tasks
        ],
        "violations": [item.to_json() for item in violations],
    }
    (root / REPORT_FILE).write_text(json.dumps(payload, ensure_ascii=True, indent=2), encoding="utf-8")
