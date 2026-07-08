"=============================================================================
" g_capital_d.vim --- gD key binding (thin Lua wrapper)
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: sisynb < bsixxxx at gmail.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#g_capital_d#add(ft, func) abort
  lua require('spacevim.mapping.g_capital_d').add(vim.fn.eval('a:ft'), vim.fn.eval('a:func'))
endfunction

function! SpaceVim#mapping#g_capital_d#get() abort
  return luaeval("require('spacevim.mapping.g_capital_d').get()")
endfunction

