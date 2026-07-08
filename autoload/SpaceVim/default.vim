"=============================================================================
" default.vim --- default options in SpaceVim (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#default#options() abort
  lua require('spacevim.default').options()
endfunction

function! SpaceVim#default#layers() abort
  lua require('spacevim.default').layers()
endfunction

function! SpaceVim#default#keyBindings(...) abort
  call luaeval('require("spacevim.default").keyBindings(unpack(_A))', a:000)
endfunction

function! SpaceVim#default#UseSimpleMode() abort
  lua require('spacevim.default').UseSimpleMode()
endfunction

function! SpaceVim#default#Customfoldtext() abort
  return luaeval('require("spacevim.default").Customfoldtext()')
endfunction

