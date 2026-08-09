#!/usr/bin/env python3
from __future__ import annotations
import argparse
import hashlib
import os
from pathlib import Path

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path)
    parser.add_argument("--quick", action="store_true")
    args = parser.parse_args()
    root = args.root.resolve()
    if not root.is_dir():
        raise SystemExit(f"Missing directory: {root}")
    for path in sorted(root.rglob("*"), key=lambda p: str(p.relative_to(root))):
        rel = str(path.relative_to(root))
        if path.is_symlink():
            print(f"L\t{rel}\t{os.readlink(path)}")
        elif path.is_dir():
            print(f"D\t{rel}\t")
        elif path.is_file():
            size = path.stat().st_size
            digest = "-"
            if not args.quick:
                h = hashlib.sha256()
                with path.open("rb") as handle:
                    for chunk in iter(lambda: handle.read(16 * 1024 * 1024), b""):
                        h.update(chunk)
                digest = h.hexdigest()
            print(f"F\t{rel}\t{size}\t{digest}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
