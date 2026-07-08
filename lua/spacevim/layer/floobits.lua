--=============================================================================
-- floobits.lua --- SpaceVim floobits layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return {
    { 'floobits/floobits-neovim', {
      on_cmd = {
        'FlooJoinWorkspace',
        'FlooShareDirPublic',
        'FlooShareDirPrivate',
      },
    } },
  }
end

function M.config()
  vim.g._spacevim_mappings_space.m = vim.g._spacevim_mappings_space.m or {}
  vim.g._spacevim_mappings_space.m.f = { name = '+floobits' }
  vim.call('SpaceVim#mapping#space#def', 'nnoremap', { 'm', 'f', 'j' }, 'FlooJoinWorkspace', 'Join workspace', 1)
  vim.call('SpaceVim#mapping#space#def', 'nnoremap', { 'm', 'f', 't' }, 'FlooToggleFollowMode', 'Toggle follow mode', 1)
  vim.call('SpaceVim#mapping#space#def', 'nnoremap', { 'm', 'f', 's' }, 'FlooSummon', 'Summon everyone', 1)
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

