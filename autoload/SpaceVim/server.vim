"=============================================================================
" server.vim --- server manager for SpaceVim (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#server#connect() abort
  lua require('spacevim.server').connect()
endfunction

function! SpaceVim#server#export_server() abort
  lua require('spacevim.server').export_server()
endfunction

function! SpaceVim#server#terminate() abort
  lua require('spacevim.server').terminate()
endfunction

function! SpaceVim#server#list() abort
  return luaeval('require("spacevim.server").list()')
endfunction

