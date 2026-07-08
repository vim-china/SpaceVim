--=============================================================================
-- g_capital_d.lua --- gD key binding (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: sisynb < bsixxxx at gmail.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local g_capital_d = {}

--- Register a filetype-specific goto-declaration function
--- @param ft string filetype
--- @param func string|function function name or callable
function M.add(ft, func)
  g_capital_d[ft] = func
end

--- Get the goto-declaration function for current filetype
--- @return string|function
function M.get()
  return g_capital_d[vim.bo.filetype] or ''
end

return M

