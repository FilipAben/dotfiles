-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()
-- config.color_scheme = 'Belge (terminal.sexy)'
config.color_scheme = 'Bluloco Zsh Light (Gogh)'
config.font = wezterm.font 'BlexMono Nerd Font'
config.scrollback_lines = 100000
if wezterm.hostname() == "Flab-desktop" then
  config.font_size = 14
else
  config.font_size = 12
end
local act = wezterm.action


if wezterm.target_triple == 'x86_64-pc-windows-msvc' then

config.wsl_domains = {
  {
    -- The name of this specific domain.  Must be unique amonst all types
    -- of domain in the configuration file.
    name = 'WSL:Ubuntu',

    -- The name of the distribution.  This identifies the WSL distribution.
    -- It must match a valid distribution from your `wsl -l -v` output in
    -- order for the domain to be useful.
    distribution = 'Ubuntu',
  },
}
config.default_domain = 'WSL:Ubuntu'

end

-- Change mouse scroll amount
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(-5),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(5),
  },
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'Word',
    mods = 'NONE',
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    action = wezterm.action.CompleteSelection 'Clipboard',
    mods = 'NONE',
  },
}

config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.7,
}

config.keys = {
  {
    key = 't',
    mods = 'CMD',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'n',
    mods = 'CMD',
    action = act.SpawnWindow,
  },
  {
    key = 'd',
    mods = 'CMD',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'f',
    mods = 'CMD',
    action = act.TogglePaneZoomState,
  },
  -- Adjusting pane size
  {
    key = 'h',
    mods = 'CTRL',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = act.AdjustPaneSize { 'Down', 5 },
  },
  { 
    key = 'k', 
    mods = 'CTRL',
    action = act.AdjustPaneSize { 'Up', 5 }
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = act.AdjustPaneSize { 'Right', 5 },
  },
  -- Navigating panes
  {
    key = 'h',
    mods = 'CMD',
    action = act.ActivatePaneDirection 'Left'
  },
  {
    key = 'j',
    mods = 'CMD',
    action = act.ActivatePaneDirection 'Down'
  },
  { 
    key = 'k', 
    mods = 'CMD', 
    action = act.ActivatePaneDirection 'Up'
  },
  {
    key = 'l',
    mods = 'CMD',
    action = act.ActivatePaneDirection 'Right'
  },
  -- Searching
  {
    key = 'f',
    mods = 'CMD',
    action = act.Search("CurrentSelectionOrEmptyString"),
  },
  { mods = "CMD", 
    key = "Backspace", 
    action = act.SendKey({ mods = "CTRL", key = "u" })
  }
}

for i = 1, 8 do
  -- CTRL+SUPER + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CMD',
    action = act.ActivateTab(i - 1),
  })
end

return config
