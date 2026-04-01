--- https://github.com/michaelbrusegard/tabline.wez
local wezterm = require("wezterm")

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local function scheme_overrides(scheme)
  local bg = scheme.background
  local fg = scheme.foreground
  local ansi = scheme.ansi
  -- ansi: 1=black 2=red 3=green 4=yellow 5=blue 6=magenta 7=cyan 8=white
  local blue = ansi[5]
  local green = ansi[3]
  local yellow = ansi[4]

  local l = wezterm.color.parse(bg):laba()
  local is_light = l > 50
  local accent_fg = is_light and "#ffffff" or "#000000"
  local mid_bg = tostring(is_light
    and wezterm.color.parse(bg):darken(0.12)
    or wezterm.color.parse(bg):lighten(0.12))
  local subtle_bg = tostring(is_light
    and wezterm.color.parse(bg):darken(0.04)
    or wezterm.color.parse(bg):lighten(0.04))

  return {
    normal_mode = {
      a = { fg = accent_fg, bg = blue },
      b = { fg = fg, bg = mid_bg },
      c = { fg = fg, bg = subtle_bg },
    },
    copy_mode = {
      a = { fg = accent_fg, bg = yellow },
      b = { fg = fg, bg = mid_bg },
      c = { fg = fg, bg = subtle_bg },
    },
    search_mode = {
      a = { fg = accent_fg, bg = green },
      b = { fg = fg, bg = mid_bg },
      c = { fg = fg, bg = subtle_bg },
    },
    tab = {
      active = { fg = blue, bg = bg },
      inactive = { fg = fg, bg = mid_bg },
      inactive_hover = { fg = accent_fg, bg = fg },
    },
  }
end

local function setup(config)
  local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
  tabline.setup({
    options = {
      icons_enabled = true,
      theme = config.color_scheme,
      theme_overrides = scheme_overrides(scheme),
      section_separators = {
        left = wezterm.nerdfonts.pl_left_hard_divider,
        right = wezterm.nerdfonts.pl_right_hard_divider,
      },
      component_separators = {
        left = wezterm.nerdfonts.pl_left_soft_divider,
        right = wezterm.nerdfonts.pl_right_soft_divider,
      },
      tab_separators = {
        left = wezterm.nerdfonts.pl_left_hard_divider,
        right = wezterm.nerdfonts.pl_right_hard_divider,
      },
    },
    sections = {
      tabline_a = { "mode" },
      tabline_b = { "workspace" },
      tabline_c = { " " },
      tab_active = {
        "index",
        { "parent", padding = 0 },
        "/",
        { "cwd", padding = { left = 0, right = 1 } },
        { "zoomed", padding = 0 },
      },
      tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
      tabline_x = {},
      tabline_y = { "datetime" },
      tabline_z = { "domain" },
    },
    extensions = { "resurrect" },
  })
  tabline.apply_to_config(config)
end

return { setup = setup }
