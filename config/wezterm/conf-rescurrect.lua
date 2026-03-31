--- https://github.com/MLFlexer/resurrect.wezterm
local wezterm = require("wezterm")

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local restore_opts = {
  relative = true,
  restore_text = true,
  on_pane_restore = resurrect.tab_state.default_on_pane_restore,
}

-- Auto-save workspaces every 15 minutes
resurrect.state_manager.periodic_save({
  interval_seconds = 900,
  save_workspaces = true,
  save_windows = false,
  save_tabs = false,
})

-- Auto-restore on startup
wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

wezterm.on("resurrect.error", function(msg)
  wezterm.log_error("resurrect: " .. msg)
end)

return {
  keys = {
    -- Save workspace
    {
      key = "s",
      mods = "ALT|SHIFT",
      action = wezterm.action_callback(function(win, pane)
        resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
      end),
    },
    -- Load workspace via fuzzy finder
    {
      key = "l",
      mods = "ALT|SHIFT",
      action = wezterm.action_callback(function(win, pane)
        resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
          local state = resurrect.state_manager.load_state(id, "workspace")
          resurrect.workspace_state.restore_workspace(state, restore_opts)
        end, {
          title = "Load Workspace",
          is_fuzzy = true,
          show_state_with_type = "workspace",
        })
      end),
    },
  },
}
