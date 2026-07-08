--=============================================================================
-- leader.lua --- mapping leader definition file for SpaceVim (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Shidong Wang < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')
local call = vim.call
local fn = vim.fn
local cmd = vim.cmd

--- Define windows leader key bindings
--- @param key string the windows leader key
function M.defindWindowsLeader(key)
  if key == nil or key == '' then return end
  cmd('nnoremap <silent><nowait> [Window] :<c-u>LeaderGuide "' .. key .. '"<CR>')
  cmd('nmap ' .. key .. ' [Window]')

  vim.g._spacevim_mappings_windows = vim.g._spacevim_mappings_windows or {}

  cmd('nnoremap <silent> [Window]v :<C-u>split<CR>')
  vim.g._spacevim_mappings_windows.v = { 'split', 'split-window' }

  cmd('nnoremap <silent> [Window]V :<C-u>split +bp<CR>')
  vim.g._spacevim_mappings_windows.V = { 'split +bp', 'split-previous-buffer' }

  cmd('nnoremap <silent> [Window]g :<C-u>vsplit<CR>')
  vim.g._spacevim_mappings_windows.g = { 'vsplit', 'vsplit-window' }

  cmd('nnoremap <silent> [Window]G :<C-u>vsplit +bp<CR>')
  vim.g._spacevim_mappings_windows.G = { 'vsplit +bp', 'vsplit-previous-buffer' }

  cmd('nnoremap <silent> [Window]t :<C-u>tabnew<CR>')
  vim.g._spacevim_mappings_windows.t = { 'tabnew', 'create-new-tab' }

  cmd('nnoremap <silent> [Window]o :<C-u>only | doautocmd WinEnter<CR>')
  vim.g._spacevim_mappings_windows.o = { 'only | doautocmd WinEnter', 'close-other-windows' }

  cmd('nnoremap <silent> [Window]x :<C-u>call SpaceVim#mapping#BufferEmpty()<CR>')
  vim.g._spacevim_mappings_windows.x = { 'call SpaceVim#mapping#BufferEmpty()', 'empty-current-buffer' }

  cmd('nnoremap <silent> [Window]\\ :<C-u>b#<CR>')
  vim.g._spacevim_mappings_windows['\\'] = { 'b#', 'switch-to-the-last-buffer' }

  cmd('nnoremap <silent> [Window]Q :<C-u>close<CR>')
  vim.g._spacevim_mappings_windows.Q = { 'close', 'close-current-windows' }

  cmd('nnoremap <silent> [Window]q :<C-u>call SpaceVim#mapping#close_current_buffer()<CR>')
  vim.g._spacevim_mappings_windows.q = { 'call SpaceVim#mapping#close_current_buffer()', 'delete-current-windows' }

  cmd('nnoremap <silent> [Window]c :<C-u>call SpaceVim#mapping#clear_buffers()<CR>')
  vim.g._spacevim_mappings_windows.c = { 'call SpaceVim#mapping#clear_buffers()', 'clear-all-the-buffers' }
end

--- Define denite leader key bindings
--- @param key string the denite leader key
function M.defindDeniteLeader(key)
  if key == nil or key == '' then return end
  if key == 'F' then
    cmd('nnoremap <leader>F F')
  end
  cmd('nnoremap <silent><nowait> [denite] :<c-u>LeaderGuide "' .. key .. '"<CR>')
  cmd('nmap ' .. key .. ' [denite]')

  vim.g._spacevim_mappings_denite = {}

  cmd('nnoremap <silent> [denite]r :<C-u>Denite -resume<CR>')
  vim.g._spacevim_mappings_denite.r = { 'Denite -resume', 'resume denite window' }

  cmd('nnoremap <silent> [denite]f :<C-u>Denite file_rec<cr>')
  vim.g._spacevim_mappings_denite.f = { 'Denite file_rec', 'file_rec' }

  cmd('nnoremap <silent> [denite]i :<C-u>Denite file_rec/git<cr>')
  vim.g._spacevim_mappings_denite.i = { 'Denite file_rec/git', 'git files' }

  cmd('nnoremap <silent> [denite]g :<C-u>Denite grep<cr>')
  vim.g._spacevim_mappings_denite.g = { 'Denite grep', 'denite grep' }

  cmd('nnoremap <silent> [denite]t :<C-u>Denite tag<CR>')
  vim.g._spacevim_mappings_denite.t = { 'Denite tag', 'denite tag' }

  cmd('nnoremap <silent> [denite]T :<C-u>Denite tag:include<CR>')
  vim.g._spacevim_mappings_denite.T = { 'Denite tag/include', 'denite tag/include' }

  cmd('nnoremap <silent> [denite]j :<C-u>Denite jump<CR>')
  vim.g._spacevim_mappings_denite.j = { 'Denite jump', 'denite jump' }

  cmd('nnoremap <silent> [denite]h :<C-u>Denite neoyank<CR>')
  vim.g._spacevim_mappings_denite.h = { 'Denite neoyank', 'denite neoyank' }

  cmd('nnoremap <silent> [denite]<C-h> :<C-u>DeniteCursorWord help<CR>')
  vim.g._spacevim_mappings_denite['<C-h>'] = { 'DeniteCursorWord help', 'denite with cursor word help' }

  cmd('nnoremap <silent> [denite]o :<C-u>Denite -buffer-name=outline -auto-preview outline<CR>')
  vim.g._spacevim_mappings_denite.o = { 'Denite outline', 'denite outline' }

  cmd('nnoremap <silent> [denite]e :<C-u>Denite -buffer-name=register register<CR>')
  vim.g._spacevim_mappings_denite.e = { 'Denite register', 'denite register' }

  cmd('nnoremap <silent> [denite]<Space> :Denite menu:CustomKeyMaps<CR>')
  vim.g._spacevim_mappings_denite['<Space>'] = { 'Denite menu:CustomKeyMaps', 'denite customkeymaps' }
end

--- Get display name for a leader key
--- @param key string
--- @return string
function M.getName(key)
  if key == ' ' then
    return '[SPC]'
  elseif key == 'g' then
    return '[g]'
  elseif key == 'z' then
    return '[z]'
  elseif key == vim.g.spacevim_windows_leader then
    return '[WIN]'
  elseif key == '\\' then
    return '<leader>'
  else
    return ''
  end
end

--- Define all leader key prefixes
function M.defindKEYs()
  logger.debug('defind SPC h k prefixs')
  if not vim.g.spacevim_vimcompatible and vim.g.spacevim_windows_leader and vim.g.spacevim_windows_leader ~= '' then
    vim.g._spacevim_mappings_prefixs = vim.g._spacevim_mappings_prefixs or {}
    vim.g._spacevim_mappings_prefixs[vim.g.spacevim_windows_leader] = vim.tbl_extend('force', { name = '+Window prefix' }, vim.g._spacevim_mappings_windows or {})
  end
  vim.g._spacevim_mappings_prefixs = vim.g._spacevim_mappings_prefixs or {}
  vim.g._spacevim_mappings_prefixs['g'] = vim.tbl_extend('force', { name = '+g prefix' }, vim.g._spacevim_mappings_g or {})
  vim.g._spacevim_mappings_prefixs['z'] = vim.tbl_extend('force', { name = '+z prefix' }, vim.g._spacevim_mappings_z or {})
  local leader = vim.g.mapleader or '\\'
  vim.g._spacevim_mappings_prefixs[leader] = vim.tbl_extend('force', { name = '+Leader prefix' }, vim.g._spacevim_mappings or {})
end

return M

