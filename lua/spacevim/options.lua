--=============================================================================
-- options.lua --- SpaceVim options module
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.list()
  local list = {}
  local vars = vim.fn.getcompletion('g:spacevim_', 'var')
  for _, var in ipairs(vars) do
    local key = var:sub(11) -- remove 'spacevim_' prefix
    local val = vim.g[var:sub(3)] or '' -- remove 'g:' prefix
    table.insert(list, '  ' .. key .. ' = ' .. vim.fn.string(val))
  end
  return list
end

function M.set(argv, ...)
  local varname = 'spacevim_' .. argv
  if vim.g[varname] ~= nil then
    local argvs = { ... }
    if #argvs > 0 then
      vim.g[varname] = argvs[1]
    else
      return vim.fn.string(vim.g[varname])
    end
  end
end

return M

