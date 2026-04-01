local wezterm = require("wezterm")

local function setup(config)
  local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
  local bg = scheme.background
  local fg = scheme.foreground
  local blue = scheme.ansi[5]
  local dark1 = tostring(wezterm.color.parse(bg):darken(0.04))
  local dark2 = tostring(wezterm.color.parse(bg):darken(0.08))

  config.window_decorations = "TITLE | RESIZE"
  config.show_new_tab_button_in_tab_bar = false
  config.window_frame = {
    font_size = config.font_size,
    active_titlebar_bg = bg,
    inactive_titlebar_bg = bg,
  }
  config.colors = config.colors or {}
  config.colors.tab_bar = {
    background = bg,
    active_tab = { bg_color = bg, fg_color = blue },
    inactive_tab = { bg_color = dark1, fg_color = fg },
    inactive_tab_hover = { bg_color = dark2, fg_color = fg },
    new_tab = { bg_color = bg, fg_color = fg },
    new_tab_hover = { bg_color = dark2, fg_color = fg },
  }
end

return { setup = setup }
