--=============================================================================
-- vim.lua --- SpaceVim vim layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return {
    { 'Shougo/vimshell.vim', { on_cmd = { 'VimShell' } } },
    { 'mattn/vim-terminal', { on_cmd = { 'Terminal' } } },
  }
end

function M.config()
  vim.api.nvim_create_augroup('spacevim_vim_layer', { clear = true })
end

function M.health()
  M.plugins()
  M.config()
  return true
end

function M.loadable()
  return true
end

return M

