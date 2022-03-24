--- Moddified from https://github.com/bew/dotfiles/blob/main/gui/wezterm/lib/mystdlib.lua
local wezterm = require "wezterm"

local conf = {}

-- Disable annoying default behaviors
conf.adject_window_size_when_changing_font_size = false

conf.font_size = 14.0

local function fira_code(weight)
  local font = {}
  weight = weight or "Retina"

  if weight == "Retina" then
    font.family = "Fira Code Retina"
  else
    font.family = "Fira Code"
    font.weight = weight
  end
  font.stretch = "SemiCondensed" -- hope one day this will happen
  font.harfbuzz_features = {"ss01", "ss02", "ss03", "ss05", "ss06", "ss08", "cv02", "cv10", "cv16"}

  return font
end

local function noto_tc(weight)
  weight = weight or "Medium"

  return {
    family = "Noto Serif CJK TC",
    weight = weight,
    style = "Normal",
  }
end

local function julia_mono(weight, style)
  local font = {}

  font.family = "JuliaMono"
  font.weight = weight or "Regular"
  font.style = style or "Normal"
  font.harfbuzz_features = {"zero", "ss01", "ss06", "ss08"}

  return font
end

conf.font = wezterm.font_with_fallback({
    fira_code(),
    noto_tc(),
    julia_mono(),
})

conf.font_rules = {
  {
    italic = true,
    intensity = "Bold",
    font = wezterm.font_with_fallback({
        julia_mono("DemiBold", "Italic"),
        noto_tc("Bold"),
    }),
  },
  {
    italic = true,
    intensity = "Half",
    font = wezterm.font_with_fallback({
        julia_mono("Light", "Italic"),
        noto_tc("Regular"),
    }),
  },
  {
    italic = true,
    font = wezterm.font_with_fallback({
        julia_mono("Regular", "Italic"),
        noto_tc(),
    }),
  },
  {
    intensity = "Bold",
    font = wezterm.font_with_fallback({
        fira_code("DemiBold"),
        noto_tc("Bold"),
        julia_mono("DemiBold"),
    }),
  },
  {
    intensity = "Half",
    font = wezterm.font_with_fallback({
        fira_code("Light"),
        noto_tc("Regular"),
        julia_mono("Light"),
    }),
  },
}

return conf
