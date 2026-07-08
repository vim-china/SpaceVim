"=============================================================================
" options.vim --- options function in SpaceVim (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#options#list() abort
  return luaeval('require("spacevim.options").list()')
endfunction

function! SpaceVim#options#set(argv, ...) abort
  if a:0 > 0
    call luaeval('require("spacevim.options").set(_A[1], _A[2])', [a:argv, a:1])
  else
    call luaeval('require("spacevim.options").set(_A)', a:argv)
  endif
endfunction

