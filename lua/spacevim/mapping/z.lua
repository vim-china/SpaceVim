--=============================================================================
-- z.lua --- z key bindings (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')

--- Z key bindings definition table
--- Each entry: { feedkeys, description }
local z_bindings = {
  ['<CR>'] = { 'z<CR>', 'cursor-line-to-top' },
  ['+']    = { 'z+', 'cursor-to-screen-top-line-N' },
  ['-']    = { 'z-', 'cursor-to-screen-bottom-line-N' },
  ['^']    = { 'z^', 'cursor-to-screen-bottom-line-N' },
  ['.']    = { 'z.', 'cursor-line-to-center' },
  ['=']    = { 'z=', 'spelling-suggestions' },
  ['A']    = { 'zA', 'toggle-folds-recursively' },
  ['C']    = { 'zC', 'close-folds-recursively' },
  ['D']    = { 'zD', 'delete-folds-recursively' },
  ['E']    = { 'zE', 'eliminate-all-folds' },
  ['F']    = { 'zF', 'create-a-fold-for-N-lines' },
  ['G']    = { 'zG', 'mark-good-spelled' },
  ['H']    = { 'zH', 'right-scroll-half-a-screen' },
  ['L']    = { 'zL', 'left-scroll-half-a-screen' },
  ['M']    = { 'zM', 'set-`foldlevel`-to-zero' },
  ['N']    = { 'zN', 'set-`foldenable`' },
  ['O']    = { 'zO', 'open-folds-recursively' },
  ['R']    = { 'zR', 'set-`foldlevel`-to-deepest-fold' },
  ['W']    = { 'zW', 'mark-wrong-spelled' },
  ['X']    = { 'zX', 're-apply-`foldleve`' },
  ['a']    = { 'za', 'toggle-a-fold' },
  ['b']    = { 'zb', 'redraw-cursor-line-at-bottom' },
  ['c']    = { 'zc', 'close-a-fold' },
  ['d']    = { 'zd', 'delete-a-fold' },
  ['e']    = { 'ze', 'right-scroll-horizontally' },
  ['f']    = { 'zf', 'create-a-fold-for-motion' },
  ['g']    = { 'zg', 'mark-good-spelled' },
  ['h']    = { 'zh', 'scroll-screen-N-characters-to-right' },
  ['<Left>']  = { 'zh', 'right-scroll-text' },
  ['i']    = { 'zi', 'toggle-foldenable' },
  ['j']    = { 'zj', 'move-to-start-of-next-fold' },
  ['J']    = { 'zjzx', 'move-to-and-open-next-fold' },
  ['k']    = { 'zk', 'move-to-end-of-previous-fold' },
  ['K']    = { 'zkzx', 'move-to-and-open-previous-fold' },
  ['l']    = { 'zl', 'scroll-screen-N-characters-to-left' },
  ['<Right>'] = { 'zl', 'left-scroll-text' },
  ['m']    = { 'zm', 'subtract-one-from-`foldlevel`' },
  ['n']    = { 'zn', 'reset-`foldenable`' },
  ['o']    = { 'zo', 'open-fold' },
  ['r']    = { 'zr', 'add-one-to-`foldlevel`' },
  ['s']    = { 'zs', 'left-scroll-horizontally' },
  ['t']    = { 'zt', 'cursor-line-at-top-of-window' },
  ['v']    = { 'zv', 'open-enough-folds' },
  ['w']    = { 'zw', 'mark-wrong-spelled' },
  ['x']    = { 'zx', 're-apply-foldlevel-and-do-"zV"' },
  ['z']    = { 'zz', 'smart-scroll' },
}

--- Initialize z key bindings
function M.init()
  logger.debug('init z key bindings')
  vim.cmd('nnoremap <silent><nowait> [Z] :<c-u>LeaderGuide "z"<CR>')
  vim.cmd('nmap z [Z]')
  vim.g._spacevim_mappings_z = {}
  for key, def in pairs(z_bindings) do
    local feedkeys, desc = def[1], def[2]
    vim.g._spacevim_mappings_z[key] = { 'call feedkeys("' .. feedkeys .. '", "n")', desc }
    local map_key = key == '<Left>' and '<Left>' or key == '<Right>' and '<Right>' or key == '<CR>' and '<CR>' or key
    vim.cmd('nnoremap z' .. map_key .. ' ' .. feedkeys)
  end
end

return M

