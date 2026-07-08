"=============================================================================
" autocmds.vim --- core autocmds for SpaceVim (VimEnter + helpers)
" Copyright (c) 2016-2025 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
" init() is implemented in lua/spacevim/autocmds.lua
" This file contains VimEnter callback and helper functions
" that are called from Lua autocmds.
scriptencoding utf-8

let s:VIM = SpaceVim#api#import('vim')

function! SpaceVim#autocmds#VimEnter() abort
  call SpaceVim#api#import('vim#highlight').hide_in_normal('EndOfBuffer')
  call s:apply_custom_space_keybindings()
  call s:apply_custom_leader_keybindings()
  if SpaceVim#layers#isLoaded('core#statusline')
    set laststatus=2
    call SpaceVim#layers#core#statusline#def_colors()
    setlocal statusline=%!SpaceVim#layers#core#statusline#get(1)
  endif
  if SpaceVim#layers#isLoaded('core#tabline')
    call SpaceVim#layers#core#tabline#def_colors()
    set showtabline=2
  endif
  call s:fix_colorschem_in_SpaceVim()
  if !empty(g:spacevim_guifont)
    try
      let &guifont = g:spacevim_guifont
    catch
      call SpaceVim#logger#error('failed to set guifont to: ' . g:spacevim_guifont)
    endtry
  endif
endfunction

function! s:apply_custom_space_keybindings() abort
  for argv in g:_spacevim_mappings_space_custom_group_name
    if len(argv[0]) == 1
      if !has_key(g:_spacevim_mappings_space, argv[0][0])
        let g:_spacevim_mappings_space[argv[0][0]] = {'name' : argv[1]}
      endif
    elseif len(argv[0]) == 2
      if !has_key(g:_spacevim_mappings_space, argv[0][0])
        let g:_spacevim_mappings_space[argv[0][0]] = {'name' : '+Unnamed',
              \ argv[0][1] : { 'name' : argv[1]},
              \ }
      else
        if !has_key(g:_spacevim_mappings_space[argv[0][0]], argv[0][1])
          let g:_spacevim_mappings_space[argv[0][0]][argv[0][1]] = {'name' : argv[1]}
        endif
      endif
    endif
  endfor
  for argv in g:_spacevim_mappings_space_custom
    call call('SpaceVim#mapping#space#def', argv)
  endfor
endfunction

function! s:apply_custom_leader_keybindings() abort
  for argv in g:_spacevim_mappings_leader_custom_group_name
    if len(argv[0]) == 1
      if !has_key(g:_spacevim_mappings, argv[0][0])
        let g:_spacevim_mappings[argv[0][0]] = {'name' : argv[1]}
      endif
    elseif len(argv[0]) == 2
      if !has_key(g:_spacevim_mappings, argv[0][0])
        let g:_spacevim_mappings[argv[0][0]] = {'name' : '+Unnamed',
              \ argv[0][1] : { 'name' : argv[1]},
              \ }
      else
        if !has_key(g:_spacevim_mappings[argv[0][0]], argv[0][1])
          let g:_spacevim_mappings[argv[0][0]][argv[0][1]] = {'name' : argv[1]}
        endif
      endif
    endif
  endfor
  for argv in g:_spacevim_mappings_leader_custom
    call call('SpaceVim#mapping#def', argv)
  endfor
endfunction

function! s:fix_colorschem_in_SpaceVim() abort
  if exists('g:colors_name')
    if &background ==# 'dark'
      if g:colors_name ==# 'gruvbox'
        hi VertSplit guibg=#282828 guifg=#181A1F
        hi clear NormalFloat
        hi link NormalFloat PMenu
      elseif g:colors_name ==# 'one'
        hi VertSplit guibg=#282c34 guifg=#181A1F
        hi SPCFloatBorder guibg=#282c34 guifg=#181A1F
        hi SPCNormalFloat guifg=#abb2bf guibg=#282c34
        hi clear StatusLineNC
        hi link StatusLineNC Normal
      elseif g:colors_name ==# 'jellybeans'
        hi VertSplit guibg=#151515 guifg=#080808
      elseif g:colors_name ==# 'nord'
        hi VertSplit guibg=#2E3440 guifg=#262626
      elseif g:colors_name ==# 'SpaceVim'
        hi VertSplit guibg=#262626 guifg=#181A1F
      elseif g:colors_name ==# 'srcery'
        hi VertSplit guibg=#1C1B19 guifg=#262626
        hi clear Visual
        hi Visual guibg=#303030
      elseif g:colors_name ==# 'NeoSolarized'
        hi VertSplit guibg=#002b36 guifg=#181a1f
        hi clear Pmenu
        hi Pmenu guifg=#839496 guibg=#073642
      endif
    else
      if g:colors_name ==# 'gruvbox'
        hi VertSplit guibg=#fbf1c7 guifg=#e7e9e1
      endif
    endif
  endif
  hi SpaceVimLeaderGuiderGroupName cterm=bold ctermfg=175 gui=bold guifg=#d3869b
  hi link WinSeparator VertSplit
endfunction

" vim:set et sw=2:

