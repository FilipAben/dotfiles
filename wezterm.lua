-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Belge (terminal.sexy)'
config.font = wezterm.font 'BlexMono Nerd Font'
config.scrollback_lines = 100000
config.font_size = 16
local act = wezterm.action

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
}

config.keys = {
  {
    key = 'c',
    mods = 'SUPER',
    action = act.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'SUPER',
    action = act.PasteFrom 'Clipboard',
  },
  {
    key = 't',
    mods = 'SUPER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'n',
    mods = 'SUPER',
    action = act.SpawnWindow,
  },
  {
    key = 'd',
    mods = 'SUPER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'd',
    mods = 'SUPER|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'f',
    mods = 'SUPER',
    action = act.TogglePaneZoomState,
  },
  -- Adjusting pane size
  {
    key = 'h',
    mods = 'SUPER',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'j',
    mods = 'SUPER',
    action = act.AdjustPaneSize { 'Down', 5 },
  },
  { 
    key = 'k', 
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Up', 5 }
  },
  {
    key = 'l',
    mods = 'SUPER',
    action = act.AdjustPaneSize { 'Right', 5 },
  },
  -- Navigating panes
  {
    key = 'h',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Left'
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Down'
  },
  { 
    key = 'k', 
    mods = 'CTRL', 
    action = act.ActivatePaneDirection 'Up'
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = act.ActivatePaneDirection 'Right'
  },
  -- Searching
  {
    key = 'f',
    mods = 'SUPER',
    action = act.Search("CurrentSelectionOrEmptyString"),
  },
}

for i = 1, 8 do
  -- CTRL+SUPER + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'SUPER',
    action = act.ActivateTab(i - 1),
  })
end

return config
