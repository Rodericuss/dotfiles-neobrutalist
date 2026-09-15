#!/usr/bin/env bash
set -Eeuo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
dry=0; packages=1; tools=1
usage() {
    echo 'Usage: ./install.sh [--dry-run] [--no-packages] [--no-tools]'
    echo 'Arch Linux + Hyprland Lua. Run as your regular user, with sudo access.'
    echo '--no-tools skips Rust/Herdr downloads and Neovim plugin/tool bootstrap.'
}
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry=1 ;;
        --no-packages) packages=0 ;;
        --no-tools) tools=0 ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done
run() {
    if ((dry)); then printf '+ '; printf '%q ' "$@"; printf '\n'; else "$@"; fi
}
trap 'echo "Installation stopped at line $LINENO. Fix the reported error and rerun; backups are retained." >&2' ERR
if ((EUID == 0)); then echo 'Run as your regular user, not sudo/root.' >&2; exit 1; fi
# Configs use conventional paths, consistently with Hyprland and the theme helpers.
for pair in "${XDG_CONFIG_HOME:-$HOME/.config}:$HOME/.config" "${XDG_DATA_HOME:-$HOME/.local/share}:$HOME/.local/share" "${XDG_STATE_HOME:-$HOME/.local/state}:$HOME/.local/state"; do
    [[ "${pair%%:*}" == "${pair#*:}" ]] || { echo 'Custom XDG directories are not supported by this theme yet.' >&2; exit 1; }
done
if ((packages)); then
    command -v pacman >/dev/null || { echo 'Automatic package installation requires Arch Linux (pacman).' >&2; exit 1; }
    mapfile -t deps < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$root/packages.txt")
    run sudo pacman -Syu --needed "${deps[@]}"
fi
if (( ! dry )); then
    command -v python >/dev/null
    command -v Hyprland >/dev/null
    # Check the actual parser before replacing the user's configuration.
    Hyprland --verify-config -c "$root/config/hypr/hyprland.lua"
fi
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
if ((tools)); then
    run rustup toolchain install stable --profile default
    if ((dry)) || ! rustup show active-toolchain >/dev/null 2>&1; then run rustup default stable; fi
    if ! command -v herdr >/dev/null; then
        if ((dry)); then
            echo '+ download https://herdr.dev/install.sh and run with sh'
        else
            temp_dir=$(mktemp -d)
            trap 'rm -rf -- "$temp_dir"' EXIT
            curl -fsSL https://herdr.dev/install.sh -o "$temp_dir/herdr-install.sh"
            sh "$temp_dir/herdr-install.sh"
        fi
    fi
fi
run python "$root/apply.py" --full
run python "$root/firefox.py"
run fc-cache -f "$HOME/.local/share/fonts"
run bat cache --build
if ((tools)); then
    run nvim --headless '+Lazy! restore' +qa
    run env NEOBRUTAL_NVIM_CHECK="$root/scripts/check-nvim.lua" nvim --headless '+MasonToolsInstallSync' '+lua dofile(vim.env.NEOBRUTAL_NVIM_CHECK)' +qa
fi
if ((packages)); then
    run sudo systemctl enable --now NetworkManager.service bluetooth.service
    if ((dry)) || systemctl --user show-environment >/dev/null 2>&1; then
        run systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
    else
        echo 'No user session bus: audio will start when you log into Hyprland.'
    fi
fi
if ((dry)); then echo 'Dry run complete; no changes made.'; else echo 'Installation complete. Log out and enter Hyprland; Kitty opens Fish.'; fi
echo 'Machine-specific settings: ~/.config/hypr/local.lua (keyboard defaults to br/abnt2).'
echo 'Restore files with ./activate.sh --restore. Packages/toolchains are retained.'
