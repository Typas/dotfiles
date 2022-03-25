--- modded from https://github.com/bew/dotfiles/blob/main/gui/wezterm/
local wezterm = require 'wezterm'

local conf_misc = {
  color_scheme = "OneHalfLight",
  automatcially_reload_config = true,
  window_padding = {
    left = 2, right = 2,
    top = 2, bottom = 2,
  },

  -- Never hold on close
  exit_behavior = "Close",

  -- tab bar appearance --
  hide_tab_bar_if_only_one_tab = true,
  window_frame = {
    font = wezterm.font_with_fallback({
        {
          family = "Noto Serif CJK TC",
          weight = "DemiBold",
        },
    }),

    font_size = 12.0,

    -- active_titlebar_bg = "#cfcfcf",
    -- inactive_titlebar_bg = "#cfcfcf",
    -- active_titlebar_fg = "#333333",
    -- inactive_titlebar_fg = "#333333",
    -- button_bg = "#cfcfcf",
    -- button_fg = "#333333",
    -- button_hover_bg = "#a8a8a8",
    -- button_hover_fg = "#272727",
  },
  -- use_fancy_tab_bar = false,
  -- colors = {
  --   tab_bar = {
  --     background = "#bbbbbb",

  --     active_tab = {
  --       bg_color = "#cfcfcf",
  --       fg_color = "#262626",
  --     },

  --     inactive_tab = {
  --       bg_color = "#bbbbbb",
  --       fg_color = "#3f3f3f",
  --     },

  --     inactive_tab_hover = {
  --       bg_color = "#a8a8a8",
  --       fg_color = "#272727",
  --     },

  --     new_tab = {
  --       bg_color = "#bbbbbb",
  --       fg_color = "#555555",
  --     },

  --     new_tab_hover = {
  --       bg_color = "#a8a8a8",
  --       fg_color = "#444444",
  --     }
  --   }
  -- },
}

local conf_table = require "conf-lib".conf_table
local full_config = conf_table.merge_all(
  conf_misc,
  require("conf-fonts"),
  {} -- so the last table can have an ending comma for git diffs
)

return full_config
