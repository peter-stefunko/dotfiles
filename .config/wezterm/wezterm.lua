-- ~/.config/wezterm/wezterm.lua

local wezterm = require 'wezterm'

local color_scheme = 'Gruvbox'
local color_schemes = require 'color-schemes.gruvbox'
local tab_bar = require 'tab-bar.gruvbox'

local font = wezterm.font("JetBrainsMono Nerd Font")
local font_size = 10.0

local config = {
  font = font,
  font_size = font_size,

  color_scheme = color_scheme,
  color_schemes = color_schemes,

  default_cursor_style = "BlinkingBlock",
  animation_fps = 1,
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  cursor_thickness = 1,

  window_padding = {
    left = 2,
    right = 2,
    top = 2,
    bottom = 2,
  },

  window_frame = {
    font = font,
    font_size = font_size,
    active_titlebar_bg = tab_bar.window_frame.active_titlebar_bg,
    inactive_titlebar_bg = tab_bar.window_frame.inactive_titlebar_bg,
  },

  colors = {
    tab_bar = tab_bar.colors.tab_bar,
  },

  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
}

return config
