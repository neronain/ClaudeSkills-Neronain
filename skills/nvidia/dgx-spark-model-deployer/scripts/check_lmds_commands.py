#!/usr/bin/env python3
"""Check that every `lmds …` command and flag this skill mentions exists in the installed LMDS.

LMDS changes often. A skill that cites a renamed command or flag sends Claude down a dead end,
so run this after upgrading LMDS:

  python3 scripts/check_lmds_commands.py              # `lmds` on PATH or in ~/.local/bin, else the Autodeploy OrbStack VM
  python3 scripts/check_lmds_commands.py --via "orb -m Autodeploy bash -lc" --lmds "~/.local/bin/lmds"

Exit 0 = everything exists, 1 = something is missing (listed), 2 = LMDS could not be reached.
Controller verbs after `lmds node ctl <node> <slug>` are not LMDS commands and are not checked.
"""
from __future__ import annotations

import argparse
import re
import shlex
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GROUPS = {"node", "bundles", "fleet", "cluster", "config", "agent", "bench"}
ENDS = {"|", "||", "&&", ";", ")", "\\"}
COMMAND_ROW = re.compile(r"^\s*│\s+([a-z][a-z0-9-]*)\s{2,}")
OPTION = re.compile(r"(?<![\w-])(--?[a-z][a-z0-9-]*)")


def mentions(text: str) -> list[list[str]]:
    """Token lists following `lmds` inside fenced blocks and inline code."""
    fenced = re.findall(r"```[^\n]*\n(.*?)```", text, re.S)
    inline = re.findall(r"`([^`\n]+)`", re.sub(r"```.*?```", "", text, flags=re.S))
    found = []
    for chunk in fenced + inline:
        for line in chunk.splitlines():
            for match in re.finditer(r"(?:^|[\s'\"(/])lmds\s+(\S.*)", line):
                tokens = []
                for token in match.group(1).split():
                    if token in ENDS or token.startswith("#"):
                        break
                    tokens.append(token.strip("'\"[]"))
                if tokens and re.fullmatch(r"[a-z][a-z-]*", tokens[0]):
                    found.append(tokens)
    return found


def resolve(tokens: list[str]) -> tuple[tuple[str, ...], list[str]]:
    """(command path, flags) — `node run <node> <cmd…>` checks the inner command."""
    if tokens[:2] == ["node", "run"]:
        inner = tokens[3:]
        if inner and re.fullmatch(r"[a-z][a-z-]*", inner[0]):
            return resolve(inner)
        return ("node", "run"), []
    if tokens[:2] == ["node", "ctl"]:
        return ("node", "ctl"), []
    path = [tokens[0]]
    rest = tokens[1:]
    if tokens[0] in GROUPS and rest and re.fullmatch(r"[a-z][a-z-]*", rest[0]):
        path.append(rest[0])
        rest = rest[1:]
    flags = [token.split("=", 1)[0] for token in rest if re.fullmatch(r"--?[a-z][a-z0-9-]*(=.*)?", token)]
    return tuple(path), flags


def fetch_help(paths: set[tuple[str, ...]], via: list[str] | None, lmds: str) -> dict[str, str]:
    lines = ["export LMDS_NO_BANNER=1 COLUMNS=220 NO_COLOR=1 TERM=dumb", f"echo '@@@ ROOT'; {lmds} --help 2>&1"]
    for path in sorted(paths):
        lines.append(f"echo '@@@ {' '.join(path)}'; {lmds} {' '.join(path)} --help 2>&1")
    script = "cd ~ 2>/dev/null; " + "\n".join(lines)
    command = [*via, script] if via else ["bash", "-lc", script]
    try:
        output = subprocess.run(command, capture_output=True, text=True, timeout=600).stdout
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise SystemExit(f"cannot run lmds: {exc}")
    sections: dict[str, list[str]] = {}
    current = None
    for line in output.splitlines():
        if line.startswith("@@@ "):
            current = line[4:]
            sections[current] = []
        elif current is not None:
            sections[current].append(line)
    return {key: "\n".join(value) for key, value in sections.items()}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--via", help='shell prefix, e.g. "orb -m Autodeploy bash -lc"')
    parser.add_argument("--lmds", default=None, help="lmds executable on that host")
    args = parser.parse_args()

    if args.via:
        via, lmds = shlex.split(args.via), args.lmds or "~/.local/bin/lmds"
    elif local := shutil.which("lmds") or next((str(p) for p in [Path.home() / ".local/bin/lmds"] if p.exists()), None):
        via, lmds = None, args.lmds or local  # a node: non-login shells often lack ~/.local/bin on PATH
    elif shutil.which("orb"):
        via, lmds = ["orb", "-m", "Autodeploy", "bash", "-lc"], args.lmds or "~/.local/bin/lmds"
    else:
        print("ERROR: no `lmds` on PATH and no `orb` to reach the hub VM — pass --via/--lmds")
        return 2

    docs = [ROOT / "SKILL.md", *sorted((ROOT / "references").glob("*.md"))]
    uses: list[tuple[str, tuple[str, ...], list[str]]] = []
    for doc in docs:
        for tokens in mentions(doc.read_text(encoding="utf-8")):
            path, flags = resolve(tokens)
            uses.append((str(doc.relative_to(ROOT)), path, flags))
    paths = {path for _, path, _ in uses}
    helps = fetch_help(paths, via, lmds)

    root_help = helps.get("ROOT", "")
    top_level = {m.group(1) for line in root_help.splitlines() if (m := COMMAND_ROW.match(line))}
    if not top_level:
        print("ERROR: could not read `lmds --help` — is LMDS installed there?")
        print(root_help[-400:])
        return 2

    problems: list[str] = []
    checked = 0
    for doc, path, flags in uses:
        checked += 1
        name = " ".join(path)
        text = helps.get(name, "")
        if path[0] not in top_level or "No such command" in text or "Usage:" not in text:
            problems.append(f"{doc}: `lmds {name}` — command not found")
            continue
        known = set(OPTION.findall(text))
        for flag in flags:
            if flag not in known:
                problems.append(f"{doc}: `lmds {name} {flag}` — flag not found")

    for problem in sorted(set(problems)):
        print(f"ERROR: {problem}")
    print(f"checked {checked} mentions across {len(paths)} commands — "
          + ("all present" if not problems else f"{len(set(problems))} problems"))
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
