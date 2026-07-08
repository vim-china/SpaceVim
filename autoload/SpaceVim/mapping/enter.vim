"=============================================================================
" enter.vim --- Enter key bindings (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#enter#i_enter() abort
  return luaeval("require('spacevim.mapping.enter').i_enter()")
endfunction
" vim:set et sw=2 cc=80:

