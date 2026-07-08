"=============================================================================
" lsp.vim --- language server protocol (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Seong Yong-ju < @sei40kr >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
" All LSP logic is in lua/spacevim/lsp.lua and lua/spacevim/diagnostic.lua
" This file provides thin wrappers for vim script callers.
scriptencoding utf-8

let s:box = SpaceVim#api#import('unicode#box')
let s:NOTI = SpaceVim#api#import('notify')

function! SpaceVim#lsp#reg_server(ft, cmds) abort
  lua require("spacevim.lsp").register(vim.api.nvim_eval("a:ft"), vim.api.nvim_eval("a:cmds"))
endfunction

function! SpaceVim#lsp#show_doc() abort
  lua vim.lsp.buf.hover()
endfunction

function! SpaceVim#lsp#go_to_def() abort
  lua vim.lsp.buf.definition()
endfunction

function! SpaceVim#lsp#go_to_declaration() abort
  lua vim.lsp.buf.declaration()
endfunction

function! SpaceVim#lsp#rename() abort
  lua vim.lsp.buf.rename()
endfunction

function! SpaceVim#lsp#references() abort
  lua vim.lsp.buf.references()
endfunction

function! SpaceVim#lsp#go_to_typedef() abort
endfunction

function! SpaceVim#lsp#refactor() abort
endfunction

function! SpaceVim#lsp#go_to_impl() abort
  lua vim.lsp.buf.implementation()
endfunction

function! SpaceVim#lsp#show_line_diagnostics() abort
  lua require('spacevim.diagnostic').open_float()
endfunction

function! SpaceVim#lsp#list_workspace_folder() abort
  let workspace = luaeval('vim.lsp.buf.list_workspace_folders()')
  let bw = max(map(deepcopy(workspace), 'strwidth(v:val)')) + 5
  let box = s:box.drawing_box(workspace, 1, 1, bw, {'align' : 'left'})
  call s:NOTI.notify(join(box, "\n"))
endfunction

function! SpaceVim#lsp#add_workspace_folder() abort
  lua vim.lsp.buf.add_workspace_folder()
endfunction

function! SpaceVim#lsp#remove_workspace_folder() abort
  lua vim.lsp.buf.remove_workspace_folder()
endfunction

function! SpaceVim#lsp#buf_server_ready() abort
  return luaeval('require("spacevim.lsp").server_ready()')
endfunction

function! SpaceVim#lsp#diagnostic_set_loclist() abort
  lua require('spacevim.diagnostic').set_loclist()
endfunction

function! SpaceVim#lsp#diagnostic_goto_next() abort
  lua require("spacevim.diagnostic").goto_next()
endfunction

function! SpaceVim#lsp#diagnostic_goto_prev() abort
  lua require("spacevim.diagnostic").goto_prev()
endfunction

function! SpaceVim#lsp#diagnostic_clear() abort
  lua require("spacevim.diagnostic").clear()
endfunction

function! SpaceVim#lsp#code_action() abort
  lua vim.lsp.buf.code_action()
endfunction

function! SpaceVim#lsp#range_code_action() abort
  lua vim.lsp.buf.range_code_action()
endfunction

function! SpaceVim#lsp#document_format() abort
  lua vim.lsp.buf.formatting()
endfunction

function! SpaceVim#lsp#range_format() abort
  lua vim.lsp.buf.range_formatting()
endfunction

function! SpaceVim#lsp#goto_preview() abort
  lua require("spacevim.lsp").goto_preview()
endfunction

function! SpaceVim#lsp#diagnostic_count() abort
  return luaeval('require("spacevim.lsp").lsp_diagnostic_count()')
endfunction

" vim:set et sw=2:

