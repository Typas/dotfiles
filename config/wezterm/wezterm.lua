--- modded from https://github.com/bew/dotfiles/blob/main/gui/wezterm/
local wezterm = require "wezterm"

local conf_misc = {
  color_scheme = "OneHalfLight",
  automatically_reload_config = false,
  custome_block_glyphs = false,
  window_padding = {
    left = 2, right = 2,
    top = 2, bottom = 2,
  },

  -- Never hold on close
  exit_behavior = "Close",
}

local conf_table = require "conf-lib".conf_table
local full_config = conf_table.merge_all(
  conf_misc,
  require("conf-fonts"),
  require("conf-tab"),
  {} -- so the last table can have an ending comma for git diffs
)

return full_config
