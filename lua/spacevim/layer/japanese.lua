--=============================================================================
-- japanese.lua --- SpaceVim japanese layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return {
    { 'vim-jp/vimdoc-ja', { merged = false } },
  }
end

function M.config()
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

