local wezterm = require 'wezterm';

return {
  color_scheme = "OneHalfLight",
  font_size = 12.0,
  font = wezterm.font_with_fallback({
      {
        family="Fira Code",
        stretch="SemiCondensed", -- hope one day this will happen
        harfbuzz_features={"ss05", "ss03", "ss02", "ss08", "ss06", "cv02", "cv10", "cv16"}
      },
      "Noto Sans Mono CJK TC",
      "Noto Sans",
      "Noto Color Emoji"
  }),
}
