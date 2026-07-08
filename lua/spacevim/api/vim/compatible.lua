--=============================================================================
-- compatible.lua --- compatible api between neovim/vim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

function M.eval(l)
  return vim.api.nvim_eval(l)
end

function M.islist(val)
  if vim.islist then
    return vim.islist(val)
  elseif vim.tbl_islist then
    return vim.tbl_islist(val)
  else
    if type(val) ~= 'table' then
      return false
    else
      for k, _ in pairs(val) do
        if type(k) ~= 'number' then
          return false
        end
      end
      return true
    end
  end
end

function M.cmd(command)
  return vim.api.nvim_command(command)
end

function M.call(funcname, ...)
  return vim.call(funcname, ...)
end

function M.echo(msg)
  vim.api.nvim_echo({ { msg } }, false, {})
end

local has_cache = {}

function M.has(feature)
  if has_cache[feature] ~= nil then
    return has_cache[feature]
  else
    has_cache[feature] = vim.fn.has(feature)
    return has_cache[feature]
  end
end

function M.globpath(dir, expr)
  return vim.fn.globpath(dir, expr, 1, 1)
end

function M.execute(cmd, silent)
  return vim.fn.execute(cmd, silent)
end

function M.win_screenpos(nr)
  return vim.fn.win_screenpos(nr)
end

return M

