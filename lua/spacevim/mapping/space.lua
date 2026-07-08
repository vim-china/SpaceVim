--=============================================================================
-- space.lua --- Space key bindings (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')
local call = vim.call
local fn = vim.fn
local cmd = vim.cmd

-- APIs
local BUF = require('spacevim.api').import('vim#buffer')
local TIME = require('spacevim.api').import('time')
local WIN = require('spacevim.api').import('vim#window')

-- State
local language_specified_mappings = {}
local scratch_buffer = -1
local maximize_previous_winid = nil

--- Check if leader is mapped to space
local function has_map_to_spc()
  return (vim.g.mapleader or '\\') == ' '
end

--- Define a space key binding
--- @param m string mode (nnoremap, nmap, etc.)
--- @param keys string[] key sequence
--- @param cmd_str string command or key sequence
--- @param desc string|string[] description
--- @param is_cmd boolean whether cmd_str is a command
--- @param is_visual? boolean whether to also map in visual mode
function M.def(m, keys, cmd_str, desc, is_cmd, is_visual)
  if has_map_to_spc() then return end

  local lcmd
  local map_cmd
  if is_cmd then
    map_cmd = ':<C-u>' .. cmd_str .. '<CR>'
    lcmd = cmd_str
  else
    map_cmd = cmd_str
    local feedkey_m = string.match(m, 'nore') and 'n' or 'm'
    if string.match(cmd_str:lower(), '^<plug>') then
      lcmd = 'call feedkeys("\\' .. cmd_str .. '", "' .. feedkey_m .. '")'
    else
      lcmd = 'call feedkeys("' .. cmd_str .. '", "' .. feedkey_m .. '")'
    end
  end

  local escaped_cmd = string.gsub(map_cmd, '|', '\\|')
  local keys_str = table.concat(keys, '')
  cmd(m .. ' <silent> [SPC]' .. keys_str .. ' ' .. escaped_cmd)

  if is_visual then
    local xcmd = string.gsub(map_cmd, '|', '\\|')
    if m == 'nnoremap' then
      cmd('xnoremap <silent> [SPC]' .. keys_str .. ' ' .. xcmd)
    elseif m == 'nmap' then
      cmd('xmap <silent> [SPC]' .. keys_str .. ' ' .. xcmd)
    end
  end

  -- Store in mappings table
  vim.g._spacevim_mappings_space = vim.g._spacevim_mappings_space or {}
  local desc_value
  if type(desc) == 'string' then
    desc_value = { lcmd, desc }
  else
    desc_value = { lcmd, desc[1], desc[2] }
  end

  if #keys == 2 then
    vim.g._spacevim_mappings_space[keys[1]] = vim.g._spacevim_mappings_space[keys[1]] or {}
    vim.g._spacevim_mappings_space[keys[1]][keys[2]] = desc_value
  elseif #keys == 3 then
    vim.g._spacevim_mappings_space[keys[1]] = vim.g._spacevim_mappings_space[keys[1]] or {}
    vim.g._spacevim_mappings_space[keys[1]][keys[2]] = vim.g._spacevim_mappings_space[keys[1]][keys[2]] or {}
    vim.g._spacevim_mappings_space[keys[1]][keys[2]][keys[3]] = desc_value
  elseif #keys == 1 then
    vim.g._spacevim_mappings_space[keys[1]] = desc_value
  end

  -- Register menu
  local menu_desc = type(desc) == 'string' and desc or desc[1]
  call('SpaceVim#mapping#menu', menu_desc, '[SPC]' .. keys_str, lcmd)

  -- Extend prefixes
  vim.g._spacevim_mappings_prefixs = vim.g._spacevim_mappings_prefixs or {}
  vim.g._spacevim_mappings_prefixs['[SPC]'] = vim.tbl_extend('force', vim.g._spacevim_mappings_prefixs['[SPC]'] or {}, vim.g._spacevim_mappings_space or {})
end

--- Define a language-specific space key binding
--- @param m string mode
--- @param keys string[] key sequence (without 'l' prefix)
--- @param cmd_str string command
--- @param desc string description
--- @param is_cmd boolean
--- @param is_visual? boolean
function M.langSPC(m, keys, cmd_str, desc, is_cmd, is_visual)
  if has_map_to_spc() then return end

  local lcmd
  local map_cmd
  if is_cmd then
    map_cmd = ':<C-u>' .. cmd_str .. '<CR>'
    lcmd = cmd_str
  else
    map_cmd = cmd_str
    local feedkey_m = string.match(m, 'nore') and 'n' or 'm'
    if string.match(cmd_str:lower(), '^<plug>') then
      lcmd = 'call feedkeys("\\' .. cmd_str .. '", "' .. feedkey_m .. '")'
    else
      lcmd = 'call feedkeys("' .. cmd_str .. '", "' .. feedkey_m .. '")'
    end
  end

  local escaped_cmd = string.gsub(map_cmd, '|', '\\|')
  local keys_str = table.concat(keys, '')
  cmd(m .. ' <silent> <buffer> [SPC]' .. keys_str .. ' ' .. escaped_cmd)

  if is_visual then
    local xcmd = string.gsub(map_cmd, '|', '\\|')
    if m == 'nnoremap' then
      cmd('xnoremap <silent> <buffer> [SPC]' .. keys_str .. ' ' .. xcmd)
    elseif m == 'nmap' then
      cmd('xmap <silent> <buffer> [SPC]' .. keys_str .. ' ' .. xcmd)
    end
  end

  vim.g._spacevim_mappings_space = vim.g._spacevim_mappings_space or {}
  local desc_value = { lcmd, desc }
  if #keys == 2 then
    vim.g._spacevim_mappings_space[keys[1]] = vim.g._spacevim_mappings_space[keys[1]] or {}
    vim.g._spacevim_mappings_space[keys[1]][keys[2]] = desc_value
  elseif #keys == 3 then
    vim.g._spacevim_mappings_space[keys[1]] = vim.g._spacevim_mappings_space[keys[1]] or {}
    vim.g._spacevim_mappings_space[keys[1]][keys[2]] = vim.g._spacevim_mappings_space[keys[1]][keys[2]] or {}
    vim.g._spacevim_mappings_space[keys[1]][keys[2]][keys[3]] = desc_value
  elseif #keys == 1 then
    vim.g._spacevim_mappings_space[keys[1]] = desc_value
  end

  call('SpaceVim#mapping#menu', desc, '[SPC]' .. keys_str, lcmd)
  vim.g._spacevim_mappings_prefixs = vim.g._spacevim_mappings_prefixs or {}
  vim.g._spacevim_mappings_prefixs['[SPC]'] = vim.tbl_extend('force', vim.g._spacevim_mappings_prefixs['[SPC]'] or {}, vim.g._spacevim_mappings_space or {})
end

--- Register language-specific mappings
--- @param ft string filetype
--- @param func function mapping function
function M.regesit_lang_mappings(ft, func)
  language_specified_mappings[ft] = func
end

--- Get language-specific mappings function
--- @param ft string filetype
--- @return function|string
function M.get_lang_mappings(ft)
  return language_specified_mappings[ft] or ''
end

--- Refresh language-specific SPC mappings
function M.refrashLSPC()
  vim.g._spacevim_mappings_space = vim.g._spacevim_mappings_space or {}
  vim.g._spacevim_mappings_space.l = { name = '+Language Specified' }

  if vim.bo.filetype and vim.bo.filetype ~= '' and language_specified_mappings[vim.bo.filetype] then
    language_specified_mappings[vim.bo.filetype]()
    vim.b.spacevim_lang_specified_mappings = vim.g._spacevim_mappings_space.l
  end

  -- Customized mappings
  vim.g._spacevim_mappings_lang_group_name = vim.g._spacevim_mappings_lang_group_name or {}
  if vim.g._spacevim_mappings_lang_group_name[vim.bo.filetype] then
    for _, argv in ipairs(vim.g._spacevim_mappings_lang_group_name[vim.bo.filetype]) do
      if not vim.g._spacevim_mappings_space.l[argv[1][1]] then
        vim.g._spacevim_mappings_space.l[argv[1][0]] = { name = argv[1] }
      end
    end
  end

  vim.g._spacevim_mappings_language_specified_space_custom = vim.g._spacevim_mappings_language_specified_space_custom or {}
  if vim.g._spacevim_mappings_language_specified_space_custom[vim.bo.filetype] then
    for _, argv in ipairs(vim.g._spacevim_mappings_language_specified_space_custom[vim.bo.filetype]) do
      local new_argv = vim.deepcopy(argv)
      table.insert(new_argv[2], 1, 'l')
      M.langSPC(new_argv[1], new_argv[2], new_argv[3], new_argv[4], new_argv[5])
    end
  end
end

--- Initialize space key bindings
function M.init()
  logger.debug('init SPC key bindings')
  if has_map_to_spc() then return end

  cmd('nnoremap <silent><nowait> [SPC] :<c-u>LeaderGuide \' \'<CR>')
  cmd('vnoremap <silent><nowait> [SPC] :<c-u>LeaderGuideVisual \' \'<CR>')
  cmd(string.format('nmap %s [SPC]', vim.g.spacevim_default_custom_leader))
  cmd(string.format('vmap %s [SPC]', vim.g.spacevim_default_custom_leader))

  if not vim.g.spacevim_vimcompatible and vim.g.spacevim_enable_language_specific_leader then
    cmd('nmap , [SPC]l')
    cmd('xmap , [SPC]l')
  end

  -- Initialize mappings space
  vim.g._spacevim_mappings_space = vim.g._spacevim_mappings_space or {}
  vim.g._spacevim_mappings_space.w = vim.g._spacevim_mappings_space.w or {}
  vim.g._spacevim_mappings_space.t = vim.g._spacevim_mappings_space.t or { name = '+Toggles' }
  vim.g._spacevim_mappings_space.t.h = vim.g._spacevim_mappings_space.t.h or { name = '+Toggles highlight' }
  vim.g._spacevim_mappings_space.t.m = vim.g._spacevim_mappings_space.t.m or { name = '+modeline' }
  vim.g._spacevim_mappings_space.T = vim.g._spacevim_mappings_space.T or { name = '+UI toggles/themes' }
  vim.g._spacevim_mappings_space.a = vim.g._spacevim_mappings_space.a or { name = '+Applications' }
  vim.g._spacevim_mappings_space.b = vim.g._spacevim_mappings_space.b or { name = '+Buffers' }
  vim.g._spacevim_mappings_space.f = vim.g._spacevim_mappings_space.f or { name = '+Files' }
  vim.g._spacevim_mappings_space.j = vim.g._spacevim_mappings_space.j or { name = '+Jump/Join/Split' }
  vim.g._spacevim_mappings_space.m = vim.g._spacevim_mappings_space.m or { name = '+Major-mode' }
  vim.g._spacevim_mappings_space.w = vim.g._spacevim_mappings_space.w or { name = '+Windows' }
  vim.g._spacevim_mappings_space.p = vim.g._spacevim_mappings_space.p or { name = '+Projects/Packages' }
  vim.g._spacevim_mappings_space.h = vim.g._spacevim_mappings_space.h or { name = '+Help' }
  vim.g._spacevim_mappings_space.n = vim.g._spacevim_mappings_space.n or { name = '+Narrow/Numbers' }
  vim.g._spacevim_mappings_space.q = vim.g._spacevim_mappings_space.q or { name = '+Quit' }
  vim.g._spacevim_mappings_space.l = vim.g._spacevim_mappings_space.l or { name = '+Language Specified' }
  vim.g._spacevim_mappings_space.s = vim.g._spacevim_mappings_space.s or { name = '+Searching/Symbol' }
  vim.g._spacevim_mappings_space.r = vim.g._spacevim_mappings_space.r or { name = '+Registers/rings/resume' }
  vim.g._spacevim_mappings_space.d = vim.g._spacevim_mappings_space.d or { name = '+Debug' }
  vim.g._spacevim_mappings_space.F = vim.g._spacevim_mappings_space.F or { name = '+Tabs' }
  vim.g._spacevim_mappings_space.e = vim.g._spacevim_mappings_space.e or { name = '+Errors/Encoding' }
  vim.g._spacevim_mappings_space.B = vim.g._spacevim_mappings_space.B or { name = '+Global buffers' }
  vim.g._spacevim_mappings_space.f.v = vim.g._spacevim_mappings_space.f.v or { name = '+Vim/SpaceVim' }
  vim.g._spacevim_mappings_space.i = vim.g._spacevim_mappings_space.i or { name = '+Insertion' }
  vim.g._spacevim_mappings_space.i.l = vim.g._spacevim_mappings_space.i.l or { name = '+Lorem-ipsum' }
  vim.g._spacevim_mappings_space.i.p = vim.g._spacevim_mappings_space.i.p or { name = '+Passwords/Picker' }
  vim.g._spacevim_mappings_space.i.U = vim.g._spacevim_mappings_space.i.U or { name = '+UUID' }
  vim.g._spacevim_mappings_space.h.d = vim.g._spacevim_mappings_space.h.d or { name = '+help describe' }

  -- Windows: SPC 1-9
  for i = 1, 9 do
    M.def('nnoremap', { tostring(i) },
      'call SpaceVim#layers#core#statusline#jump(' .. i .. ')',
      'window-' .. i, 1)
  end

  -- Alternate window
  vim.g._spacevim_mappings_space.w['<Tab>'] = { 'wincmd w', 'alternate-window' }
  cmd('nnoremap <silent> [SPC]w<tab> :wincmd w<cr>')
  call('SpaceVim#mapping#menu', 'alternate-window', '[SPC]w<Tab>', 'wincmd w')

  -- Window layout toggle
  M.def('nnoremap', { 'w', '+' },
    'call v:lua.require("spacevim.mapping.space").windows_layout_toggle()',
    'windows-layout-toggle', 1)

  -- Window transient state
  M.def('nnoremap', { 'w', '.' },
    'call v:lua.require("spacevim.mapping.space").windows_transient_state()',
    'buffer-transient-state', 1)

  -- Close window
  M.def('nnoremap', { 'w', 'd' }, 'close', 'close-current-windows', 1)
  M.def('nnoremap', { 'w', 'f' }, 'setlocal scrollbind!', 'toggle-follow-mode', 1)
  M.def('nnoremap', { 'w', 'D' }, 'ChooseWin | close | wincmd w', 'delete-window-(other-windows)', 1)
  M.def('nnoremap', { 'w', 'F' }, 'tabnew', 'create-new-tab', 1)

  -- Window navigation
  M.def('nnoremap', { 'w', 'h' }, 'wincmd h', 'window-left', 1)
  M.def('nnoremap', { 'w', 'j' }, 'wincmd j', 'window-down', 1)
  M.def('nnoremap', { 'w', 'k' }, 'wincmd k', 'window-up', 1)
  M.def('nnoremap', { 'w', 'l' }, 'wincmd l', 'window-right', 1)
  M.def('nnoremap', { 'w', 'x' }, 'wincmd x', 'window-switch-placement', 1)

  -- Window move
  M.def('nnoremap', { 'w', 'H' }, 'wincmd H', 'window-far-left', 1)
  M.def('nnoremap', { 'w', 'J' }, 'wincmd J', 'window-far-down', 1)
  M.def('nnoremap', { 'w', 'K' }, 'wincmd K', 'window-far-up', 1)
  M.def('nnoremap', { 'w', 'L' }, 'wincmd L', 'window-far-right', 1)

  -- Maximize/minimize
  M.def('nnoremap', { 'w', 'm' },
    'call v:lua.require("spacevim.mapping.space").maximize_minimize_win()',
    'maximize/minimize window', 1)

  -- Swap window
  M.def('nnoremap', { 'w', 'M' },
    "execute eval(\"winnr('$')<=2 ? 'wincmd x' : 'ChooseWinSwap'\")",
    'swap window', 1)

  -- Other tabs
  M.def('nnoremap', { 'w', 'o' }, 'tabnext', 'other-tabs', 1)

  -- Split windows
  M.def('nnoremap', { 'w', '/' }, 'belowright vsplit | wincmd w', 'split-windows-right', 1)
  M.def('nnoremap', { 'w', 'v' }, 'belowright vsplit | wincmd w', 'split-windows-right', 1)
  M.def('nnoremap', { 'w', '-' }, 'bel split | wincmd w', 'split-windows-below', 1)
  M.def('nnoremap', { 'w', 's' }, 'bel split | wincmd w', 'split-windows-below', 1)
  M.def('nnoremap', { 'w', 'S' }, 'bel split', 'split-focus-windows-below', 1)
  M.def('nnoremap', { 'w', 'V' }, 'bel vs', 'split-window-right-focus', 1)
  M.def('nnoremap', { 'w', '=' }, 'wincmd =', 'balance-windows', 1)

  -- Layout
  M.def('nnoremap', { 'w', '2' }, 'silent only | vs | wincmd w', 'layout-double-columns', 1)
  M.def('nnoremap', { 'w', '3' }, 'silent only | vs | vs | wincmd H', 'layout-three-columns', 1)

  -- Cycle windows
  M.def('nnoremap', { 'w', 'w' }, 'wincmd w', 'cycle and focus between windows', 1)
  M.def('nnoremap', { 'w', 'W' }, 'ChooseWin', 'select window', 1)

  -- Undo/redo window
  M.def('nnoremap', { 'w', 'u' }, 'call SpaceVim#plugins#windowsmanager#UndoQuitWin()', 'undo quieted window', 1)
  M.def('nnoremap', { 'w', 'U' }, 'call SpaceVim#plugins#windowsmanager#RedoQuitWin()', 'redo quieted window', 1)

  -- Buffer navigation
  M.def('nnoremap', { 'b', 'n' },
    'call v:lua.require("spacevim.mapping.space").next_buffer()',
    'next-buffer', 1)
  M.def('nnoremap', { 'b', 'p' },
    'call v:lua.require("spacevim.mapping.space").previous_buffer()',
    'previous-buffer', 1)
  M.def('nnoremap', { 'b', 's' },
    'call v:lua.require("spacevim.mapping.space").switch_scratch_buffer()',
    'switch-to-scratch-buffer', 1)

  -- Toggle line number
  if vim.g.spacevim_relativenumber then
    cmd('nnoremap <silent> [SPC]tn :<C-u>setlocal nonumber! norelativenumber!<CR>')
    vim.g._spacevim_mappings_space.t.n = { 'setlocal nonumber! norelativenumber!', 'toggle-line-number' }
    call('SpaceVim#mapping#menu', 'toggle line number', '[SPC]tn', 'set nu!')
  else
    cmd('nnoremap <silent> [SPC]tn :<C-u>setlocal number!<CR>')
    vim.g._spacevim_mappings_space.t.n = { 'setlocal number!', 'toggle-line-number' }
    call('SpaceVim#mapping#menu', 'toggle line number', '[SPC]tn', 'setlocal number!')
  end

  -- Extend prefixes
  vim.g._spacevim_mappings_prefixs = vim.g._spacevim_mappings_prefixs or {}
  vim.g._spacevim_mappings_prefixs['[SPC]'] = vim.tbl_extend('force', vim.g._spacevim_mappings_prefixs['[SPC]'] or {}, vim.g._spacevim_mappings_space or {})

  -- Searching
  M.def('nnoremap', { 's', 's' },
    'call SpaceVim#plugins#flygrep#open({"input" : input("grep pattern:"), "files": bufname("%")})',
    'grep-in-current-buffer', 1)
  M.def('nnoremap', { 's', 'S' },
    'call SpaceVim#plugins#flygrep#open({"input" : expand("<cword>"), "files": bufname("%")})',
    'grep-cword-in-current-buffer', 1)
  M.def('nnoremap', { 's', 'b' },
    'call SpaceVim#plugins#flygrep#open({"input" : input("grep pattern:"), "files": "@buffers"})',
    'grep-in-all-buffers', 1)
  M.def('nnoremap', { 's', 'B' },
    'call SpaceVim#plugins#flygrep#open({"input" : expand("<cword>"), "files": "@buffers"})',
    'grep-cword-in-all-buffers', 1)
  M.def('nnoremap', { 's', 'd' },
    'call SpaceVim#plugins#flygrep#open({"input" : input("grep pattern:"), "dir": fnamemodify(expand("%"), ":p:h")})',
    'grep-in-buffer-directory', 1)
  M.def('nnoremap', { 's', 'D' },
    'call SpaceVim#plugins#flygrep#open({"input" : expand("<cword>"), "dir": fnamemodify(expand("%"), ":p:h")})',
    'grep-cword-in-buffer-directory', 1)
  M.def('nnoremap', { 's', 'f' },
    'call SpaceVim#plugins#flygrep#open({"input" : input("grep pattern:"), "dir": input("arbitrary dir:", "", "dir")})',
    'grep-in-arbitrary-directory', 1)
  M.def('nnoremap', { 's', 'F' },
    'call SpaceVim#plugins#flygrep#open({"input" : expand("<cword>"), "dir": input("arbitrary dir:", "", "dir")})',
    'grep-cword-in-arbitrary-directory', 1)
  M.def('nnoremap', { 's', 'p' },
    'call SpaceVim#plugins#flygrep#open({\'input\' : input("grep pattern:"), \'dir\' : get(b:, "rootDir", getcwd())})',
    'grep-in-project', 1)

  -- Background search
  if vim.fn.has('nvim-0.7.0') == 1 then
    M.def('nnoremap', { 's', 'j' },
      "lua require('spacevim.plugin.searcher').find('', require('spacevim.mapping.search').default_tool())",
      'background-search-in-project', 1)
  else
    M.def('nnoremap', { 's', 'j' },
      'call SpaceVim#plugins#searcher#find("", SpaceVim#mapping#search#default_tool()[0])',
      'background-search-in-project', 1)
  end
  M.def('nnoremap', { 's', 'J' },
    'call SpaceVim#plugins#searcher#find(expand("<cword>"),SpaceVim#mapping#search#default_tool()[0])',
    'background-search-cwords-in-project', 1)
  M.def('nnoremap', { 's', 'l' }, 'call SpaceVim#plugins#searcher#list()', 'list-all-searching-results', 1)

  -- Flygrep
  if vim.g.spacevim_flygrep_next_version and vim.fn.has('nvim-0.10.0') == 1 then
    M.def('nnoremap', { 's', '/' }, 'FlyGrep', 'grep-on-the-fly', 1)
    M.def('nnoremap', { 's', 'P' },
      "lua require('flygrep').open({input = vim.fn.expand('<cword>')})",
      'grep-cword-in-project', 1)
  else
    M.def('nnoremap', { 's', '/' }, 'call SpaceVim#plugins#flygrep#open({})', 'grep-on-the-fly', 1)
    M.def('nnoremap', { 's', 'P' },
      'call SpaceVim#plugins#flygrep#open({\'input\' : expand("<cword>"), \'dir\' : get(b:, "rootDir", getcwd())})',
      'grep-cword-in-project', 1)
  end

  M.def('nnoremap', { 's', 'c' }, 'call SpaceVim#plugins#searcher#clear()', 'clear-search-results', 1)

  -- Tab key bindings
  M.def('nnoremap', { 'F', 'D' }, 'tabonly', 'close-other-tabs', 1)
  M.def('nnoremap', { 'F', 'n' }, 'tabnew', 'create-new-tab', 1)
  M.def('nnoremap', { 'F', 'd' }, 'tabclose', 'close-current-tab', 1)

  -- Iedit
  if vim.fn.has('nvim-0.7.0') == 1 then
    cmd("nnoremap <silent> <plug>SpaceVim-plugin-iedit :lua require('spacevim.plugin.iedit').start()<cr>")
    cmd("xnoremap <silent> <plug>SpaceVim-plugin-iedit :lua require('spacevim.plugin.iedit').start(1)<cr>")
  else
    cmd("nnoremap <silent> <plug>SpaceVim-plugin-iedit :call SpaceVim#plugins#iedit#start()<cr>")
    cmd("xnoremap <silent> <plug>SpaceVim-plugin-iedit :call SpaceVim#plugins#iedit#start(1)<cr>")
  end
  M.def('nmap', { 's', 'e' }, '<plug>SpaceVim-plugin-iedit', 'start-iedit-with-all-matches', false, true)
  M.def('nnoremap', { 's', 'E' }, 'call SpaceVim#plugins#iedit#start({"selectall" : 0})', 'start-iedit-with-current-match', 1)

  -- Highlight
  M.def('nnoremap', { 's', 'H' }, 'call SpaceVim#plugins#highlight#start(1)', 'highlight-all-symbols', 1)
  M.def('nnoremap', { 's', 'h' }, 'call SpaceVim#plugins#highlight#start(0)', 'highlight-current-symbols', 1)

  -- Help
  M.def('nnoremap', { 'h', 'd', 'k' }, 'call SpaceVim#plugins#help#describe_key()', 'describe-key-bindings', 1)
  M.def('nnoremap', { 'h', 'd', 't' },
    'call v:lua.require("spacevim.mapping.space").describe_current_time()',
    'describe-current-time', 1)

  -- Applications
  if vim.fn.has('nvim-0.7.0') == 1 then
    M.def('nnoremap', { 'a', 'o' }, 'lua require("spacevim.plugin.todo").list()', 'open-todo-manager', 1)
  else
    M.def('nnoremap', { 'a', 'o' }, 'call SpaceVim#plugins#todo#list()', 'open-todo-manager', 1)
  end
  if vim.fn.has('nvim-0.9.5') == 1 then
    M.def('nnoremap', { 'a', 'r' }, 'lua require("spacevim.plugin.record-key").toggle()', 'toggle-record-keyboard', 1)
  end

  -- Search tool groups
  local search_tools_groups = {
    { 'a', '+ag' }, { 'g', '+grep' }, { 'G', '+git grep' },
    { 'k', '+ack' }, { 'r', '+rg' }, { 'i', '+findstr' }, { 't', '+pt' },
  }
  for _, group in ipairs(search_tools_groups) do
    vim.g._spacevim_mappings_space.s[group[1]] = { name = group[2] }
  end

  -- Search tool specific bindings
  local search_tools_list = { 'a', 'g', 'G', 'k', 'r', 'i', 't' }
  for _, tool_key in ipairs(search_tools_list) do
    local scopes = { 'b', 'B', 'd', 'D', 'p', 'P', 'f', 'F' }
    for _, scope in ipairs(scopes) do
      local tool_name_map = { a = 'ag', g = 'grep', G = 'git-grep', k = 'ack', r = 'rg', i = 'findstr', t = 'pt' }
      local desc = 'search ' .. (scope == 'B' and 'cursor word ' or '') .. 'with ' .. tool_name_map[tool_key]
      M.def('nnoremap', { 's', tool_key, scope },
        'call SpaceVim#mapping#search#grep("' .. tool_key .. '", "' .. scope .. '")',
        desc, 1)
    end
    -- Background search
    local tool_cmd_map = { a = 'ag', g = 'grep', k = 'ack', r = 'rg', i = 'findstr', t = 'pt' }
    if tool_cmd_map[tool_key] then
      M.def('nnoremap', { 's', tool_key, 'j' },
        'call SpaceVim#plugins#searcher#find("", "' .. tool_cmd_map[tool_key] .. '")',
        'Background search in project with ' .. tool_cmd_map[tool_key], 1)
      M.def('nnoremap', { 's', tool_key, 'J' },
        'call SpaceVim#plugins#searcher#find(expand("<cword>"), "' .. tool_cmd_map[tool_key] .. '")',
        'Background search cursor words in project with ' .. tool_cmd_map[tool_key], 1)
    end
  end
end

-- Helper functions (exposed for v:lua calls)

function M.windows_layout_toggle()
  if fn.winnr('$') ~= 2 then
    vim.cmd('echohl WarningMsg | echom "Can\'t toggle window layout when the number of windows isn\'t two." | echohl None')
  else
    local b
    if fn.winnr() == 1 then
      b = fn.winbufnr(2)
    else
      b = fn.winbufnr(1)
    end
    if fn.winwidth(1) == vim.o.columns then
      vim.cmd('only | vsplit')
    else
      vim.cmd('only | split')
    end
    vim.cmd('b' .. b)
    vim.cmd('wincmd w')
  end
end

function M.next_buffer()
  local ok = pcall(vim.cmd, 'bnext')
  if not ok then
    vim.cmd('echohl WarningMsg | echo "no listed buffer" | echohl None')
  end
end

function M.previous_buffer()
  local ok = pcall(vim.cmd, 'bp')
  if not ok then
    vim.cmd('echohl WarningMsg | echo "no listed buffer" | echohl None')
  end
end

function M.maximize_minimize_win()
  if WIN.win_count() == 1 and vim.t._maximize_previous_win and fn.tabpagenr('$') > 1 then
    vim.cmd('tabclose')
    if fn.exists('*win_getid') == 1 then
      fn.win_gotoid(maximize_previous_winid)
    else
      if fn.tabpagenr('$') > 1 and fn.tabpagenr() ~= fn.tabpagenr('$') then
        vim.cmd('tabprevious')
      end
    end
  else
    if fn.exists('*win_getid') == 1 then
      maximize_previous_winid = fn.win_getid()
    end
    vim.cmd('tab split')
    vim.t._maximize_previous_win = fn.tabpagenr()
  end
end

function M.switch_scratch_buffer()
  if not vim.fn.bufexists(scratch_buffer) or vim.fn.getbufvar(scratch_buffer, '&filetype', '') ~= '' then
    scratch_buffer = BUF.create_buf(1, 1)
  end
  vim.cmd('buffer ' .. scratch_buffer)
end

function M.windows_transient_state()
  local state = require('spacevim.api').import('transient_state')
  state.set_title('Buffer Selection Transient State')
  state.defind_keys({
    layout = 'vertical split',
    left = {},
    right = {
      {
        key = 'n',
        desc = 'next buffer',
        func = '',
        cmd = 'bnext',
        exit = 0,
      },
    },
  })
  state.open()
end

function M.describe_current_time()
  local time = TIME.current_date() .. ' ' .. TIME.current_time()
  print(time)
end

return M

