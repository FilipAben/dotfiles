-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Belge'
config.font = wezterm.font 'BlexMono Nerd Font'
config.scrollback_lines = 100000

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
    mods = 'ALT',
    action = act.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'ALT',
    action = act.PasteFrom 'Clipboard',
  },
  {
    key = 't',
    mods = 'ALT',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'n',
    mods = 'ALT',
    action = act.SpawnWindow,
  },
  {
    key = 'd',
    mods = 'ALT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'd',
    mods = 'ALT|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'f',
    mods = 'ALT',
    action = act.TogglePaneZoomState,
  },
  {
    key = 's',
    mods = 'ALT',
    action = act.PaneSelect,
  },
  {
    key = 'h',
    mods = 'ALT',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'j',
    mods = 'ALT',
    action = act.AdjustPaneSize { 'Down', 5 },
  },
  { 
    key = 'k', 
    mods = 'LEADER', 
    action = act.AdjustPaneSize { 'Up', 5 } 
  },
  {
    key = 'l',
    mods = 'ALT',
    action = act.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'f',
    mods = 'ALT',
    action = act.Search("CurrentSelectionOrEmptyString"),
  },
}

for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end

return config
