"=============================================================================
" vim#compatible.vim --- SpaceVim compatible API (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#api#vim#compatible#get() abort
  return luaeval("require('spacevim.api.vim.compatible')")
endfunction

" vim:set et sw=2:

