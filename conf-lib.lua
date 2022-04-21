--- Wezterm configuration library
--- from https://github.com/bew/dotfiles/blob/main/gui/wezterm/lib/mystdlib.lua

local conf_table = {} -- "configure table" stdlib

--- Merge all the given tables into a single one and return it.
function conf_table.merge_all(...)
  local ret = {}
  for _, tbl in ipairs({...}) do
    for k, v in pairs(tbl) do
      ret[k] = v
    end
  end
  return ret
end

--- Deep clone the given table.
function conf_table.deepclone(original)
  local clone = {}
  for k, v in pairs(original) do
    if type(v) == "table" then
      clone[k] = conf_table.deepclone(v)
    else
      clone[k] = v
    end
  end
  return clone
end

local is_list = function(t)
  if type(t) ~= "table" then
    return false
  end
  -- a list has list indices, an object does not
  return ipairs(t)(t, 0) and true or false
end

--- Flatten the given list of (item or (list of (item or ...))) to a list of item.
--- (nested lists are supported)
function conf_table.flatten_list(list)
  local flattened_list = {}
  for _, item in ipairs(list) do
    if is_list(item) then
      for _, sub_item in ipairs(conf_table.flatten_list(item)) do
        table.insert(flattened_list, sub_item)
      end
    else
      table.insert(flattened_list, item)
    end
  end
  return flattened_list
end

return {
  conf_table = conf_table,
}
