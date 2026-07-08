"=============================================================================
" tab.vim --- tab key binding (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#tab#i_tab() abort
  return luaeval("require('spacevim.mapping.tab').i_tab()")
endfunction

function! SpaceVim#mapping#tab#expandable() abort
  return luaeval("require('spacevim.mapping.tab').expandable()")
endfunction

" vim:set et sw=2 cc=80:

