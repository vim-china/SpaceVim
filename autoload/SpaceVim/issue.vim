"=============================================================================
" issue.vim --- issue reporter for SpaceVim (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#issue#report() abort
  lua require('spacevim.issue').report()
endfunction

function! SpaceVim#issue#new() abort
  lua require('spacevim.issue').new()
endfunction

function! SpaceVim#issue#reopen(id) abort
  call luaeval('require("spacevim.issue").reopen(_A)', a:id)
endfunction

function! SpaceVim#issue#close(id) abort
  call luaeval('require("spacevim.issue").close(_A)', a:id)
endfunction

