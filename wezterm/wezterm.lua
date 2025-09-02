local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Font
config.font_size = 14
config.font = wezterm.font("SF Mono")
config.font_rules = {
	{
		intensity = "Bold",
		font = wezterm.font({
			family = "SF Mono",
			weight = "Bold",
		}),
	},
	{
		intensity = "Half",
		font = wezterm.font({
			family = "SF Mono",
			weight = "Bold",
		}),
	},
}
config.bold_brightens_ansi_colors = "BrightAndBold"

-- Color scheme
config.color_scheme = "nord"

-- Window settings
-- Hide the OS title bar but keep a resizable border
config.window_decorations = "RESIZE"

config.window_frame = {
	font = wezterm.font({
		family = "SF Mono",
		weight = "Bold",
	}),
	font_size = 12.0,
	active_titlebar_bg = "#3b4252",
	inactive_titlebar_bg = "#3b4252",
}

-- Tabs
config.use_fancy_tab_bar = false
config.colors = {
	tab_bar = {
		background = "#2e3440", -- Polar Night 0

		active_tab = {
			bg_color = "#81a1c1", -- Frost
			fg_color = "#2e3440", -- Polar Night 0 (great contrast on the Frost blue)
			intensity = "Bold",
		},

		inactive_tab = {
			bg_color = "#3b4252", -- Polar Night 1
			fg_color = "#d8dee9", -- Snow Storm 0
		},

		inactive_tab_hover = {
			bg_color = "#434c5e", -- Polar Night 2
			fg_color = "#e5e9f0", -- Snow Storm 1
		},

		new_tab = {
			bg_color = "#2e3440", -- match bar
			fg_color = "#4c566a", -- Polar Night 3
		},

		new_tab_hover = {
			bg_color = "#4c566a", -- slightly brighter than bar
			fg_color = "#eceff4", -- Snow Storm 2
		},

		inactive_tab_edge = "#2e3440",
	},
}

config.leader = { key = "`", mods = "NONE", timeout_milliseconds = 1000 }

local act = wezterm.action

config.keys = {
	-- Double-press backtick to type a literal `
	{ key = "`", mods = "LEADER", action = act.SendString("`") },

	-- Splits (tmux: v -> split-window -h, s -> split-window)
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- New "window" in current dir (tmux new-window) -> new TAB in same domain/cwd
	{ key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

	-- Next / Previous "window" (tab)
	{ key = "l", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "h", mods = "LEADER", action = act.ActivateTabRelative(-1) },

	-- Swap windows (move the current tab left/right and follow it)
	{
		key = "L",
		mods = "LEADER|SHIFT",
		action = act.MoveTabRelative(1),
	},
	{
		key = "H",
		mods = "LEADER|SHIFT",
		action = act.MoveTabRelative(-1),
	},

	-- Navigate panes (no prefix)
	{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },

	-- Resize panes (Shift + arrows)
	{ key = "LeftArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 2 }) },
	{ key = "RightArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 2 }) },
	{ key = "DownArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "UpArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },

	-- Copy-mode
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },

	-- Select workspace
	{ key = "f", mods = "LEADER", action = act.ShowLauncherArgs({
		flags = "WORKSPACES",
	}) },

	-- New-session: prompt for a workspace name and switch/create it
	{
		key = "N",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "New workspace name",
			action = wezterm.action_callback(function(window, pane, line)
				if line and #line > 0 then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
							spawn = { domain = "CurrentPaneDomain" }, -- starts in current dir
						}),
						pane
					)
				end
			end),
		}),
	},

	-- Kill-session: close the current tab (adjust to taste)
	{ key = "X", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },

	-- Zoom one pane (tmux: z)
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- Go to tab
	{ key = "g", mods = "LEADER", action = act.ShowTabNavigator },

	-- Rename tab
	{
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Rename tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line and #line > 0 then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- Copy mode keybindings
default_key_tables = wezterm.gui.default_key_tables()

table.insert(default_key_tables.copy_mode, {
	key = "y",
	mods = "NONE",
	action = act.Multiple({
		act.CopyTo("Clipboard"),
		act.ClearSelection,
		act.CopyMode("Close"),
	}),
})

table.insert(default_key_tables.copy_mode, {
	key = "Enter",
	mods = "NONE",
	action = act.Multiple({
		act.CopyTo("Clipboard"),
		act.ClearSelection,
		act.CopyMode("Close"),
	}),
})

-- Search
local function complete_search(should_clear)
	return wezterm.action_callback(function(window, pane, _)
		if should_clear then
			window:perform_action(act.CopyMode("ClearPattern"), pane)
		end
		window:perform_action(act.CopyMode("AcceptPattern"), pane)

		-- For some reason this just does not work unless we retry a few times.
		-- Probably something to do with state management between Search/Copy mode.
		for _ = 1, 3, 1 do
			wezterm.sleep_ms(100)
			window:perform_action(act.CopyMode("ClearSelectionMode"), pane)
		end
	end)
end

table.insert(default_key_tables.search_mode, {
	key = "Escape",
	mods = "NONE",
	action = complete_search(true),
})

table.insert(default_key_tables.search_mode, {
	key = "Enter",
	mods = "NONE",
	action = complete_search(false),
})

config.key_tables = default_key_tables

-- Show workspace in status bar
wezterm.on("update-status", function(window, _)
	local ws = window:active_workspace()
	-- Use your scheme colors so it blends in
	local p = window:effective_config().resolved_palette
	window:set_left_status(wezterm.format({
		{ Background = { Color = p.tab_bar and p.tab_bar.background or p.background } },
		{ Foreground = { Color = p.foreground } },
		{ Text = " " .. ws .. " " },
	}))
end)

-- Tabs titles
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- The tab index starts at 0, so we add 1 to make it start from 1.
	-- The '..'' is Lua's way of converting the number to a string.
	local index = tab.tab_index + 1
	local title = ""

	if tab.tab_title and tab.tab_title ~= "" then
		title = tab.tab_title
	else
		title = tostring(index)
	end

	-- Return the index as the text for the tab.
	return {
		{ Text = " " .. title .. " " },
	}
end)

return config
