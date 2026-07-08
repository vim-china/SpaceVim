--=============================================================================
-- frequency.lua --- key frequency plugin (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local data = {}

--- Update key frequency and return rhs (for use in mappings)
--- @param key string the key sequence
--- @param rhs string the right-hand side to return
--- @return string rhs
function M.update(key, rhs)
  if data[key] then
    data[key] = data[key] + 1
  else
    data[key] = 1
  end
  return rhs
end

--- View frequency of a key or list of keys
--- @param keys string|string[]
function M.view(keys)
  if type(keys) == 'string' then
    print('The frequency of ' .. keys .. ' is ' .. M.get(keys))
  elseif type(keys) == 'table' then
    for _, key in ipairs(keys) do
      M.view(key)
    end
  end
end

--- View all key frequencies
function M.viewall()
  print(vim.inspect(data))
end

--- Get frequency count for a key
--- @param key string
--- @return number
function M.get(key)
  return data[key] or 0
end

return M

