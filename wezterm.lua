local wezterm = require 'wezterm';

return {
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

  -- fonts --
  font_size = 12.0,
  font = wezterm.font_with_fallback({
      {
        family="Fira Code",
        stretch="SemiCondensed", -- hope one day this will happen
        harfbuzz_features={"ss05", "ss03", "ss02", "ss08", "ss06", "cv02", "cv10", "cv16"}
      },
      "Noto Sans Mono CJK TC",
      "Noto Sans Mono",
  }),
  font_rules = {
    {
      italic = true,
      font = wezterm.font_with_fallback({
          {
            family="SF Mono",
            style="Italic",
          },
      }),
    },
  },
}
