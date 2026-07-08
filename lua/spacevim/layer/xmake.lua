--=============================================================================
-- xmake.lua --- SpaceVim xmake layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return {
    { vim.g._spacevim_root_dir .. 'bundle/xmake.vim', { merged = false } },
  }
end

function M.config()
  table.insert(vim.g.spacevim_project_rooter_patterns, 'xmake.lua')
  vim.g._spacevim_mappings_space.m = vim.g._spacevim_mappings_space.m or {}
  vim.g._spacevim_mappings_space.m.x = { name = '+xmake' }
  vim.call('SpaceVim#mapping#space#def', 'nnoremap', { 'm', 'x', 'b' }, 'call xmake#buildrun()', 'xmake-build-without-running', 1)
  vim.call('SpaceVim#mapping#space#def', 'nnoremap', { 'm', 'x', 'r' }, 'call xmake#buildrun(1)', 'xmake-build-and-running', 1)
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

