# Neobrutalist dotfiles

A local recreation of the pastel / ink aesthetic in [Darkkal44's Bruteon](https://github.com/Darkkal44/Bruteon). The original repository has previews only as of September 10, 2026; this implementation uses Waybar and a native GTK 3 layer-shell widget process.

## Use

- **Super + Tab** or the grid button: dashboard, system usage, apps, audio and media.
- **Super + N**: toggle the notification center (normal and focus modes).
- **Super + C**: open or toggle the dedicated Herdr terminal.
- **Super + E / Super + A**: toggle the existing Yazi / Discord special workspaces; dashboard buttons use these workspaces too.
- **Super + T**, Tasks, or the clock: tasks, calendar, focus timer and music.
- The dashboard and tasks/calendar panels toggle independently and can stay open together.
- **Escape**: close widgets when they have keyboard focus. The same shortcut/button also closes them.
- **F7**: existing normal / distraction-free mode, with the bar hidden in focus mode.
- Tasks are stored locally in `~/.local/state/neobrutal/tasks.json`.
- Focus / Break / Long: 25 / 5 / 15 minutes. Start/pause and reset controls; notification at completion. Timer state lasts for the widget process lifetime.
- Media follows the active MPRIS player. The color dots are decorative, not an audio visualizer.

## Install on a fresh Arch + Hyprland desktop

Requirements: internet, Git, and a regular user with sudo access. The installer
installs unzip and every package listed in `packages.txt`, including ripgrep
(`rg`), fzf, Node.js/npm, fnm, Python/pip/pipx, Rustup, build tools, Fish,
Kitty, Neovim, Firefox, Discord, audio, Bluetooth and desktop components.

```bash
git clone https://github.com/Rodericuss/dotfiles-neobrutalist.git ~/dotfiles-neobrutalist
cd ~/dotfiles-neobrutalist
./install.sh --dry-run
./install.sh
```

Run without sudo; package/service steps request sudo themselves. The installer
updates Arch with `pacman -Syu`, installs Rust stable (preserving an existing
default toolchain), installs Herdr if missing using its official installer,
copies the bundled base and theme, builds font/Bat caches, and installs Neovim
plugins and Mason tools. No second dotfiles checkout is needed. Node/npm are
available system-wide; fnm is configured for projects that use `.nvmrc`.
Python desktop dependencies come from pacman, not global pip installs.

Log out and enter Hyprland after completion. The installer does not reload your
current desktop. Kitty uses Fish without changing your login shell. NetworkManager,
Bluetooth and user audio services are enabled. No credentials or agent accounts
are configured. Firefox/Sidebery CSS is applied to existing Sidebery profiles;
install Sidebery in Firefox and rerun `./activate.sh` to style a new profile.

### Options and machine settings

- `--dry-run`: print actions without changing files, downloading or installing.
- `--no-packages`: skip pacman and service setup when dependencies already exist.
- `--no-tools`: skip Rust/Herdr downloads and Neovim plugin/tool installation.
- Both skip options together install only files and rebuild local font/Bat caches.
- Default monitor: preferred mode, automatic position, scale 1.
- Default keyboard: Brazilian ABNT2. Put monitor/input overrides in
  `~/.config/hypr/local.lua`; both F7 modes load it and installation preserves it.
- Requires the Hyprland Lua API (validated with 0.56.2). The installer checks the
  actual parser before replacing files and stops on incompatible configurations.
- Conventional `~/.config`, `~/.local/share` and `~/.local/state` paths are required.

### Apply the theme only or restore

```bash
./activate.sh
./activate.sh --restore
```

`activate.sh` applies the theme to an existing base; use `install.sh` on fresh
machines. Both share a rollback manifest in `~/.local/state/neobrutal/restore.json`.
Replaced files are saved under `~/.local/state/dotfiles-backups/neobrutal-apply-*`.
Repeated installation preserves the first pre-install state. Restore recovers
those files and removes files added by installation; packages, downloaded
plugins/toolchains and enabled services remain installed. In a TTY, activation
and restoration copy files without trying to reload a missing Hyprland session.
Existing Kitty windows may need **Ctrl + Shift + F5** to reload colors.

The bundled base (Neovim, Fish integration, fonts and GTK/Bat configuration) was
adapted from the sibling Cyberpunk repository. Upstream notices are retained.
The clipboard uses cliphist's database with fzf; F7 and volume helpers are bundled.
Widget geometry is tested at 1920×1080.

The theme includes the bar, dashboard, tasks, calendar, timer, media controls, wallpaper, window borders/shadows, Kitty and Rofi. It does not install compositor plugins, custom application titlebars, Cava, or a weather service. The original artwork and unpublished Quickshell source are not bundled. Bluetooth controls require a Bluetooth adapter; no adapter was detected on this workstation.

Source: `config/neobrutal/shell.py` and `style.css`. Logs: `~/.local/state/neobrutal/{shell,waybar,swaync}.log`. The theme-only activation does not install the bundled base.


## Application theme follow-up

Starship now uses pastel prompt badges. Herdr uses ink backgrounds, light text and pastel accents for readable terminal applications. The Fish `herdr` function applies a dedicated Kitty palette while the interactive client is running, then restores the paper terminal palette on exit; CLI helper commands are unchanged. Herdr 0.7.1 does not support the newer `sidebar_bg` / `active_row_bg` tokens, so only supported custom colors are used.

Firefox source files live in `~/.config/firefox`. `firefox.py` installs `userChrome.css` and a `userContent.css` block scoped to the actual Sidebery extension UUID in the installed profile. It leaves extension settings, tabs, cookies and history alone. **Restart Firefox to load these files.** `sideberry.css` can alternatively be pasted into Sidebery's Settings → Styles editor. Browser profile CSS is included in the same rollback manifest; restarting Firefox after restoration restores the previous appearance.

Rofi configuration properties must be on separate lines with this installed build. Verification now checks `-dump-config` and actual launcher rendering, rather than relying on `-dump-theme` alone.

References: [Herdr configuration](https://herdr.dev/docs/configuration/), [Sidebery CSS](https://github.com/mbnuqw/sidebery/wiki/Sidebery-Styles-Snippets). Codex's `tui.theme` changes syntax highlighting, so input contrast is handled with the terminal palette, not an invented Codex setting.

## Neovim

The `neobrutalist` colorscheme uses the installed Cyberdream engine with an opaque ink background, warm text, pastel syntax colors and accented picker borders. Lualine uses rectangular sections: peach for normal, green for insert, lilac for visual, yellow for command and blue for terminal mode.

The files in `config/nvim` overlay the Kickstart/lazy.nvim configuration bundled in `base/config/nvim`. The full installer includes that base. They require `scottmckendry/cyberdream.nvim`, `nvim-lualine/lualine.nvim`, and the `custom.plugins` import. They do not replace the editor's keymaps or language tooling. The plugin override disables the old Tokyonight init callback that loaded CYBR colors and hard-coded Telescope/Elixir highlights.

Restart Neovim after activation. Palette: `config/nvim/lua/neobrutalist/palette.lua`. Theme: `config/nvim/colors/neobrutalist.lua`. Statusline: `config/nvim/lua/lualine/themes/neobrutalist.lua`. Upstream engine: [Cyberdream](https://github.com/scottmckendry/cyberdream.nvim); no upstream source is copied or forked.

When running inside Kitty with remote control enabled, Neovim matches its own terminal background to the editor and uses 4 px padding. This removes the contrasting rectangular frame inside the rounded compositor window. The previous terminal background and configured padding are restored on exit or suspension. Other terminal windows are not targeted.

## Notifications and Firefox

SwayNC uses opaque cream cards, pastel controls and bundled SVG notification/music icons. Media controls use dark symbols; the music illustration replaces the album thumbnail. The stylesheet imports `/etc/xdg/swaync/style.css` from the installed SwayNC package. Activation and restoration reload the stylesheet.

Firefox uses a light-grey focused address field with dark text. Restart Firefox after applying or restoring browser CSS.
