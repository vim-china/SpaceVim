"=============================================================================
" iconv.vim --- SpaceVim iconv API (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#api#iconv#import() abort
  return luaeval("require('spacevim.api.iconv')")
endfunction

function! SpaceVim#api#iconv#get() abort
  return luaeval("require('spacevim.api.iconv')")
endfunction

" vim:set et sw=2:

