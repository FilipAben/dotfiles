-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Belge'
config.font = wezterm.font 'BlexMono Nerd Font'

config.keys = {
  {
    key = 'c',
    mods = 'ALT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  {
    key = 'v',
    mods = 'ALT',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  {
    key = 't',
    mods = 'ALT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'n',
    mods = 'ALT',
    action = wezterm.action.SpawnWindow,
  },
  {
    key = 'd',
    mods = 'ALT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'd',
    mods = 'ALT|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain'},
  },
  {
    key = 'f',
    mods = 'ALT',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = 's',
    mods = 'ALT',
    action = wezterm.action.PaneSelect,
  },
  {
    key = 'h',
    mods = 'ALT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'j',
    mods = 'ALT',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },
  { 
    key = 'k', 
    mods = 'LEADER', 
    action = wezterm.action.AdjustPaneSize { 'Up', 5 } 
  },
  {
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
}

for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return config
