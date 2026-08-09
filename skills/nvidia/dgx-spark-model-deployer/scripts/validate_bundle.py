#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path
import re
import subprocess


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Static validation for a generated DGX Spark bundle"
    )
    parser.add_argument("bundle", type=Path)
    args = parser.parse_args()

    root = args.bundle.resolve()
    errors: list[str] = []
    warnings: list[str] = []

    if not root.is_dir():
        raise SystemExit(f"Not a directory: {root}")

    if not (root / "README.md").is_file():
        errors.append("README.md is missing")

    scripts = sorted(root.glob("*.sh"))
    if not scripts:
        errors.append("No top-level Bash controller found")

    for script in scripts:
        proc = subprocess.run(
            ["bash", "-n", str(script)],
            capture_output=True,
            text=True,
        )
        if proc.returncode:
            errors.append(
                f"{script.name}: bash -n failed: {proc.stderr.strip()}"
            )
            continue

        text = script.read_text(encoding="utf-8", errors="replace")

        if "__REQUIRED_" in text:
            errors.append(
                f"{script.name}: unresolved __REQUIRED_ placeholder"
            )

        if "--runtime=nvidia" in text:
            warnings.append(
                f"{script.name}: contains --runtime=nvidia; verify host requirement"
            )

        if re.search(r"pip3?\s+install\s+.*\btorch\b", text):
            warnings.append(
                f"{script.name}: installs torch; ensure this is inside a build container"
            )

        for command in ("start", "stop", "status"):
            if command not in text:
                errors.append(
                    f"{script.name}: missing command marker {command}"
                )

        if (
            ("docker run" in text or "docker create" in text)
            and "--gpus all" not in text
        ):
            warnings.append(
                f"{script.name}: Docker controller may be missing --gpus all"
            )

        for match in re.finditer(r"\b\d+(?:_\d+)+\b", text):
            errors.append(
                f"{script.name}: Bash numeric separator is unsafe: "
                f"{match.group(0)}"
            )

        if "set -Eeuo pipefail" in text or "set -o pipefail" in text:
            if re.search(
                r"\|[^\n]*\bgrep\b[^\n]*-[A-Za-z]*q[A-Za-z]*",
                text,
            ):
                warnings.append(
                    f"{script.name}: pipefail-sensitive "
                    "producer | grep -q detected"
                )

        if "single" in script.name.lower() and re.search(
            r'(?m)^MASTER_IP="[^$][^"]*"$',
            text,
        ):
            warnings.append(
                f"{script.name}: single-node controller hard-codes MASTER_IP"
            )

        for marker in ("--context", "--port"):
            if marker not in text:
                warnings.append(
                    f"{script.name}: missing common option {marker}"
                )

        if "network-info" not in text:
            warnings.append(
                f"{script.name}: missing network-info command"
            )

        if "stack" in script.name or "worker" in text.lower():
            for marker in ("sync-worker", "verify-worker"):
                if marker not in text:
                    warnings.append(
                        f"{script.name}: stacked controller missing {marker}"
                    )

    if not (root / "PACKAGE_SHA256SUMS").exists():
        warnings.append("PACKAGE_SHA256SUMS is missing")

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
