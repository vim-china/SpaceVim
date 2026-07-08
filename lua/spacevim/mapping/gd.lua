--=============================================================================
-- gd.lua --- gd key binding (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local gd = {}

--- Register a filetype-specific goto-definition function
--- @param ft string filetype
--- @param func string|function function name or callable
function M.add(ft, func)
  gd[ft] = func
end

--- Get the goto-definition function for current filetype
--- @return string|function
function M.get()
  return gd[vim.bo.filetype] or ''
end

return M

