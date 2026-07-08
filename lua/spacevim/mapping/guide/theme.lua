--=============================================================================
-- theme.lua --- theme API for SpaceVim guide (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local fn = vim.fn
local cmd = vim.cmd

--- Apply highlight groups from a theme palette
--- @param t table palette table with 3 rows, each containing { guifg, guibg, ctermbg, ctermfg }
local function hi(t)
  cmd('hi! LeaderGuiderPrompt ctermbg=' .. t[1][3] .. ' ctermfg=' .. t[1][4] .. ' cterm=bold gui=bold guifg=' .. t[1][1] .. ' guibg=' .. t[1][2])
  cmd('hi! LeaderGuiderSep1 ctermbg=' .. t[2][3] .. ' ctermfg=' .. t[1][3] .. ' cterm=bold gui=bold guifg=' .. t[1][2] .. ' guibg=' .. t[2][2])
  cmd('hi! LeaderGuiderName ctermbg=' .. t[2][3] .. ' ctermfg=' .. t[2][4] .. ' cterm=bold gui=bold guifg=' .. t[2][1] .. ' guibg=' .. t[2][2])
  cmd('hi! LeaderGuiderSep2 ctermbg=' .. t[3][3] .. ' ctermfg=' .. t[2][3] .. ' cterm=bold gui=bold guifg=' .. t[2][2] .. ' guibg=' .. t[3][2])
  cmd('hi! LeaderGuiderFill ctermbg=' .. t[3][3] .. ' ctermfg=' .. t[3][4] .. ' guifg=' .. t[3][1] .. ' guibg=' .. t[3][2])
end

--- Apply the current colorscheme's guide theme
function M.hi()
  local name = vim.g.colors_name or 'gruvbox'
  local ok, t = pcall(function()
    return fn['SpaceVim#mapping#guide#theme#' .. name .. '#palette']()
  end)
  if not ok then
    t = fn['SpaceVim#mapping#guide#theme#gruvbox#palette']()
  end
  hi(t)
end

return M

