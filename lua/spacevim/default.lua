--=============================================================================
-- default.lua --- default options in SpaceVim
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')
local fn = vim.fn
local cmd = vim.cmd
local opt = vim.opt
local call = vim.call

function M.options()
  logger.info('init default vim options')
  vim.o.backspace = 'indent,eol,start'
  opt.nrformats:remove({ 'octal' })
  vim.o.listchars = 'tab:-> ,eol:↵,trail:·,extends:↷,precedes:↶'
  vim.o.fillchars = 'vert:│,fold:·'
  vim.o.laststatus = 2
  vim.o.showcmd = false
  vim.o.shada = ''
  vim.o.autoindent = true
  vim.o.linebreak = true
  vim.o.wildmenu = true
  vim.o.number = true
  vim.o.autoread = true
  vim.o.backup = true
  vim.o.undofile = true
  vim.o.undolevels = 1000

  -- data directories
  vim.g.data_dir = vim.g.spacevim_data_dir .. 'SpaceVim/'
  vim.g.backup_dir = vim.g.data_dir .. 'backup//'
  vim.g.swap_dir = vim.g.data_dir .. 'swap//'
  vim.g.undo_dir = vim.g.data_dir .. 'undofile//'
  vim.g.conf_dir = vim.g.data_dir .. 'conf'

  for _, dir in ipairs({ vim.g.data_dir, vim.g.backup_dir, vim.g.swap_dir, vim.g.undo_dir, vim.g.conf_dir }) do
    if fn.finddir(dir) == '' then
      pcall(fn.mkdir, dir, 'p', '0700')
    end
  end
  vim.o.undodir = vim.g.undo_dir
  vim.o.backupdir = vim.g.backup_dir
  vim.o.directory = vim.g.swap_dir
  vim.g.data_dir = nil
  vim.g.backup_dir = nil
  vim.g.swap_dir = nil
  vim.g.undo_dir = nil
  vim.g.conf_dir = nil

  vim.o.writebackup = false
  vim.o.matchtime = 0
  vim.o.ruler = false
  vim.o.showmatch = true
  vim.o.showmode = true
  vim.o.completeopt = 'menu,menuone,longest'
  vim.o.complete = '.,w,b,u,t'
  vim.o.pumheight = 15
  vim.o.scrolloff = 1
  vim.o.sidescrolloff = 5
  opt.display = opt.display + { 'lastline' }
  vim.o.incsearch = true
  vim.o.hlsearch = true
  vim.o.wildignorecase = true
  vim.o.mouse = 'nv'
  vim.o.hidden = true
  vim.o.ttimeout = true
  vim.o.ttimeoutlen = 50
  opt.shortmess:append('c')
  opt.shortmess:append('s')
  vim.o.wrap = false
  vim.o.foldtext = 'SpaceVim#default#Customfoldtext()'

  -- disable all bell
  vim.o.belloff = 'all'

  logger.info('options init done')
end

function M.layers()
  logger.info('init default layer list.')
  require('spacevim.layer').load('autocomplete')
  require('spacevim.layer').load('checkers')
  require('spacevim.layer').load('format')
  require('spacevim.layer').load('edit')
  require('spacevim.layer').load('ui')
  require('spacevim.layer').load('core')
  require('spacevim.layer').load('core#banner')
  require('spacevim.layer').load('core#statusline')
  require('spacevim.layer').load('core#tabline')
  logger.info('layer list init done')
end

function M.keyBindings(...)
  logger.info('init default key bindings.')
  -- clipboard mappings (clipboard#yank/paste are still vim functions)
  cmd('xnoremap <silent> <Leader>y :<C-u>call clipboard#yank()<cr>')
  cmd([[nnoremap <expr> <Leader>p clipboard#paste('p')]])
  cmd([[nnoremap <expr> <Leader>P clipboard#paste('P')]])
  cmd([[xnoremap <expr> <Leader>p clipboard#paste('p')]])
  cmd([[xnoremap <expr> <Leader>P clipboard#paste('P')]])

  vim.g._spacevim_mappings.p = { 'normal! "+p', 'paste after here' }
  vim.g._spacevim_mappings.P = { 'normal! "+P', 'paste before here' }

  cmd('xnoremap <silent><Leader>Y :<C-u>call SpaceVim#plugins#pastebin#paste()<CR>')

  -- quickfix list movement
  vim.g._spacevim_mappings.q = { name = '+Quickfix movement' }
  call('SpaceVim#mapping#def', 'nnoremap', '<Leader>qn', ':cnext<CR>',
    'Jump to next quickfix list position', 'cnext', 'Next quickfix list')
  call('SpaceVim#mapping#def', 'nnoremap', '<Leader>qp', ':cprev<CR>',
    'Jump to previous quickfix list position', 'cprev', 'Previous quickfix list')
  call('SpaceVim#mapping#def', 'nnoremap', '<Leader>ql', ':copen<CR>',
    'Open quickfix list window', 'copen', 'Open quickfix list window')
  call('SpaceVim#mapping#def', 'nnoremap <silent>', '<Leader>qr', 'q',
    'Toggle recording', '', 'Toggle recording mode')
  call('SpaceVim#mapping#def', 'nnoremap <silent>', '<Leader>qc', ':call setqflist([])<CR>',
    'Clear quickfix list', '', 'Clear quickfix list')

  -- window switch
  cmd([[nnoremap <silent> <Tab> :<C-u>call SpaceVim#mapping#tab()<CR>]])
  cmd([[nnoremap <silent> <S-Tab> :<C-u>call SpaceVim#mapping#shift_tab()<CR>]])

  -- Use Q to switch to Ex mode (disabled, use gq for formatting)
  cmd('nnoremap Q <Nop>')

  -- select all
  cmd('nnoremap <M-a> ggVG')

  -- Make Y behave like C and D
  cmd('nnoremap Y y$')
end

function M.UseSimpleMode()
  -- placeholder
end

function M.Customfoldtext()
  local fs = vim.v.foldstart
  while fn.getline(fs):match('^%s*$') do
    fs = fn.nextnonblank(fs + 1)
  end
  local line
  if fs > vim.v.foldend then
    line = fn.getline(vim.v.foldstart)
  else
    line = fn.substitute(fn.getline(fs), '\t', string.rep(' ', vim.o.tabstop), 'g')
  end

  local foldsymbol = '+'
  local repeatsymbol = '-'
  local prefix = foldsymbol .. ' '

  local w = fn.winwidth(0) - vim.o.foldcolumn - (vim.o.number and 8 or 0)
  local foldSize = 1 + vim.v.foldend - vim.v.foldstart
  local foldSizeStr = ' ' .. foldSize .. ' lines '
  local foldLevelStr = string.rep('+--', vim.v.foldlevel)
  local lineCount = fn.line('$')
  local foldPercentage = string.format('[%.1f', (foldSize * 1.0) / lineCount * 100) .. '%] '
  local expansionString = string.rep(repeatsymbol, w - fn.strwidth(prefix .. foldSizeStr .. line .. foldLevelStr .. foldPercentage))
  return prefix .. line .. expansionString .. foldSizeStr .. foldPercentage .. foldLevelStr
end

return M

