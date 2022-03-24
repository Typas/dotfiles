--- modded from https://github.com/bew/dotfiles/blob/main/gui/wezterm/lib/mystdlib.lua
local wezterm = require 'wezterm';

local conf_misc = {
  color_scheme = "OneHalfLight",

  -- tab bar appearance --
  -- based on macos terminal --
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  colors = {
    tab_bar = {
      background = "#bbbbbb",

      active_tab = {
        bg_color = "#cfcfcf",
        fg_color = "#262626",
      },

      inactive_tab = {
        bg_color = "#bbbbbb",
        fg_color = "#3f3f3f",
      },

      inactive_tab_hover = {
        bg_color = "#a8a8a8",
        fg_color = "#272727",
      },

      new_tab = {
        bg_color = "#bbbbbb",
        fg_color = "#555555",
      },

      new_tab_hover = {
        bg_color = "#a8a8a8",
        fg_color = "#444444",
      }
    }
  },

  -- Never hold on close
  exit_behavior = "Close",
}

local conf_table = require "conf-lib".conf_table
local full_config = conf_table.merge_all(
  conf_misc,
  require("conf-fonts"),
  {} -- so the last table can have an ending comma for git diffs
)

return full_config
