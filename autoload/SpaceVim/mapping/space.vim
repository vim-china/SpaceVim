"=============================================================================
" space.vim --- Space key bindings (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#space#init() abort
  call luaeval("require('spacevim.mapping.space').init()")
endfunction

function! SpaceVim#mapping#space#def(m, keys, cmd, desc, is_cmd, ...) abort
  let is_visual = a:0 > 0 ? a:1 : 0
  call luaeval("require('spacevim.mapping.space').def(_A[1], _A[2], _A[3], _A[4], _A[5], _A[6])",
        \ [a:m, a:keys, a:cmd, a:desc, a:is_cmd, is_visual])
endfunction

function! SpaceVim#mapping#space#refrashLSPC() abort
  call luaeval("require('spacevim.mapping.space').refrashLSPC()")
endfunction

function! SpaceVim#mapping#space#regesit_lang_mappings(ft, func) abort
  call luaeval("require('spacevim.mapping.space').regesit_lang_mappings(_A[1], _A[2])", [a:ft, a:func])
endfunction

function! SpaceVim#mapping#space#get_lang_mappings(ft) abort
  return luaeval("require('spacevim.mapping.space').get_lang_mappings(_A)", a:ft)
endfunction

function! SpaceVim#mapping#space#langSPC(m, keys, cmd, desc, is_cmd, ...) abort
  let is_visual = a:0 > 0 ? a:1 : 0
  call luaeval("require('spacevim.mapping.space').langSPC(_A[1], _A[2], _A[3], _A[4], _A[5], _A[6])",
        \ [a:m, a:keys, a:cmd, a:desc, a:is_cmd, is_visual])
endfunction

" vim:set et nowrap sw=2 cc=80:

