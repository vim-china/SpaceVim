--=============================================================================
-- health.lua --- SpaceVim health checker
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')

function M.report()
  local report = {}

  -- check individual health items
  local items = vim.fn.globpath(vim.o.runtimepath, 'autoload/SpaceVim/health/*', 0, 1)
  for _, item in ipairs(items) do
    local name = vim.fn.fnamemodify(item, ':t:r')
    local ok, result = pcall(vim.call, 'SpaceVim#health#' .. name .. '#check')
    if ok and type(result) == 'table' then
      for _, line in ipairs(result) do
        table.insert(report, line)
      end
    else
      table.insert(report, '')
      table.insert(report, 'SpaceVim Health Error:')
      table.insert(report, '    There is no function: SpaceVim#health#' .. name .. '#check()')
      table.insert(report, '')
    end
  end

  -- check layer health
  table.insert(report, 'Checking SpaceVim layer health:')
  local layer = require('spacevim.layer')
  for _, l in ipairs(layer.get()) do
    local ok, result = pcall(function()
      -- try Lua layer first
      local ok2, lmod = pcall(require, 'spacevim.layer.' .. l)
      if ok2 and lmod.health then
        return lmod.health()
      end
      -- fallback to Vim script
      return vim.call('SpaceVim#layers#' .. l .. '#health')
    end)
    if ok and result then
      table.insert(report, '  - `' .. l .. '`: ok')
    else
      table.insert(report, '  - `' .. l .. '`: can not find function: SpaceVim#layers#' .. l .. '#health()')
    end
  end

  return table.concat(report, '\n')
end

return M

