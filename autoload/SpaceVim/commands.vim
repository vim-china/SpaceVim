"=============================================================================
" commands.vim --- commands in SpaceVim (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#commands#load() abort
  lua require('spacevim.command').load()
endfunction

function! SpaceVim#commands#complete_plugin(ArgLead, CmdLine, CursorPos) abort
  return luaeval('require("spacevim.command").complete_plugin(_A[1], _A[2], _A[3])', [a:ArgLead, a:CmdLine, a:CursorPos])
endfunction

function! SpaceVim#commands#complete_SPConfig(ArgLead, CmdLine, CursorPos) abort
  return luaeval('require("spacevim.command").complete_SPConfig(_A[1], _A[2], _A[3])', [a:ArgLead, a:CmdLine, a:CursorPos])
endfunction

function! SpaceVim#commands#config(...) abort
  call call('luaeval("require(\"spacevim.command\").config(unpack(_A))")', a:000)
endfunction

function! SpaceVim#commands#update_plugin(...) abort
  call call('luaeval("require(\"spacevim.command\").update_plugin(unpack(_A))")', a:000)
endfunction

function! SpaceVim#commands#reinstall_plugin(...) abort
  call call('luaeval("require(\"spacevim.command\").reinstall_plugin(unpack(_A))")', a:000)
endfunction

function! SpaceVim#commands#clean_plugin() abort
  lua require('spacevim.command').clean_plugin()
endfunction

function! SpaceVim#commands#install_plugin(...) abort
  call call('luaeval("require(\"spacevim.command\").install_plugin(unpack(_A))")', a:000)
endfunction

function! SpaceVim#commands#version() abort
  lua require('spacevim.command').version()
endfunction

function! SpaceVim#commands#complete_options(...) abort
  return luaeval('require("spacevim.command").complete_options()')
endfunction

