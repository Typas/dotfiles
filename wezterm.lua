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
  font_size = 14.0,
  font = wezterm.font_with_fallback({
      {
        family="Fira Code Retina",
        stretch="SemiCondensed", -- hope one day this will happen
        harfbuzz_features={"ss05", "ss03", "ss02", "ss08", "ss06", "cv02", "cv10", "cv16"}
      },
      "Noto Sans Mono CJK TC",
      {
        family="Noto Sans Mono",
        stretch="SemiCondensed",
      },
  }),
  font_rules = {
    {
      italic = true,
      intensity = "Bold",
      font = wezterm.font_with_fallback({
          {
            family="SF Mono",
            weight="DemiBold",
            style="Italic",
          },
      }),
    },
    {
      italic = true,
      intensity = "Normal",
      font = wezterm.font_with_fallback({
          {
            family="SF Mono",
            weight="Regular",
            style="Italic",
          },
      }),
    },
    {
      italic = true,
      intensity = "Half",
      font = wezterm.font_with_fallback({
          {
            family="SF Mono",
            weight="Light",
            style="Italic",
          }
      }),
    },
    {
      italic = true,
      font = wezterm.font_with_fallback({
          {
            family="SF Mono",
            weight="Regular",
            style="Italic",
          },
      }),
    },
    {
      intensity = "Bold",
      font = wezterm.font_with_fallback({
          {
            family="Fira Code",
            weight="DemiBold",
          },
          {
            family="Noto Sans Mono CJK TC",
            weight="DemiBold",
          },
          {
            family="Noto Sans Mono",
            weight="DemiBold",
            stretch="SemiCondensed",
          },
      }),
    },
    {
      intensity = "Normal",
      font = wezterm.font_with_fallback({
          {
            family="Fira Code Retina",
          },
          "Noto Sans Mono CJK TC",
          {
            family="Noto Sans Mono",
            stretch="SemiCondensed",
          },
      }),
    },
    {
      intensity = "Half",
      font = wezterm.font_with_fallback({
          {
            family="FiraCode",
            weight="Light",
          },
          {
            family="Noto Sans Mono CJK TC",
            weight="Light",
          },
          {
            family="Noto Sans Mono",
            weight="Light",
            stretch="SemiCondensed",
          },
      }),
    },
  },
}
