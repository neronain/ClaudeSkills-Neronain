#!/usr/bin/env python3
from __future__ import annotations
import argparse
from pathlib import Path
import shutil
import re

def slugify(value: str) -> str:
    value = value.rsplit("/", 1)[-1].lower()
    value = re.sub(r"[^a-z0-9]+", "-", value).strip("-")
    return value or "dgx-model"

def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model-id", required=True)
    parser.add_argument("--runtime", choices=("vllm", "llamacpp"), required=True)
    parser.add_argument("--topology", choices=("single", "stacked"), required=True)
    parser.add_argument("--slug")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--skill-dir", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    slug = args.slug or slugify(args.model_id)
    out = args.output.resolve() / slug
    out.mkdir(parents=True, exist_ok=False)
    templates = args.skill_dir.resolve() / "templates"
    if args.runtime == "llamacpp":
        source = templates / "single-llamacpp-controller.sh"
    elif args.topology == "stacked":
        source = templates / "stacked-vllm-controller.sh"
    else:
        source = templates / "single-vllm-controller.sh"
    controller = out / f"{slug}-{'stacked' if args.topology == 'stacked' else 'single'}.sh"
    shutil.copy2(source, controller)
    controller.chmod(0o755)
    for name in ("README.md", "SPECIAL_FILES.md", "MODEL_PROFILE.yaml"):
        shutil.copy2(templates / name, out / name)
    print(out)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
