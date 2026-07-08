"=============================================================================
" unicode#spinners.vim --- SpaceVim spinners API (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#api#unicode#spinners#get() abort
  return luaeval("require('spacevim.api.unicode.spinners')")
endfunction

" vim:set et sw=2:

