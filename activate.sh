#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ -x "$HOME/.config/neobrutal/control" ]]; then "$HOME/.config/neobrutal/control" stop; fi
python "$root/apply.py" "$@"
if [[ "${1:-}" != --restore ]]; then python "$root/firefox.py"; fi
if command -v herdr >/dev/null; then herdr server reload-config || true; fi
hyprctl reload
errors="$(hyprctl configerrors)"
if [[ -n "${errors//[[:space:]]/}" ]]; then printf '%s\n' "$errors" >&2; exit 1; fi
pkill -x waybar || true
pkill -x hyprpaper || true
if [[ "${1:-}" == --restore ]]; then
    hyprctl eval 'hl.exec_cmd("waybar")'
else
    hyprctl eval 'hl.exec_cmd(os.getenv("HOME") .. "/.config/neobrutal/control start")'
fi
hyprctl eval 'hl.exec_cmd("hyprpaper")'
