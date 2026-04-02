local wezterm = require("wezterm")

local shells = { bash = true, zsh = true, fish = true, sh = true, dash = true, nu = true }

local function basename(path)
  return path:match("([^/\\]+)$") or path
end

local function tab_title(tab)
  -- 1. Honour manually-set tab titles
  local explicit = tab.tab_title
  if explicit and #explicit > 0 then
    return explicit
  end

  local pane = tab.active_pane

  -- 2. Determine foreground process
  local proc = pane.foreground_process_name or ""
  local proc_name = basename(proc)

  -- 3. After claude-code (or similar) exits the title/process can be empty
  if proc_name == "" then
    proc_name = "bash" -- default_prog
  end

  -- 4. Shell → show working directory without user@host
  if shells[proc_name] then
    local cwd_url = pane.current_working_dir
    if cwd_url then
      local cwd = type(cwd_url) == "string" and cwd_url or cwd_url.file_path
      if cwd then
        local home = os.getenv("HOME") or ""
        if home ~= "" and cwd:sub(1, #home) == home then
          cwd = "~" .. cwd:sub(#home + 1)
        end
        -- strip trailing slash except for root
        if #cwd > 1 and cwd:sub(-1) == "/" then
          cwd = cwd:sub(1, -2)
        end
        return cwd
      end
    end
    return proc_name
  end

  -- 5. Non-shell program → show its name
  return proc_name
end

wezterm.on("format-tab-title", function(tab)
  return tab_title(tab)
end)

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
