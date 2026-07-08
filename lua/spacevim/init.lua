--=============================================================================
-- init.lua --- SpaceVim core initialization (Lua rewrite)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')
local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt
local call = vim.call

-- system api
local system = require('spacevim.api').import('system')
local file_api = require('spacevim.api').import('file')
local messletters = require('spacevim.api').import('messletters')

--=============================================================================
-- Public SpaceVim Options
--=============================================================================

local function init_options()
  -- version
  vim.g.spacevim_version = '2.5.0-dev'

  -- indent
  vim.g.spacevim_default_indent = 2
  vim.g.spacevim_expand_tab = 1
  vim.g.spacevim_if_ruby = 1
  vim.g.spacevim_enable_list_mode = 0
  vim.g.spacevim_lazy_conf_timeout = 200
  vim.g.spacevim_relativenumber = 1
  vim.g.spacevim_wrap_line = 0
  vim.g.spacevim_enable_bepo_layout = 0
  vim.g.spacevim_max_column = 120
  vim.g.spacevim_windisk_encoding = 'cp936'
  vim.g.spacevim_default_custom_leader = '<Space>'
  vim.g.spacevim_home_files_number = 6
  vim.g.spacevim_code_runner_focus = 0
  vim.g.spacevim_enable_guicolors = 0
  vim.g.spacevim_escape_key_binding = 'jk'
  vim.g.spacevim_file_searching_tools = {}
  vim.g.spacevim_enable_googlesuggest = 0
  vim.g.spacevim_windows_leader = 's'

  -- data dir
  local sep = file_api.separator
  vim.g.spacevim_data_dir = vim.env.XDG_CACHE_HOME ~= nil and vim.env.XDG_CACHE_HOME .. sep
    or vim.env.HOME .. sep .. '.cache' .. sep
  if fn.isdirectory(vim.g.spacevim_data_dir) == 0 then
    fn.mkdir(vim.g.spacevim_data_dir, 'p')
  end

  vim.g.spacevim_plugin_bundle_dir = vim.g.spacevim_data_dir .. 'vimfiles' .. sep

  -- leader guide
  vim.g.spacevim_realtime_leader_guide = 1
  vim.g.spacevim_leader_guide_theme = 'leaderguide'
  vim.g.spacevim_enable_key_frequency = 0

  -- autocomplete (nvim only, use nvim-cmp)
  vim.g.spacevim_autocomplete_method = 'nvim-cmp'

  -- lint
  vim.g.spacevim_lint_engine = 'neomake'

  -- guifont
  vim.g.spacevim_guifont = 'SauceCodePro Nerd Font Mono:h11'

  -- ycm
  vim.g.spacevim_enable_ycm = 0

  -- sidebar
  vim.g.spacevim_sidebar_width = 30

  -- snippet
  vim.g.spacevim_snippet_engine = 'neosnippet'
  vim.g.spacevim_enable_neocomplcache = 0

  -- cursorline
  vim.g.spacevim_enable_cursorline = 1

  -- statusline
  vim.g.spacevim_statusline_separator = 'nil'
  vim.g.spacevim_statusline_iseparator = 'nil'
  vim.g.spacevim_enable_statusline_bfpath = 0
  vim.g.spacevim_enable_statusline_tag = 1
  vim.g.spacevim_statusline_left = { 'winnr', 'filename', 'major mode', 'search count', 'syntax checking', 'minor mode lighters' }
  vim.g.spacevim_statusline_right = { 'fileformat', 'cursorpos', 'percentage' }
  vim.g.spacevim_statusline_unicode = 1
  vim.g.spacevim_enable_language_specific_leader = 1
  vim.g.spacevim_enable_statusline_mode = 0
  vim.g.spacevim_custom_color_palette = {}

  -- cursorcolumn
  vim.g.spacevim_enable_cursorcolumn = 0

  -- symbols
  vim.g.spacevim_error_symbol = '✖'
  vim.g.spacevim_warning_symbol = '⚠'
  vim.g.spacevim_info_symbol = messletters.circled_letter('i')

  -- terminal cursor
  vim.g.spacevim_terminal_cursor_shape = 2

  -- help language
  vim.g.spacevim_vim_help_language = 'en'
  vim.g.spacevim_language = ''

  -- server
  vim.g.spacevim_keep_server_alive = 1

  -- colorscheme
  vim.g.spacevim_colorscheme = 'gruvbox'
  vim.g.spacevim_colorscheme_bg = 'dark'
  vim.g.spacevim_colorscheme_default = 'desert'

  -- file manager
  vim.g.spacevim_filemanager = 'nerdtree'
  vim.g.spacevim_filetree_direction = 'right'
  vim.g.spacevim_sidebar_direction = ''

  -- plugin manager (dein for nvim)
  vim.g.spacevim_plugin_manager = 'dein'
  vim.g.spacevim_plugin_manager_processes = 16

  -- check install
  vim.g.spacevim_checkinstall = 1

  -- vimcompatible
  vim.g.spacevim_vimcompatible = 0

  -- debug
  vim.g.spacevim_enable_debug = 0
  vim.g.spacevim_auto_disable_touchpad = 1
  vim.g.spacevim_debug_level = 1
  vim.g.spacevim_hiddenfileinfo = 1
  vim.g.spacevim_gitcommit_pr_icon = ''
  vim.g.spacevim_gitcommit_issue_icon = ''

  -- buffer/windows index
  vim.g.spacevim_buffer_index_type = 4
  vim.g.spacevim_windows_index_type = 3
  vim.g.spacevim_enable_tabline_ft_icon = 0
  vim.g.spacevim_enable_os_fileformat_icon = 0
  vim.g.spacevim_github_username = ''
  vim.g.spacevim_windows_smartclose = 'q'

  -- plugins
  vim.g.spacevim_disabled_plugins = {}
  vim.g.spacevim_custom_plugins = {}
  vim.g.spacevim_filetype_icons = {}
  vim.g.spacevim_force_global_config = 0
  vim.g.spacevim_enable_powerline_fonts = 1
  vim.g.spacevim_lint_on_save = 1
  vim.g.spacevim_search_tools = { 'rg', 'ag', 'pt', 'ack', 'grep', 'findstr', 'git' }
  vim.g.spacevim_flygrep_next_version = false

  -- project rooter
  vim.g.spacevim_project_rooter_patterns = { '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/' }
  vim.g.spacevim_project_non_root = ''
  vim.g.spacevim_enable_projects_cache = 1
  vim.g.spacevim_projects_cache_num = 20
  vim.g.spacevim_project_auto_root = 1
  vim.g.spacevim_project_rooter_outermost = 1

  -- commandline prompt
  vim.g.spacevim_commandline_prompt = '>'

  -- todo
  vim.g.spacevim_todo_labels = { 'fixme', 'question', 'todo', 'idea' }
  vim.g.spacevim_todo_close_list = 0
  vim.g.spacevim_todo_prefix = '@'

  -- lint on the fly
  vim.g.spacevim_lint_on_the_fly = 0

  -- update retry
  vim.g.spacevim_update_retry_cnt = 3
  vim.g.spacevim_enable_vimfiler_welcome = 1
  vim.g.spacevim_autocomplete_parens = 1
  vim.g.spacevim_smartcloseignorewin = { '__Tagbar__', 'vimfiler:default' }
  vim.g.spacevim_smartcloseignoreft = {
    'tagbar', 'neo-tree', 'vimfiler', 'defx', 'NvimTree',
    'SpaceVimRunner', 'SpaceVimREPL', 'SpaceVimQuickFix',
    'HelpDescribe', 'VebuggerShell', 'VebuggerTerminal',
    'SpaceVimTabsManager', 'SpaceVimGitRemoteManager',
  }
  vim.g._spacevim_altmoveignoreft = { 'Tagbar', 'vimfiler' }
  vim.g._spacevim_mappings_space = {}
  vim.g._spacevim_mappings_prefixs = {}
  vim.g._spacevim_mappings_windows = {}
  vim.g._spacevim_statusline_fileformat = ''
  vim.g.spacevim_enable_javacomplete2_py = 0
  vim.g.spacevim_src_root = 'E:\\sources\\'
  vim.g.spacevim_hosts_url = 'https://raw.githubusercontent.com/racaljk/hosts/master/hosts'
  vim.g.spacevim_wildignore = '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,*.ttf,*.TTF,*.png,*/target/*,.git,.svn,.hg,.DS_Store,*.svg'
end

--=============================================================================
-- Private options
--=============================================================================

local function init_private_options()
  vim.g._spacevim_mappings = {}
  vim.g._spacevim_mappings_space_custom = {}
  vim.g._spacevim_mappings_space_custom_group_name = {}
  vim.g._spacevim_mappings_leader_custom = {}
  vim.g._spacevim_mappings_leader_custom_group_name = {}
  vim.g._spacevim_mappings_language_specified_space_custom = {}
  vim.g._spacevim_mappings_lang_group_name = {}
  vim.g._spacevim_neobundle_installed = 0
  vim.g._spacevim_dein_installed = 0
  vim.g._spacevim_vim_plug_installed = 0

  -- leader guide defaults
  if vim.g.leaderGuide_vertical == nil then
    vim.g.leaderGuide_vertical = 0
  end
  vim.g.spacevim_leader_guide_vertical = 0

  if vim.g.leaderGuide_sort_horizontal == nil then
    vim.g.leaderGuide_sort_horizontal = 0
  end
  vim.g.spacevim_leader_guide_sort_horizontal = 0

  if vim.g.leaderGuide_position == nil then
    vim.g.leaderGuide_position = 'botright'
  end
  vim.g.spacevim_leader_guide_position = 'botright'

  if vim.g.leaderGuide_run_map_on_popup == nil then
    vim.g.leaderGuide_run_map_on_popup = 1
  end
  vim.g.spacevim_leader_guide_run_map_on_popup = 1

  if vim.g.leaderGuide_hspace == nil then
    vim.g.leaderGuide_hspace = 5
  end
  vim.g.spacevim_leader_guide_hspace = 5

  if vim.g.leaderGuide_flatten == nil then
    vim.g.leaderGuide_flatten = 1
  end
  vim.g.spacevim_leader_guide_flatten = 1

  if vim.g.leaderGuide_default_group_name == nil then
    vim.g.leaderGuide_default_group_name = ''
  end
  vim.g.spacevim_leader_guide_default_group_name = ''

  if vim.g.leaderGuide_max_size == nil then
    vim.g.leaderGuide_max_size = 0
  end
  vim.g.spacevim_leader_guide_max_size = 0

  if vim.g.leaderGuide_submode_mappings == nil then
    vim.g.leaderGuide_submode_mappings = { ['<C-C>'] = 'win_close', ['n'] = 'page_down', ['p'] = 'page_up', ['u'] = 'undo' }
  end
  vim.g.spacevim_leader_guide_submode_mappings = { ['<C-C>'] = 'win_close' }

  if vim.g.LanguageClient_serverCommands == nil then
    vim.g.LanguageClient_serverCommands = {}
  end
end

--=============================================================================
-- Mapping prefix definitions
--=============================================================================

local function init_mapping_prefixs()
  vim.g._spacevim_mappings_prefixs['[SPC]'] = { name = '+SPC prefix' }
  vim.g._spacevim_mappings_space.t = { name = '+Toggles' }
  vim.g._spacevim_mappings_space.t.h = { name = '+Toggles highlight' }
  vim.g._spacevim_mappings_space.t.m = { name = '+modeline' }
  vim.g._spacevim_mappings_space.T = { name = '+UI toggles/themes' }
  vim.g._spacevim_mappings_space.a = { name = '+Applications' }
  vim.g._spacevim_mappings_space.b = { name = '+Buffers' }
  vim.g._spacevim_mappings_space.f = { name = '+Files' }
  vim.g._spacevim_mappings_space.j = { name = '+Jump/Join/Split' }
  vim.g._spacevim_mappings_space.m = { name = '+Major-mode' }
  vim.g._spacevim_mappings_space.w = { name = '+Windows' }
  vim.g._spacevim_mappings_space.p = { name = '+Projects/Packages' }
  vim.g._spacevim_mappings_space.h = { name = '+Help' }
  vim.g._spacevim_mappings_space.n = { name = '+Narrow/Numbers' }
  vim.g._spacevim_mappings_space.q = { name = '+Quit' }
  vim.g._spacevim_mappings_space.l = { name = '+Language Specified' }
  vim.g._spacevim_mappings_space.s = { name = '+Searching/Symbol' }
  vim.g._spacevim_mappings_space.r = { name = '+Registers/rings/resume' }
  vim.g._spacevim_mappings_space.d = { name = '+Debug' }
  vim.g._spacevim_mappings_space.F = { name = '+Tabs' }
  vim.g._spacevim_mappings_space.e = { name = '+Errors/Encoding' }
  vim.g._spacevim_mappings_space.B = { name = '+Global buffers' }
  vim.g._spacevim_mappings_space.f.v = { name = '+Vim/SpaceVim' }
  vim.g._spacevim_mappings_space.i = { name = '+Insertion' }
  vim.g._spacevim_mappings_space.i.l = { name = '+Lorem-ipsum' }
  vim.g._spacevim_mappings_space.i.p = { name = '+Passwords/Picker' }
  vim.g._spacevim_mappings_space.i.U = { name = '+UUID' }
end

--=============================================================================
-- Commands
--=============================================================================

local function init_commands()
  cmd('command! -nargs=1 LeaderGuide call SpaceVim#mapping#guide#start_by_prefix("0", <args>)')
  cmd('command! -range -nargs=1 LeaderGuideVisual call SpaceVim#mapping#guide#start_by_prefix("1", <args>)')
end

--=============================================================================
-- parser_argv: parse command line arguments
--=============================================================================

local function parser_argv()
  local argv = vim.v.argv
  if argv then
    logger.info('v:argv is:' .. vim.inspect(argv))
    if #argv == 1 or (#argv == 2 and fn.index(argv, '--embed') == 1) then
      return { 0 }
    elseif fn.index(argv, '--embed') ~= -1 then
      local last = argv[#argv]
      if last:match('/$') then
        local f = fn.fnamemodify(fn.expand(last), ':p')
        if fn.isdirectory(f) == 1 then
          return { 1, f }
        else
          return { 1, fn.getcwd() }
        end
      elseif last == '.' then
        return { 1, fn.getcwd() }
      elseif fn.isdirectory(fn.expand(last)) == 1 then
        return { 1, fn.fnamemodify(fn.expand(last), ':p') }
      elseif fn.filereadable(last) == 1 then
        return { 2, argv }
      elseif last == '-p' and argv[#argv - 1] == '--embed' then
        return { 0 }
      elseif last ~= '--embed' and (argv[#argv - 1] or '') ~= '--cmd' then
        return { 2, last }
      else
        return { 0 }
      end
    elseif fn.index(argv, '-d') ~= -1 then
      return { 2, 'diff mode, use default arguments:' .. vim.inspect(argv) }
    elseif argv[#argv]:match('/$') then
      local f = fn.fnamemodify(fn.expand(argv[#argv]), ':p')
      if fn.isdirectory(f) == 1 then
        return { 1, f }
      else
        return { 1, fn.getcwd() }
      end
    elseif argv[#argv] == '.' then
      return { 1, fn.getcwd() }
    elseif fn.isdirectory(fn.expand(argv[#argv])) == 1 then
      return { 1, fn.fnamemodify(fn.expand(argv[#argv]), ':p') }
    elseif #argv == 3 and argv[#argv] == 'VIM' and argv[#argv - 1] == '--servername' then
      return { 0 }
    else
      return { 2, argv }
    end
  else
    logger.info(string.format('argc is %s, argv is %s, line2byte is %s', vim.inspect(fn.argc()), vim.inspect(fn.argv()), vim.inspect(fn.line2byte('$'))))
    if fn.argc() == 0 and fn.line2byte('$') == -1 then
      return { 0 }
    elseif fn.argv(0):match('/$') then
      local f = fn.fnamemodify(fn.expand(fn.argv(0)), ':p')
      if fn.isdirectory(f) == 1 then
        return { 1, f }
      else
        return { 1, fn.getcwd() }
      end
    elseif fn.argv(0) == '.' then
      return { 1, fn.getcwd() }
    elseif fn.isdirectory(fn.expand(fn.argv(0))) == 1 then
      return { 1, fn.fnamemodify(fn.expand(fn.argv(0)), ':p') }
    else
      return { 2, vim.inspect(fn.argv()) }
    end
  end
end

--=============================================================================
-- begin(): start SpaceVim initialization
--=============================================================================

function M.begin()
  -- set language to English
  pcall(function()
    cmd('lan mes en_US.UTF-8')
  end)

  -- set encoding to utf-8
  vim.o.fileencoding = 'utf-8'
  vim.o.fileencodings = 'utf-8,ucs-bom,gb18030,gbk,gb2312,cp936'

  -- parse argvs
  local status = parser_argv()
  logger.info('startup status:' .. vim.inspect(status))

  vim.g._spacevim_enter_dir = fn.fnamemodify(fn.getcwd(), ':~')

  if status[1] == 0 then
    logger.info('Startup with no argv, current dir is used: ' .. vim.g._spacevim_enter_dir)
    local group = api.nvim_create_augroup('SPwelcome', { clear = true })
    api.nvim_create_autocmd('VimEnter', { group = group, callback = function()
      M.welcome()
    end })
  elseif status[1] == 1 then
    vim.g._spacevim_enter_dir = fn.fnamemodify(status[2], ':~')
    logger.info('Startup with directory: ' .. vim.g._spacevim_enter_dir)
    local group = api.nvim_create_augroup('SPwelcome', { clear = true })
    api.nvim_create_autocmd('VimEnter', { group = group, callback = function()
      M.welcome()
    end })
  else
    logger.info('Startup with argv: ' .. vim.inspect(status[1]))
  end

  -- load default options via Lua
  require('spacevim.default').options()

  -- load default layers via Lua
  require('spacevim.default').layers()

  -- load commands via Lua
  require('spacevim.command').load()
end

--=============================================================================
-- lazy_end(): lazy initialization (called via timer in end())
--=============================================================================

local function lazy_end()
  if vim.g.spacevim_vimcompatible then
    vim.g.spacevim_windows_leader = ''
    vim.g.spacevim_windows_smartclose = ''
  end

  if not vim.g.spacevim_vimcompatible then
    cmd('cnoremap <C-f> <Right>')
    cmd('cnoremap <C-a> <Home>')
    cmd('cnoremap <C-b> <Left>')
    cmd([[cnoremap <expr> <C-k> repeat('<Delete>', strchars(getcmdline()) - getcmdpos() + 1)]])

    if vim.g.spacevim_escape_key_binding and vim.g.spacevim_escape_key_binding ~= '' then
      cmd(string.format('inoremap %s <esc>', vim.g.spacevim_escape_key_binding))
    end
  end

  -- server connect (still vim script, use vim.call)
  call('SpaceVim#server#connect')

  if vim.g.spacevim_enable_neocomplcache then
    vim.g.spacevim_autocomplete_method = 'neocomplcache'
  end

  if vim.g.spacevim_enable_ycm then
    if fn.has('python') == 1 or fn.has('python3') == 1 then
      vim.g.spacevim_autocomplete_method = 'ycm'
    else
      logger.warn('YCM need +python or +python3 support, force to using ' .. vim.g.spacevim_autocomplete_method)
    end
  end

  if vim.g.spacevim_keep_server_alive then
    call('SpaceVim#server#export_server')
  end

  if vim.g.spacevim_windows_leader and vim.g.spacevim_windows_leader ~= '' then
    call('SpaceVim#mapping#leader#defindWindowsLeader', vim.g.spacevim_windows_leader)
  end

  call('SpaceVim#mapping#g#init')
  call('SpaceVim#mapping#z#init')
  call('SpaceVim#mapping#leader#defindKEYs')
  call('SpaceVim#mapping#space#init')

  -- leader guide
  if not call('SpaceVim#mapping#guide#has_configuration') then
    vim.g.leaderGuide_map = {}
    call('SpaceVim#mapping#guide#register_prefix_descriptions', '', 'g:leaderGuide_map')
  end

  -- help language
  if vim.g.spacevim_vim_help_language == 'cn' then
    vim.o.helplang = 'cn'
  elseif vim.g.spacevim_vim_help_language == 'ja' then
    vim.o.helplang = 'jp'
  end

  -- generate helptags
  local help = fn.fnamemodify(vim.g._spacevim_root_dir, ':p:h') .. '/doc'
  pcall(function()
    cmd('helptags ' .. help)
  end)

  -- set language
  if vim.g.spacevim_language and vim.g.spacevim_language ~= '' then
    cmd('silent exec lan ' .. vim.g.spacevim_language)
  end

  -- tab options
  vim.o.smarttab = true
  vim.o.expandtab = vim.g.spacevim_expand_tab
  vim.o.wrap = vim.g.spacevim_wrap_line
  vim.o.list = vim.g.spacevim_enable_list_mode

  if vim.g.spacevim_default_indent > 0 then
    vim.o.tabstop = vim.g.spacevim_default_indent
    vim.o.softtabstop = vim.g.spacevim_default_indent
    vim.o.shiftwidth = vim.g.spacevim_default_indent
  end

  -- unite menus
  if vim.g.unite_source_menu_menus == nil then
    vim.g.unite_source_menu_menus = {}
  end
  local menus = vim.g.unite_source_menu_menus
  if menus.CustomKeyMaps == nil then
    menus.CustomKeyMaps = { command_candidates = {} }
  end
  if menus.MyStarredrepos == nil then
    menus.MyStarredrepos = { command_candidates = {} }
  end
  if menus.MpvPlayer == nil then
    menus.MpvPlayer = { command_candidates = {} }
  end
  menus.CustomKeyMaps.description = 'Custom mapped keyboard shortcuts                   [unite]<SPACE>'
  menus.MyStarredrepos.description = 'All github repos starred by me                   <leader>ls'
  menus.MpvPlayer.description = 'Musics list                   <leader>lm'

  -- realtime leader guide
  if vim.g.spacevim_realtime_leader_guide then
    cmd([[nnoremap <silent><nowait> <leader> :<c-u>LeaderGuide get(g:, 'mapleader', '\')<CR>]])
    cmd([[vnoremap <silent> <leader> :<c-u>LeaderGuideVisual get(g:, 'mapleader', '\')<CR>]])
  end

  vim.g.leaderGuide_max_size = 15
  cmd('set wildignore+=' .. vim.g.spacevim_wildignore)
end

--=============================================================================
-- end(): finalize SpaceVim initialization
--=============================================================================

function M.end()
  vim.o.tabline = ' '

  -- lazy end via timer
  local timer = vim.loop.new_timer()
  if timer then
    timer:start(vim.g.spacevim_lazy_conf_timeout or 200, 0, function()
      vim.schedule(lazy_end)
      timer:close()
    end)
  end

  -- statusline init
  if require('spacevim.layer').isLoaded('core#statusline') then
    call('SpaceVim#layers#core#statusline#init')
  end

  -- load plugins
  require('spacevim.plugins').load()

  -- enable guicolors
  if vim.g.spacevim_enable_guicolors == 1 then
    if fn.exists('+termguicolors') == 1 then
      vim.o.termguicolors = true
    elseif fn.exists('+guicolors') == 1 then
      vim.o.guicolors = true
    end
  end

  -- init autocmds
  require('spacevim.autocmds').init()

  -- colorscheme
  if vim.g.spacevim_colorscheme ~= '' then
    local ok = pcall(function()
      cmd('set background=' .. vim.g.spacevim_colorscheme_bg)
      cmd('colorscheme ' .. vim.g.spacevim_colorscheme)
    end)
    if not ok then
      cmd('colorscheme ' .. vim.g.spacevim_colorscheme_default)
    end
  else
    cmd('colorscheme ' .. vim.g.spacevim_colorscheme_default)
  end

  -- hidden file info
  if vim.g.spacevim_hiddenfileinfo == 1 then
    opt.shortmess:append('F')
  end

  -- guifont
  if vim.g.spacevim_guifont and vim.g.spacevim_guifont ~= '' then
    pcall(function()
      vim.o.guifont = vim.g.spacevim_guifont
    end)
  end

  -- cursor shape
  if vim.g.spacevim_terminal_cursor_shape == 0 then
    vim.o.guicursor = ''
  elseif vim.g.spacevim_terminal_cursor_shape == 1 then
    vim.o.guicursor = 'n-v-c:block-blinkon0,i-ci-ve:ver25-blinkon0,r-cr:hor20,o:hor50'
  elseif vim.g.spacevim_terminal_cursor_shape == 2 then
    vim.o.guicursor = 'n-v-c:block-blinkon10,i-ci-ve:ver25-blinkon10,r-cr:hor20,o:hor50'
  end
  if vim.o.guicursor ~= '' then
    vim.o.guicursor = vim.o.guicursor .. ',a:Cursor/lCursor'
  end

  cmd('filetype plugin indent on')
  cmd('syntax on')
end

--=============================================================================
-- welcome(): open welcome page
--=============================================================================

function M.welcome()
  logger.info('try to open SpaceVim welcome page')

  if vim.g._spacevim_session_loaded == 1 then
    logger.info('start SpaceVim with session file, skip welcome page')
    return
  end

  cmd('cd ' .. fn.fnameescape(vim.g._spacevim_enter_dir))

  if vim.g._spacevim_checking_flag then
    return
  end

  -- startify
  if fn.exists(':Startify') == 2 then
    cmd('Startify')
    if fn.isdirectory(fn.bufname(1)) == 1 and fn.bufnr() ~= 1 then
      cmd('bwipeout! 1')
    end
  end

  -- file tree
  if vim.g.spacevim_enable_vimfiler_welcome and not vim.g._spacevim_checking_flag then
    local timer = vim.loop.new_timer()
    if timer then
      timer:start(500, 0, function()
        vim.schedule(M.open_filetree)
        timer:close()
      end)
    end
  end
end

--=============================================================================
-- open_filetree(): open file tree on welcome
--=============================================================================

function M.open_filetree()
  if fn.exists(':VimFiler') == 2 then
    cmd('VimFiler | wincmd p')
  elseif fn.exists(':Defx') == 2 then
    cmd('Defx | wincmd p')
  elseif fn.exists(':NERDTree') == 2 then
    cmd('NERDTree | wincmd p')
  elseif fn.exists(':NvimTreeOpen') == 2 then
    pcall(function()
      cmd('NvimTreeOpen')
    end)
    cmd('doautocmd WinEnter | wincmd p')
  elseif fn.exists(':Neotree') == 2 then
    cmd('NeoTreeShow')
  end
end

--=============================================================================
-- Bootstrap: initialize all options on require
--=============================================================================

init_options()
init_private_options()
init_mapping_prefixs()
init_commands()

return M

