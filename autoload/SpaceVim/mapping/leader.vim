"=============================================================================
" leader.vim --- mapping leader definition file for SpaceVim (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#leader#defindWindowsLeader(key) abort
  call luaeval("require('spacevim.mapping.leader').defindWindowsLeader(_A)", a:key)
endfunction

function! SpaceVim#mapping#leader#defindDeniteLeader(key) abort
  call luaeval("require('spacevim.mapping.leader').defindDeniteLeader(_A)", a:key)
endfunction

function! SpaceVim#mapping#leader#getName(key) abort
  return luaeval("require('spacevim.mapping.leader').getName(_A)", a:key)
endfunction

function! SpaceVim#mapping#leader#defindKEYs() abort
  call luaeval("require('spacevim.mapping.leader').defindKEYs()")
endfunction

" vim:set et sw=2 cc=80:

