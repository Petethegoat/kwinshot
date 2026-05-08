#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v git >/dev/null 2>&1; then
    echo "update.sh: git is required" >&2
    exit 1
fi

if ! git -C "${repo_dir}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "update.sh: ${repo_dir} is not a git checkout" >&2
    exit 1
fi

if [[ -n "$(git -C "${repo_dir}" status --porcelain)" ]]; then
    echo "update.sh: working tree has local changes; commit, stash, or discard them first" >&2
    exit 1
fi

echo "==> Updating source"
git -C "${repo_dir}" pull --ff-only

echo "==> Reinstalling"
"${repo_dir}/install.sh"
