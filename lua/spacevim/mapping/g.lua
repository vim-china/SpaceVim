--=============================================================================
-- g.lua --- g key bindings (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')
local call = vim.call

--- Preview tab (jump to previous tab)
local function preview_tab()
  if vim.fn.tabpagenr('#') > 0 then
    vim.cmd('tabnext ' .. vim.fn.tabpagenr('#'))
  end
end

--- G key bindings definition table
--- Each entry: { feedkeys_or_cmd, description, is_special }
local g_bindings = {
  ['<C-G>'] = { 'g<c-g>', 'show-cursor-info', true },
  ['&']     = { 'g&', 'repeat-last-:s-on-buffer', true },
  ["'"]     = { "g'", 'jump-to-mark-`', true },
  ['`']     = { 'g`', "jump-to-mark-'", true },
  ['+']     = { 'g+', 'newer-text-state', true },
  ['-']     = { 'g-', 'older-text-state', true },
  [',']     = { 'g,', 'newer-change-position', true },
  [';']     = { 'g;', 'older-change-position', true },
  ['@']     = { 'g@', 'call-operatorfunc', true },
  ['$']     = { 'g$', 'rightmost-character', true },
  ['<End>'] = { 'g<End>', 'rightmost-character', true },
  ['0']     = { 'g0', 'leftmost-character', true },
  ['<Home>']= { 'g<Home>', 'leftmost-character', true },
  ['e']     = { 'ge', 'end-of-previous-word', true },
  ['<']     = { 'g<', 'last-page-of-previous-command-output', true },
  ['f']     = { 'gf', 'edit-file-under-cursor', true },
  ['F']     = { 'gF', 'edit-file-withline-under-cursor', true },
  ['j']     = { 'gj', 'move-cursor-down-screen-line', true },
  ['k']     = { 'gk', 'move-cursor-up-screen-line', true },
  ['u']     = { 'gu', 'make-motion-text-lowercase', true },
  ['E']     = { 'gE', 'end-of-previous-word', true },
  ['U']     = { 'gU', 'make-motion-text-uppercase', true },
  ['H']     = { 'gH', 'select-line-mode', true },
  ['h']     = { 'gh', 'select-mode', true },
  ['I']     = { 'gI', 'insert-text-in-column-1', true },
  ['i']     = { 'gi', "insert-text-after-'^-mark", true },
  ['J']     = { 'gJ', 'join-lines-without-space', true },
  ['N']     = { 'gN', 'visually-select-previous-match', true },
  ['n']     = { 'gn', 'visually-select-next-match', true },
  ['Q']     = { 'gQ', 'switch-to-Ex-mode', true },
  ['q']     = { 'gq', 'format-Nmove-text', true },
  ['R']     = { 'gR', 'enter-VREPLACE-mode', true },
  ['T']     = { 'gT', 'previous-tag-page', true },
  ['t']     = { 'gt', 'next-tag-page', true },
  [']']     = { 'g]', 'tselect-cursor-tag', true },
  ['^']     = { 'g^', 'go-to-leftmost-no-white-character', true },
  ['_']     = { 'g_', 'go-to-last-char', true },
  ['~']     = { 'g~', 'swap-case-for-Nmove-text', true },
  ['a']     = { 'ga', 'print-ascii-value-of-cursor-character', true },
  ['g']     = { 'gg', 'go-to-line-N', true },
  ['m']     = { 'gm', 'go-to-middle-of-screenline', true },
  ['o']     = { 'go', 'goto-byte-N-in-the-buffer', true },
  ['s']     = { 'gs', 'sleep-N-seconds', true },
  ['v']     = { 'gv', 'reselect-the-previous-Visual-area', true },
  ['<C-]>'] = { 'g<c-]>', 'jump-to-tag-under-cursor', true },
}

--- Special bindings that use plug or custom commands
local g_special_bindings = {
  ['#'] = { '<Plug>(incsearch-nohl-g#)', 'backward-search-cword' },
  ['*'] = { '<Plug>(incsearch-nohl-g*)', 'forward-search-cword' },
  ['/'] = { '<Plug>(incsearch-stay)', 'stay-incsearch' },
  ['D'] = { 'call SpaceVim#mapping#g_capital_d()', 'goto-declaration' },
  ['d'] = { 'call SpaceVim#mapping#gd()', 'goto-definition' },
  ['='] = { 'call SpaceVim#mapping#format()', 'format-current-buffer' },
  ['p'] = { "exe 'normal! ' . '`['.strpart(getregtype(), 0, 1).'`]'", 'select-last-paste' },
}

--- Initialize g key bindings
function M.init()
  logger.debug('init g key bindings')
  vim.cmd('nnoremap <silent><nowait> [G] :<c-u>LeaderGuide "g"<CR>')
  vim.cmd('nmap g [G]')
  vim.g._spacevim_mappings_g = {}

  -- Simple feedkeys bindings
  for key, def in pairs(g_bindings) do
    local feedkeys, desc = def[1], def[2]
    vim.g._spacevim_mappings_g[key] = { 'call feedkeys("' .. feedkeys .. '", "n")', desc }
    if key == '<C-G>' then
      vim.cmd('nnoremap g<c-g> g<c-g>')
    elseif key == '<C-]>' then
      vim.cmd('nnoremap g<c-]> g<c-]>')
    elseif key == '<End>' then
      vim.cmd('nnoremap g<End> g<End>')
    elseif key == '<Home>' then
      vim.cmd('nnoremap g<Home> g<Home>')
    else
      vim.cmd('nnoremap g' .. key .. ' ' .. feedkeys)
    end
  end

  -- Special bindings (no direct nnoremap, use SpaceVim#mapping#def or plug)
  for key, def in pairs(g_special_bindings) do
    local cmd_str, desc = def[1], def[2]
    if key == 'D' then
      vim.g._spacevim_mappings_g['D'] = { cmd_str, desc }
      call('SpaceVim#mapping#def', 'nnoremap <silent>', 'gD', ':call SpaceVim#mapping#g_capital_d()<CR>', 'Goto declaration', '')
    elseif key == 'd' then
      vim.g._spacevim_mappings_g['d'] = { cmd_str, desc }
      call('SpaceVim#mapping#def', 'nnoremap <silent>', 'gd', ':call SpaceVim#mapping#gd()<CR>', 'Goto definition', '')
    elseif key == '=' then
      vim.g._spacevim_mappings_g['='] = { cmd_str, desc }
      call('SpaceVim#mapping#def', 'nnoremap <silent>', 'g=', ':call SpaceVim#mapping#format()<cr>', 'format current buffer', 'call SpaceVim#mapping#format()')
    elseif key == '#' or key == '*' or key == '/' then
      vim.g._spacevim_mappings_g[key] = { 'call feedkeys("' .. cmd_str .. '")', desc }
    elseif key == 'p' then
      vim.g._spacevim_mappings_g['p'] = { cmd_str, desc }
      vim.cmd([[nnoremap <silent><expr> gp '`['.strpart(getregtype(), 0, 1).'`]']])
    end
  end

  -- Tab bindings
  vim.cmd('nnoremap <silent>g0 :<C-u>tabfirst<CR>')
  vim.g._spacevim_mappings_g['0'] = { 'tabfirst', 'jump-to-first-tab' }
  -- override '0' since we have both g0 (leftmost) and g0 (tabfirst)
  -- Actually the original code overrides g0 with tabfirst, so let's keep that

  vim.cmd('nnoremap <silent>g$ :<C-u>tablast<CR>')
  vim.g._spacevim_mappings_g['$'] = { 'tablast', 'jump-to-last-tab' }

  -- Preview tab
  vim.cmd([[nnoremap <silent><expr> gr tabpagenr('#') > 0 ? ':exe "tabnext " . tabpagenr("#")<cr>' : '']])
  vim.g._spacevim_mappings_g['r'] = { 'call v:lua.require("spacevim.mapping.g").preview_tab()', 'jump-to-preview-tab' }
end

-- Expose preview_tab for the mapping
M.preview_tab = preview_tab

return M

