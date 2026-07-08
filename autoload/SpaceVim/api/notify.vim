"=============================================================================
" notify.vim --- SpaceVim notify API (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#api#notify#get() abort
  return luaeval("require('spacevim.api.notify')")
endfunction

function! SpaceVim#api#notify#shared_notifys() abort
  return luaeval("require('spacevim.api.notify').shared_notifys()")
endfunction

" vim:set et sw=2:

