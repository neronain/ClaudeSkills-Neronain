#!/usr/bin/env python3
"""Static checks for this skill: frontmatter, required files, links and mentioned paths, script syntax.

Usage: python3 scripts/validate_skill.py [skill_dir]      # defaults to the skill containing this script
Exit 0 = OK, 1 = errors found.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

REQUIRED = [
    "config/team-profile.yaml",
    "references/sizing.md",
    "references/runtime-notes.md",
    "references/fleet-ops.md",
    "references/troubleshooting.md",
    "scripts/check_lmds_commands.py",
]


def frontmatter(text: str) -> tuple[dict[str, str], str]:
    if not text.startswith("---\n"):
        raise SystemExit("ERROR: SKILL.md must start with YAML frontmatter")
    end = text.find("\n---\n", 4)
    if end < 0:
        raise SystemExit("ERROR: SKILL.md frontmatter is not closed")
    values: dict[str, str] = {}
    for line in text[4:end].splitlines():
        match = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if match:
            values[match.group(1)] = match.group(2).strip().strip('"')
    return values, text[end + 5:]


def main() -> int:
    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[1]
    skill = root / "SKILL.md"
    if not skill.is_file():
        print(f"ERROR: missing {skill}")
        return 1
    values, body = frontmatter(skill.read_text(encoding="utf-8"))
    errors: list[str] = []
    warnings: list[str] = []

    if values.get("name") != root.name:
        errors.append(f"name '{values.get('name')}' must equal the directory name '{root.name}'")
    description = values.get("description", "")
    if not description:
        errors.append("missing description")
    elif len(description) > 160:
        errors.append(f"description is {len(description)} chars (max 160) — move trigger detail to when_to_use")
    if not values.get("when_to_use"):
        warnings.append("no when_to_use — the skill may under-trigger")
    if len(body.splitlines()) > 500:
        warnings.append("SKILL.md body is over 500 lines — move detail into references/")

    for rel in REQUIRED:
        if not (root / rel).is_file():
            errors.append(f"missing {rel}")

    for doc in [skill, *sorted((root / "references").glob("*.md"))]:
        text = doc.read_text(encoding="utf-8")
        for target in re.findall(r"\]\(([^)]+)\)", text):
            if "://" not in target and not target.startswith("#") and not (doc.parent / target).resolve().exists():
                errors.append(f"{doc.relative_to(root)}: broken link {target}")
        for mentioned in re.findall(r"`((?:references|scripts|config)/[A-Za-z0-9_./-]+)`", text):
            if not (root / mentioned).exists():
                errors.append(f"{doc.relative_to(root)}: mentions missing file {mentioned}")

    for script in sorted((root / "scripts").glob("*.py")):
        try:
            compile(script.read_text(encoding="utf-8"), str(script), "exec")  # no __pycache__ side effect
        except SyntaxError as exc:
            errors.append(f"python syntax: {script.name}: {exc}")
    for cache in root.rglob("__pycache__"):
        warnings.append(f"remove {cache.relative_to(root)} — do not ship bytecode")

    for warning in warnings:
        print(f"WARNING: {warning}")
    for error in errors:
        print(f"ERROR: {error}")
    if errors:
        return 1
    print(f"OK: {root}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
