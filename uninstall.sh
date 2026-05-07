#!/usr/bin/env bash
set -euo pipefail

prefix="/usr/local"
binary="${prefix}/bin/kwinshot"
desktop_file="${prefix}/share/applications/net.local.kwinshot.desktop"

if (( EUID == 0 )); then
    sudo_cmd=()
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "uninstall.sh: sudo is required when not running as root" >&2
        exit 1
    fi
    sudo_cmd=(sudo)
fi

echo "==> Removing kwinshot from ${prefix}"
"${sudo_cmd[@]}" rm -f "${binary}" "${desktop_file}"

if command -v kbuildsycoca6 >/dev/null 2>&1; then
    echo "==> Rebuilding KDE service cache"
    kbuildsycoca6 --noincremental
else
    echo "uninstall.sh: kbuildsycoca6 not found; log out/in if KDE still shows KWinShot" >&2
fi

echo
echo "Uninstalled kwinshot."
