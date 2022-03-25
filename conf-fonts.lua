--- Moddified from https://github.com/bew/dotfiles/blob/main/gui/wezterm/
local wezterm = require "wezterm"

local conf = {}

-- Disable annoying default behaviors
conf.adjust_window_size_when_changing_font_size = false

conf.font_size = 13.0

local function fira_code(weight)
  local font = {}

  font.family = "Fira Code" -- no longer use retina weight
  font.weight = weight or "Regular"
  font.stretch = "SemiCondensed" -- hope one day this will happen
  font.harfbuzz_features = {"ss02", "ss03","ss05", "ss08", "cv10"}

  return font
end

local function noto_cjk(weight)
  return {
    family = "Noto Serif CJK TC",
    weight = weight or "Medium",
    style = "Normal",
  }
end

local function julia_mono(weight, style)
  local font = {}

  font.family = "JuliaMono"
  font.weight = weight or "Regular"
  font.stretch = "SemiCondensed" -- hope one day this will happen
  font.style = style or "Normal"
  font.harfbuzz_features = {"zero", "ss01", "ss03", "ss06", "ss08"}

  return font
end

conf.font = wezterm.font_with_fallback({
    fira_code(),
    noto_cjk(),
    julia_mono(),
})

conf.font_rules = {
  {
    italic = true,
    intensity = "Bold",
    font = wezterm.font_with_fallback({
        julia_mono("DemiBold", "Italic"),
        noto_cjk("Bold"),
    }),
  },
  {
    italic = true,
    intensity = "Half",
    font = wezterm.font_with_fallback({
        julia_mono("Light", "Italic"),
        noto_cjk("Light"),
    }),
  },
  {
    italic = true,
    font = wezterm.font_with_fallback({
        julia_mono("Regular", "Italic"),
        noto_cjk(),
    }),
  },
  {
    intensity = "Bold",
    font = wezterm.font_with_fallback({
        fira_code("DemiBold"),
        noto_cjk("Bold"),
        julia_mono("DemiBold"),
    }),
  },
  {
    intensity = "Half",
    font = wezterm.font_with_fallback({
        fira_code("Light"),
        noto_cjk("Light"),
        julia_mono("Light"),
    }),
  },
}

return conf
