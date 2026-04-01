--- https://github.com/MLFlexer/resurrect.wezterm
local wezterm = require("wezterm")

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local restore_opts = {
  relative = false,
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

local function setup(config)
  table.insert(config.keys, {
    key = "s",
    mods = "ALT|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      local workspace = win:active_workspace()
      resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
      resurrect.state_manager.write_current_state(workspace, "workspace")
    end),
  })
  table.insert(config.keys, {
    key = "l",
    mods = "ALT|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
        local type = string.match(id, "^([^/]+)")
        id = string.match(id, "([^/]+)$")
        id = string.match(id, "(.+)%..+$")
        local state = resurrect.state_manager.load_state(id, type)
        if type == "workspace" then
          local opts = {
            relative = false,
            restore_text = true,
            window = win:mux_window(),
            close_open_tabs = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          }
          resurrect.workspace_state.restore_workspace(state, opts)
        elseif type == "window" then
          resurrect.window_state.restore_window(pane:window(), state, restore_opts)
        elseif type == "tab" then
          resurrect.tab_state.restore_tab(pane:tab(), state, restore_opts)
        end
      end)
    end),
  })
end

return { setup = setup }
