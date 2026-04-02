--- modded from https://github.com/bew/dotfiles/blob/main/gui/wezterm/
local wezterm = require "wezterm"

local conf_misc = {
  color_scheme = "Tomorrow",
  automatically_reload_config = false,
  custom_block_glyphs = false,
  window_padding = {
    left = 2, right = 2,
    top = 2, bottom = 2,
  },
  keys = {
    {key="F11", action=wezterm.action.ToggleFullScreen},
    {key="Enter", mods="ALT", action=wezterm.action.DisableDefaultAssignment},
    {key="T", mods="ALT|SHIFT", action=wezterm.action.PromptInputLine {
      description = "Set tab title (empty to reset)",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }},
  },

  -- Update, 2 week check
  check_for_updates_interval_seconds = 1209600,

  -- Never hold on close
  exit_behavior = "Close",

  -- GNOME Wayland CSD title bar is broken; fall back to XWayland for SSD
  enable_wayland = not (os.getenv("XDG_CURRENT_DESKTOP") or ""):find("GNOME"),

  -- Don't start as login shell to avoid /etc/profile.d/ scripts (e.g. gpm.sh tty error)
  default_prog = { "bash" },

}

local conf_table = require "conf-lib".conf_table
local full_config = conf_table.merge_all(
  conf_misc,
  require("conf-fonts"),
  {} -- so the last table can have an ending comma for git diffs
)

require("conf-tab").setup(full_config)
require("conf-rescurrect").setup(full_config)

return full_config
