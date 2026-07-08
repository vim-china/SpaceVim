"=============================================================================
" search.vim --- search tools in SpaceVim (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#search#grep(key, scope) abort
  call luaeval("require('spacevim.mapping.search').grep(_A[1], _A[2])", [a:key, a:scope])
endfunction

function! SpaceVim#mapping#search#default_tool() abort
  return luaeval("require('spacevim.mapping.search').default_tool()")
endfunction

function! SpaceVim#mapping#search#getFopt(exe) abort
  return luaeval("require('spacevim.mapping.search').getFopt(_A)", a:exe)
endfunction

function! SpaceVim#mapping#search#profile(opt) abort
  call luaeval("require('spacevim.mapping.search').profile(_A)", a:opt)
endfunction

function! SpaceVim#mapping#search#getprofile(...) abort
  if a:0 > 0
    return luaeval("require('spacevim.mapping.search').getprofile(_A)", a:1)
  else
    return luaeval("require('spacevim.mapping.search').getprofile()")
  endif
endfunction

