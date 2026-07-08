--=============================================================================
-- sudo.lua --- SpaceVim sudo layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return {
    { 'lambdalisue/suda.vim' },
  }
end

function M.config()
  vim.call('SpaceVim#mapping#space#def', 'nnoremap', { 'f', 'W' }, 'SudaWrite', 'save buffer with sudo', 1)
  vim.api.nvim_create_user_command('W', 'SudaWrite', {})
  vim.cmd('cnoremap w!! W')
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

