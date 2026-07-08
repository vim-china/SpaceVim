"=============================================================================
" health.vim --- SpaceVim health checker (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#health#report() abort
  return luaeval('require("spacevim.health").report()')
endfunction

