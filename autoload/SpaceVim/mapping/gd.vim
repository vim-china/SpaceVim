"=============================================================================
" gd.vim --- gd key binding (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#gd#add(ft, func) abort
  lua require('spacevim.mapping.gd').add(vim.fn.eval('a:ft'), vim.fn.eval('a:func'))
endfunction

function! SpaceVim#mapping#gd#get() abort
  return luaeval("require('spacevim.mapping.gd').get()")
endfunction

