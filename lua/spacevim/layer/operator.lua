--=============================================================================
-- operator.lua --- SpaceVim operator layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return {
    { 'kana/vim-operator-user', { merged = false } },
    { 'haya14busa/vim-operator-flashy', { merged = false } },
  }
end

function M.config()
  vim.cmd('map y <Plug>(operator-flashy)')
  vim.cmd('nmap Y <Plug>(operator-flashy)$')
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

