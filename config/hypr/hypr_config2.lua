-- Hyprland Config 2 - Focus Mode (no gaps, no borders, no animations)

---- MONITORS ----
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60",
	position = "1920x0",
	scale = 1,
})

hl.monitor({
	output = "DP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 1,
})

---- AUTOSTART ----
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("hyprpm reload -n")
end)

---- ENVIRONMENT VARIABLES ----
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

---- LOOK AND FEEL ----
hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 0,
		col = {
			active_border = "rgba(ee5396ff)",
			inactive_border = "rgba(78a9ffff)",
		},
		resize_on_border = true,
		hover_icon_on_border = true,
		extend_border_grab_area = 10,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 50,
		rounding_power = 1.0,
		active_opacity = 0.8,
		inactive_opacity = 0.8,
		shadow = {
			enabled = true,
			range = 5,
			render_power = 10,
		},
		blur = {
			enabled = true,
			xray = true,
			size = 5,
			passes = 3,
			vibrancy = 0.0,
			vibrancy_darkness = 1.0,
			brightness = 0.8,
			contrast = 1.0,
		},
	},

	animations = {
		enabled = false,
	},

	cursor = {
		no_hardware_cursors = false,
	},

	master = {
		new_status = "master",
	},

	input = {
		kb_layout = "br",
		kb_variant = "abnt2",
		numlock_by_default = true,
	},

	binds = {
		workspace_back_and_forth = true,
	},
})

---- ANIMATIONS ----
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

---- WINDOW RULES ----
hl.window_rule({
	match = { class = "neovide" },
	opacity = "0.9 override",
})

hl.window_rule({
	match = { initial_title = "^(Cliphist FZF)$" },
	float = true,
	size = "(monitor_w*0.8) (monitor_h*0.3)",
	move = "(monitor_w*0.1) (monitor_h*0.65)",
})

hl.window_rule({
	match = { class = "^(yazi-(toggle|special))$" },
	workspace = "special:yazi",
	opacity = "0.85 0.85",
})

hl.window_rule({
	match = { class = "^(discord)$" },
	workspace = "special:discord",
})

---- LAYER RULES ----
hl.layer_rule({
	match = { namespace = "kitty" },
	blur = true,
	ignore_alpha = 0.5,
})

---- WORKSPACE RULES ----
hl.workspace_rule({
	workspace = "special:yazi",
	on_created_empty = "kitty --class=yazi-special -e yazi",
})

hl.workspace_rule({
	workspace = "special:discord",
	on_created_empty = "discord",
})

-- Dedicated Herdr terminal; create once and reuse while it is open.
hl.window_rule({
  match = { class = "^(herdr-special)$" },
  workspace = "special:herdr",
})
hl.workspace_rule({
  workspace = "special:herdr",
  on_created_empty = "kitty --class=herdr-special --title=Herdr -e fish -ic herdr",
})

---- KEYBINDINGS ----
local mainMod = "SUPER"

hl.bind(mainMod .. " + C", hl.dsp.workspace.toggle_special("herdr"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("st"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd('kitty --title "Cliphist FZF" sh -c "/home/amitis/scripts/cliphist_fzf.sh"'))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("sh -c '/home/amitis/scripts/dmenu_cliphist.sh add'"))
hl.bind("F7", hl.dsp.exec_cmd("sh -c '~/scripts/f1_hypr_conf.sh'"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("kill -9 $(hyprctl activewindow -j | jq .pid)"))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.center())
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.resize({ x = 1000, y = 600 }))
hl.bind(mainMod .. " + E", hl.dsp.workspace.toggle_special("yazi"))
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mainMod .. " + A", hl.dsp.workspace.toggle_special("discord"))

-- Move focus (vim keys)
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume and Media Control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -m"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- Volume (with notifications)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume --inc"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume --dec"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume --toggle-mic"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume --toggle"))

-- Neobrutal palette: cream paper, ink outlines, hard offset shadows.
hl.config({
 general = { gaps_in = 8, gaps_out = 16, border_size = 2,
   col = { active_border = "rgba(241d1bff)", inactive_border = "rgba(65534aff)" } },
 decoration = { rounding = 14, rounding_power = 2.0,
   active_opacity = 1.0, inactive_opacity = 1.0,
   blur = { enabled = false },
   shadow = { enabled = true, range = 0, render_power = 4,
     color = "rgba(241d1bff)", offset = { 6, 6 } } }
})
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("~/.config/neobrutal/control dashboard"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("~/.config/neobrutal/control widgets"))

-- Keep the existing F7 distraction-free mode.
hl.config({ general = { gaps_in = 0, gaps_out = 0, border_size = 0 }, decoration = { rounding = 0, shadow = { enabled = false } } })

-- Notification center, available in normal and focus modes.
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client --toggle-panel"))
