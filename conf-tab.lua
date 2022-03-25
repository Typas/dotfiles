--- modded from https://github.com/wez/wezterm/issues/647
local wezterm = require "wezterm"

-- The powerline symbol
local LEFT_ARROW = utf8.char(0xe0b3)
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local RIGHT_ARROW = utf8.char(0xe0b1)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local color_tab_bar_background = "#bbbbbb"

local color_tab_inactive = {
  background = "#bbbbbb",
  foreground = "#3f3f3f",
  intensity = "Normal",
}

local color_tab_hover = {
  background = "#a8a8a8",
  foreground = "#272727",
  intensity = "Normal",
}

local color_tab_active = {
  background = "#cfcfcf",
  foreground = "#262626",
  intensity = "Bold",
}

local color_tab_new = {
  background = "#bbbbbb",
  foreground = "#555555",
  intensity = "Normal",
}

local color_tab_new_hover = {
  background = "#a8a8a8",
  foreground = "#444444",
  intensity = "Normal",
}

wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    local is_tab_hover = hover
    local is_tab_active = tab.is_active

    if is_tab_active then
      color_tab = color_tab_active
    elseif is_tab_hover then
      color_tab = color_tab_hover
    else
      color_tab = color_tab_inactive
    end

    local title = tab.active_pane.title
    local available_chars = max_width - 3
    local title_chars = string.len(title)
    if title_chars > available_chars then
      title = ".." .. string.sub(title, title_chars - available_chars + 3)
    end
    -- title = wezterm.truncate_left(title, available_chars)

    return {
      {Background={Color=color_tab.background}},
      {Foreground={Color=color_tab.foreground}},
      {Text=" "},
      {Attribute={Intensity=color_tab.intensity}},
      {Text=title},
      {Attribute={Intensity="Normal"}},
      {Text=" "},
      {Background={Color=color_tab_bar_background}},
      {Foreground={Color=color_tab.background}},
      {Text=SOLID_RIGHT_ARROW},
    }
  end
)

return {
  hide_tab_bar_if_only_one_tab = true,

  use_fancy_tab_bar = false,

  tab_bar_style = {
    active_tab_left = "",
    active_tab_right = "",
    inactive_tab_left = "",
    inactive_tab_right = "",
    inactive_tab_hover_left = "",
    inactive_tab_hover_right = "",
  },
  colors = {
    tab_bar = {
      background = color_tab_bar_background,
      new_tab = {
        bg_color = color_tab_new.background,
        fg_color = color_tab_new.foreground,
      },
      new_tab_hover = {
        bg_color = color_tab_new_hover.background,
        fg_color = color_tab_new_hover.foreground,
      },
    },
  }
}
