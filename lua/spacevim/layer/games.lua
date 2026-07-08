--=============================================================================
-- games.lua --- SpaceVim games layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return {
    { 'wsdjeg/vim2048', { merged = false } },
  }
end

function M.config()
  vim.g._spacevim_mappings_space.g = { name = '+Games' }
  vim.call('SpaceVim#mapping#space#def', 'nnoremap', { 'g', '2' }, 'call vim2048#start()', '2048-in-vim', 1)
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

