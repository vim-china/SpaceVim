"=============================================================================
" layers.vim --- layers public API (Lua delegate)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section Layers, layers
"   Layers help collecting related packages together to provides features.
" This approach helps keep configuration organized and reduces overhead for
" the user by keeping them from having to think about what packages to install.
"
" @subsection Enable layers
"
" By default SpaceVim enables these layers:
"
" 1. `autocomplete`
" 2. `checkers`
" 3. `format`
" 4. `edit`
" 5. `ui`
" 6. `core`
" 7. `core#banner`
" 8. `core#statusline`
" 9. `core#tabline`
"
" To enable a specific layer you need to edit SpaceVim's custom configuration files.
" The key binding for opening the configuration files is `SPC f v d`.
"
" The following example shows how to load `shell` layer with some specified options:
" >
"   [[layers]]
"     name = 'shell'
"     default_position = 'top'
"     default_height = 30
" <
"
" @subsection Disable layers
"
" Some layers are enabled by default. The following example shows how to disable `shell` layer:
" >
"   [[layers]]
"     name = 'shell'
"     enable = false
" <

function! SpaceVim#layers#load(layer, ...) abort
  if a:0 > 0
    call call('luaeval("require(\"spacevim.layer\").load(_A[1], unpack(_A[2]))")', [a:layer, a:000])
  else
    call luaeval('require("spacevim.layer").load(_A)', a:layer)
  endif
endfunction

function! SpaceVim#layers#disable(layer) abort
  call luaeval('require("spacevim.layer").disable(_A)', a:layer)
endfunction

function! SpaceVim#layers#get() abort
  return luaeval('require("spacevim.layer").get()')
endfunction

function! SpaceVim#layers#isLoaded(layer) abort
  return luaeval('require("spacevim.layer").isLoaded(_A)', a:layer)
endfunction

function! SpaceVim#layers#report() abort
  return luaeval('require("spacevim.layer").report()')
endfunction

function! SpaceVim#layers#list() abort
  return luaeval('require("spacevim.layer").list()')
endfunction

