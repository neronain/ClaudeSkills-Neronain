#!/usr/bin/env python3
from __future__ import annotations
import argparse
import json
from pathlib import Path
import hashlib

SMALL_LIMIT = 20 * 1024 * 1024

def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(16 * 1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def load_json(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        return {"_error": repr(exc)}

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("snapshot", type=Path)
    args = parser.parse_args()
    root = args.snapshot.resolve()
    if not root.is_dir():
        raise SystemExit(f"Missing snapshot: {root}")
    report = {
        "snapshot": str(root),
        "files": [],
        "config": None,
        "quantization": None,
        "index": None,
        "broken_symlinks": [],
    }
    for path in sorted(root.iterdir()):
        item = {
            "name": path.name,
            "is_symlink": path.is_symlink(),
            "size": path.stat().st_size if path.exists() and path.is_file() else None,
        }
        if path.is_symlink():
            item["link_target"] = str(path.readlink())
            if not path.exists():
                report["broken_symlinks"].append(path.name)
        if path.exists() and path.is_file() and path.stat().st_size <= SMALL_LIMIT:
            item["sha256"] = sha256(path)
        report["files"].append(item)
    for name, key in (
        ("config.json", "config"),
        ("hf_quant_config.json", "quantization"),
        ("quantization_config.json", "quantization"),
        ("model.safetensors.index.json", "index"),
    ):
        path = root / name
        if path.exists():
            report[key] = load_json(path)
    print(json.dumps(report, indent=2, ensure_ascii=False))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
