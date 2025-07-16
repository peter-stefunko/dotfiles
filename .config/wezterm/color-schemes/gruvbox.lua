-- ~/.config/wezterm/color-schemes/gruvbox.lua

local colors = require 'colors.gruvbox'

return {
  Gruvbox = {
    foreground = colors.bright.white,
    background = colors.normal.black,

    cursor_bg = colors.bright.white,
    cursor_fg = colors.normal.black,
    cursor_border = colors.bright.white,

    selection_fg = colors.normal.black,
    selection_bg = colors.bright.white,

    scrollbar_thumb = '#222222',
    split = '#444444',

    ansi = {
      colors.dark.black,
      colors.normal.red,
      colors.normal.green,
      colors.normal.yellow,
      colors.normal.blue,
      colors.normal.purple,
      colors.normal.cyan,
      colors.normal.white,
    },
    brights = {
      colors.bright.black,
      colors.bright.red,
      colors.bright.green,
      colors.bright.yellow,
      colors.bright.blue,
      colors.bright.purple,
      colors.bright.cyan,
      colors.bright.white,
    },
  }
}
