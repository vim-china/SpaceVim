--=============================================================================
-- exprfold.lua --- SpaceVim exprfold layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return {
    { 'ZSaberLv0/ZFVimFoldBlock', { merged = false } },
  }
end

function M.config()
  vim.cmd('nnoremap ZB q::call ZF_FoldBlockTemplate()<cr>')
  vim.cmd('nnoremap ZF :ZFFoldBlock //<left>')
  vim.cmd([[
    function! ZF_Plugin_ZFVimFoldBlock_comment() abort
        let expr='\(^\s*\/\/\)'
        if &filetype ==# 'vim'
            let expr.='\|\(^\s*"\)'
        endif
        if &filetype ==# 'c' || &filetype ==# 'cpp'
            let expr.='\|\(^\s*\(\(\/\*\)\|\(\*\)\)\)'
        endif
        if &filetype ==# 'make'
            let expr.='\|\(^\s*#\)'
        endif
        let disableE2vSaved = g:ZFVimFoldBlock_disableE2v
        let g:ZFVimFoldBlock_disableE2v = 1
        call ZF_FoldBlock('/' . expr . '//')
        let g:ZFVimFoldBlock_disableE2v = disableE2vSaved
        echo 'comments folded'
    endfunction
  ]])
  vim.cmd('nnoremap ZC :call ZF_Plugin_ZFVimFoldBlock_comment()<cr>')
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

