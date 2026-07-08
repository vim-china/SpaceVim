"=============================================================================
" theme.vim --- theme API for SpaceVim guide (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#guide#theme#hi() abort
  call luaeval("require('spacevim.mapping.guide.theme').hi()")
endfunction

