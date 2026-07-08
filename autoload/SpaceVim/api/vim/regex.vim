"=============================================================================
" vim#regex.vim --- SpaceVim regex API (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#api#vim#regex#get() abort
  return luaeval("require('spacevim.api.vim.regex')")
endfunction

" vim:set et sw=2:

