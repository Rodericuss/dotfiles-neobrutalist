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

## Apply or restore

```bash
git clone https://github.com/Rodericuss/dotfiles-neobrutalist.git
cd dotfiles-neobrutalist
./activate.sh
./activate.sh --restore
```

Only the theme files are copied. Each application saves replaced files under `~/.local/state/dotfiles-backups/neobrutal-apply-*`. The first pre-theme state is retained across repeated applications and restored by `--restore`. The restore command reloads Hyprland, Waybar and the wallpaper. Existing Kitty instances may require **Ctrl + Shift + F5** to reload colors; application-specific themes inside terminals are independent.

This repository contains the standalone neobrutalist theme. The cyberpunk desktop and base installer live in [dotfiles-cyberpunk](https://github.com/Rodericuss/dotfiles-cyberpunk). Activation replaces the included application configurations and saves a rollback manifest.

## Requirements and scope

Targets the installed Hyprland 0.56 Lua configuration. Dependencies are listed in `packages.txt` and must be installed before activation. The included Lua configurations are a workstation snapshot: review monitor definitions, keyboard layout, application shortcuts and workspace rules before applying. They include `/home/amitis` paths and require existing helper scripts in `~/scripts` (including the Lua-compatible F7 script). Adjust these paths for another user. This is not yet a portable fresh-machine installer. Widget geometry is tested at 1920×1080.

The theme includes the bar, dashboard, tasks, calendar, timer, media controls, wallpaper, window borders/shadows, Kitty and Rofi. It does not install compositor plugins, custom application titlebars, Cava, or a weather service. The original artwork and unpublished Quickshell source are not bundled. Bluetooth controls require a Bluetooth adapter; no adapter was detected on this workstation.

Source: `config/neobrutal/shell.py` and `style.css`. Logs: `~/.local/state/neobrutal/{shell,waybar,swaync}.log`. The generic dotfiles installer is not used to apply this theme, so unrelated editor/browser/Fish configuration stays untouched.


## Application theme follow-up

Starship now uses pastel prompt badges. Herdr uses ink backgrounds, light text and pastel accents for readable terminal applications. The Fish `herdr` function applies a dedicated Kitty palette while the interactive client is running, then restores the paper terminal palette on exit; CLI helper commands are unchanged. Herdr 0.7.1 does not support the newer `sidebar_bg` / `active_row_bg` tokens, so only supported custom colors are used.

Firefox source files live in `~/.config/firefox`. `firefox.py` installs `userChrome.css` and a `userContent.css` block scoped to the actual Sidebery extension UUID in the installed profile. It leaves extension settings, tabs, cookies and history alone. **Restart Firefox to load these files.** `sideberry.css` can alternatively be pasted into Sidebery's Settings → Styles editor. Browser profile CSS is included in the same rollback manifest; restarting Firefox after restoration restores the previous appearance.

Rofi configuration properties must be on separate lines with this installed build. Verification now checks `-dump-config` and actual launcher rendering, rather than relying on `-dump-theme` alone.

References: [Herdr configuration](https://herdr.dev/docs/configuration/), [Sidebery CSS](https://github.com/mbnuqw/sidebery/wiki/Sidebery-Styles-Snippets). Codex's `tui.theme` changes syntax highlighting, so input contrast is handled with the terminal palette, not an invented Codex setting.

## Neovim

The `neobrutalist` colorscheme uses the installed Cyberdream engine with an opaque ink background, warm text, pastel syntax colors and accented picker borders. Lualine uses rectangular sections: peach for normal, green for insert, lilac for visual, yellow for command and blue for terminal mode.

The files in `config/nvim` overlay the existing Kickstart/lazy.nvim configuration. They require `scottmckendry/cyberdream.nvim`, `nvim-lualine/lualine.nvim`, and the `custom.plugins` import. They do not replace the editor's keymaps or language tooling. The plugin override disables the old Tokyonight init callback that loaded CYBR colors and hard-coded Telescope/Elixir highlights.

Restart Neovim after activation. Palette: `config/nvim/lua/neobrutalist/palette.lua`. Theme: `config/nvim/colors/neobrutalist.lua`. Statusline: `config/nvim/lua/lualine/themes/neobrutalist.lua`. Upstream engine: [Cyberdream](https://github.com/scottmckendry/cyberdream.nvim); no upstream source is copied or forked.

When running inside Kitty with remote control enabled, Neovim matches its own terminal background to the editor and uses 4 px padding. This removes the contrasting rectangular frame inside the rounded compositor window. The previous terminal background and configured padding are restored on exit or suspension. Other terminal windows are not targeted.

## Notifications and Firefox

SwayNC uses opaque cream cards, pastel controls and bundled SVG notification/music icons. Media controls use dark symbols; the music illustration replaces the album thumbnail. The stylesheet imports `/etc/xdg/swaync/style.css` from the installed SwayNC package. Activation and restoration reload the stylesheet.

Firefox uses a light-grey focused address field with dark text. Restart Firefox after applying or restoring browser CSS.
