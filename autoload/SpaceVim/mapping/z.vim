"=============================================================================
" z.vim --- z key bindings (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#z#init() abort
  call luaeval("require('spacevim.mapping.z').init()")
endfunction
" vim:set et sw=2 cc=80:

