"=============================================================================
" logger.vim --- SpaceVim logger (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#logger#info(msg) abort
  lua require("spacevim.logger").info(vim.api.nvim_eval("a:msg"))
endfunction

function! SpaceVim#logger#warn(msg, ...) abort
  let issilent = get(a:000, 0, 1)
  lua require("spacevim.logger").warn(vim.api.nvim_eval("a:msg"), vim.api.nvim_eval("issilent"))
endfunction

function! SpaceVim#logger#error(msg) abort
  lua require("spacevim.logger").error(vim.api.nvim_eval("a:msg"))
endfunction

function! SpaceVim#logger#debug(msg) abort
  lua require("spacevim.logger").debug(vim.api.nvim_eval("a:msg"))
endfunction

function! SpaceVim#logger#viewRuntimeLog(...) abort
  if get(a:000, 0, '') ==# '--clear'
    lua require("spacevim.logger").clearRuntimeLog()
    return
  endif
  lua require("spacevim.logger").viewRuntimeLog()
endfunction

function! SpaceVim#logger#viewLog(...) abort
  if a:0 >= 1
    let bang = get(a:000, 0, 0)
    return luaeval('require("spacevim.logger").viewLog(vim.api.nvim_eval("bang"))')
  else
    return luaeval('require("spacevim.logger").viewLog()')
  endif
endfunction

function! SpaceVim#logger#setLevel(level) abort
  lua require("spacevim.logger").setLevel(vim.api.nvim_eval("a:level"))
endfunction

function! SpaceVim#logger#setOutput(file) abort
  lua require("spacevim.logger").setOutput(vim.api.nvim_eval("a:file"))
endfunction

function! SpaceVim#logger#derive(name) abort
  return luaeval('require("spacevim.logger").derive(vim.api.nvim_eval("a:name"))')
endfunction

