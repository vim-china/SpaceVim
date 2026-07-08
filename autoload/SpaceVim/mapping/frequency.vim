"=============================================================================
" frequency.vim --- key frequency plugin (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#frequency#update(key, rhs) abort
  return luaeval("require('spacevim.mapping.frequency').update(_A[1], _A[2])", [a:key, a:rhs])
endfunction

function! SpaceVim#mapping#frequency#view(keys) abort
  call luaeval("require('spacevim.mapping.frequency').view(_A)", a:keys)
endfunction

function! SpaceVim#mapping#frequency#viewall() abort
  call luaeval("require('spacevim.mapping.frequency').viewall()")
endfunction

