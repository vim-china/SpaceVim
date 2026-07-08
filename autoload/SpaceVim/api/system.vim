"=============================================================================
" system.vim --- SpaceVim system API (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#api#system#get() abort
  return luaeval("require('spacevim.api.system')")
endfunction

" vim:set et sw=2:

