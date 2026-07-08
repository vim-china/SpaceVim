"=============================================================================
" util.vim --- SpaceVim utils (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

function! SpaceVim#util#globpath(path, expr) abort
  call SpaceVim#logger#warn('SpaceVim#util#globpath will be removed in next release.')
  return globpath(a:path, a:expr, 1, 1)
endfunction

function! SpaceVim#util#findFileInParent(what, where) abort
  return luaeval('require("spacevim.util").findFileInParent(_A[1], _A[2])', [a:what, a:where])
endfunction

function! SpaceVim#util#loadConfig(file) abort
  call luaeval('require("spacevim.util").loadConfig(_A)', a:file)
endfunction

function! SpaceVim#util#findDirInParent(what, where) abort
  return luaeval('require("spacevim.util").findDirInParent(_A[1], _A[2])', [a:what, a:where])
endfunction

function! SpaceVim#util#echoWarn(msg) abort
  call luaeval('require("spacevim.util").echoWarn(_A)', a:msg)
endfunction

function! SpaceVim#util#haspyxlib(lib) abort
  return luaeval('require("spacevim.util").haspyxlib(_A)', a:lib)
endfunction

function! SpaceVim#util#haspylib(lib) abort
  return luaeval('require("spacevim.util").haspylib(_A)', a:lib)
endfunction

function! SpaceVim#util#haspy3lib(lib) abort
  return luaeval('require("spacevim.util").haspy3lib(_A)', a:lib)
endfunction

function! SpaceVim#util#CopyToClipboard(...) abort
  call call('luaeval("require(\"spacevim.util\").CopyToClipboard(unpack(_A))")', a:000)
endfunction

function! SpaceVim#util#Generate_ignore(ignore, tool, ...) abort
  return luaeval('require("spacevim.util").Generate_ignore(_A[1], _A[2], _A[3])', [a:ignore, a:tool, get(a:000, 0, 0)])
endfunction

function! SpaceVim#util#UpdateHosts(...) abort
  call call('luaeval("require(\"spacevim.util\").UpdateHosts(unpack(_A))")', a:000)
endfunction

function! SpaceVim#util#listDirs(dir) abort
  return luaeval('require("spacevim.util").listDirs(_A)', a:dir)
endfunction

