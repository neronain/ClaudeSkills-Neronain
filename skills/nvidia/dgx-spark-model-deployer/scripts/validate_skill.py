#!/usr/bin/env python3
from __future__ import annotations
import argparse
from pathlib import Path
import re
import subprocess
import sys

def parse_frontmatter(text: str) -> tuple[dict[str, str], str]:
    if not text.startswith("---\n"):
        raise ValueError("SKILL.md must start with YAML frontmatter")
    end = text.find("\n---\n", 4)
    if end < 0:
        raise ValueError("SKILL.md frontmatter is not closed")
    fm = text[4:end]
    body = text[end + 5:]
    values: dict[str, str] = {}
    for line in fm.splitlines():
        match = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if match:
            values[match.group(1)] = match.group(2).strip()
    return values, body

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("skill_dir", type=Path)
    args = parser.parse_args()
    root = args.skill_dir.resolve()
    skill = root / "SKILL.md"
    if not skill.is_file():
        raise SystemExit(f"Missing {skill}")
    values, body = parse_frontmatter(skill.read_text(encoding="utf-8"))
    errors: list[str] = []
    warnings: list[str] = []
    for key in ("name", "description"):
        if not values.get(key):
            errors.append(f"Missing frontmatter key: {key}")
    description = values.get("description", "")
    if len(description.strip('"')) > 160:
        errors.append("description exceeds 160 characters")
    if len(body.splitlines()) < 50:
        warnings.append("Skill body is unusually short")
    required = [
        "references/research-workflow.md",
        "references/controller-contract.md",
        "references/quality-gates.md",
        "templates/MODEL_PROFILE.yaml",
        "scripts/validate_bundle.py",
    ]
    for rel in required:
        if not (root / rel).is_file():
            errors.append(f"Missing support file: {rel}")
    for link in re.findall(r"\]\(([^)]+)\)", body):
        if "://" in link or link.startswith("#"):
            continue
        target = (root / link).resolve()
        if not target.exists():
            errors.append(f"Broken local link: {link}")
    for path in sorted((root / "scripts").glob("*.py")):
        proc = subprocess.run(
            [sys.executable, "-m", "py_compile", str(path)],
            capture_output=True, text=True
        )
        if proc.returncode:
            errors.append(f"Python syntax failed: {path.name}: {proc.stderr.strip()}")
    for path in sorted((root / "scripts").glob("*.sh")):
        proc = subprocess.run(["bash", "-n", str(path)], capture_output=True, text=True)
        if proc.returncode:
            errors.append(f"Bash syntax failed: {path.name}: {proc.stderr.strip()}")
    if warnings:
        for warning in warnings:
            print(f"WARNING: {warning}")
    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        return 1
    print(f"OK: {root}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
