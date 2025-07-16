-- ~/.config/wezterm/tab-bar/gruvbox.lua

local wezterm = require 'wezterm'
local colors = require 'colors.gruvbox'

return {
  window_frame = {
    active_titlebar_bg = colors.normal.black,
    inactive_titlebar_bg = colors.dark.black,
  },

  colors = {
    tab_bar = {
      background = colors.normal.black,
      inactive_tab_edge = colors.normal.black,

      active_tab = {
        bg_color = colors.normal.black,
        fg_color = colors.bright.white,
      },

      inactive_tab = {
        bg_color = colors.dark.black,
        fg_color = colors.normal.white,
      },

      inactive_tab_hover = {
        bg_color = colors.dark.black,
        fg_color = colors.bright.white,
      },

      new_tab = {
        bg_color = colors.dark.black,
        fg_color = colors.normal.white,
      },

      new_tab_hover = {
        bg_color = colors.dark.black,
        fg_color = colors.bright.white,
      },
    },
  },
}
