"=============================================================================
" SpaceVim.vim --- Initialization and core files for SpaceVim (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
" This file is a thin wrapper that delegates to lua/spacevim/init.lua
" All logic has been rewritten in Lua. Neovim 0.9+ required.
scriptencoding utf-8

" Initialize all SpaceVim options and variables via Lua
lua require('spacevim')

""
" Begin SpaceVim initialization. Called from user config.
function! SpaceVim#begin() abort
  lua require('spacevim').begin()
endfunction

""
" End SpaceVim initialization. Called from user config.
function! SpaceVim#end() abort
  lua require('spacevim')['end']()
endfunction

""
" Open SpaceVim welcome page.
function! SpaceVim#welcome() abort
  lua require('spacevim').welcome()
endfunction

" vim:set et sw=2 cc=80:

