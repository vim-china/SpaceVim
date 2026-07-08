--=============================================================================
-- command.lua --- Commands for SpaceVim
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local cmd = vim.cmd
local fn = vim.fn
local call = vim.call
local api = vim.api

function M.load()
  cmd('command! -nargs=+ SPLayer call SpaceVim#layers#load(<f-args>)')
  cmd('command! -nargs=0 SPVersion call SpaceVim#commands#version()')
  cmd('command! -nargs=+ -complete=custom,SpaceVim#commands#complete_options SPSet call SpaceVim#options#set(<f-args>)')
  cmd([[command! -nargs=0 -bang SPDebugInfo call SpaceVim#logger#viewLog('<bang>' == '!')]])
  cmd('command! -nargs=* SPRuntimeLog call SpaceVim#logger#viewRuntimeLog(<f-args>)')
  cmd('command! -nargs=* -complete=customlist,SpaceVim#commands#complete_SPConfig SPConfig call SpaceVim#commands#config(<f-args>)')
  cmd('command! -nargs=* -complete=custom,SpaceVim#commands#complete_plugin SPUpdate call SpaceVim#commands#update_plugin(<f-args>)')
  cmd('command! -nargs=+ -complete=custom,SpaceVim#commands#complete_plugin SPReinstall call SpaceVim#commands#reinstall_plugin(<f-args>)')
  cmd('command! -nargs=* SPInstall call SpaceVim#commands#install_plugin(<f-args>)')
  cmd('command! -nargs=* SPClean call SpaceVim#commands#clean_plugin()')
  cmd('command! -nargs=0 Report call SpaceVim#issue#new()')
  cmd([[command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis]])
  cmd('command! -nargs=+ -complete=custom,SpaceVim#plugins#projectmanager#complete_project OpenProject :call SpaceVim#plugins#projectmanager#OpenProject(<f-args>)')
  cmd('command! -nargs=* -complete=custom,SpaceVim#plugins#pmd#complete PMD :call SpaceVim#plugins#pmd#run(<f-args>)')
  cmd('command! -nargs=? -complete=custom,SpaceVim#plugins#a#complete -bang A :call SpaceVim#plugins#a#alt(<bang>0,<f-args>)')
end

function M.complete_plugin(ArgLead, CmdLine, CursorPos)
  if vim.g.spacevim_plugin_manager == 'dein' then
    local plugins = call('dein#get')
    if type(plugins) == 'table' then
      local names = {}
      for k, _ in pairs(plugins) do
        table.insert(names, k)
      end
      table.insert(names, 'SpaceVim')
      return table.concat(names, '\n')
    end
  end
  return ''
end

function M.complete_SPConfig(ArgLead, CmdLine, CursorPos)
  return '-g\n-l'
end

function M.config(...)
  local args = { ... }
  if #args > 0 then
    if args[1] == '-g' then
      cmd('tabnew ' .. vim.g._spacevim_global_config_path)
    elseif args[1] == '-l' then
      cmd('tabnew ' .. vim.g._spacevim_config_path)
    end
  else
    if vim.g.spacevim_force_global_config or vim.g._spacevim_config_path == nil or vim.g._spacevim_config_path == '0' then
      cmd('tabnew ' .. vim.g._spacevim_global_config_path)
    else
      cmd('tabnew ' .. vim.g._spacevim_config_path)
    end
  end
  vim.bo.omnifunc = 'SpaceVim#custom#complete'
end

function M.update_plugin(...)
  local args = { ... }
  if #args == 0 then
    call('SpaceVim#plugins#manager#update')
  else
    call('SpaceVim#plugins#manager#update', args)
  end
end

function M.reinstall_plugin(...)
  call('SpaceVim#plugins#manager#reinstall', { ... })
end

function M.clean_plugin()
  if vim.g.spacevim_plugin_manager == 'dein' then
    local clean_list = call('dein#check_clean')
    for _, val in ipairs(clean_list) do
      fn.delete(val, 'rf')
    end
    call('dein#recache_runtimepath')
  end
end

function M.install_plugin(...)
  local args = { ... }
  if #args == 0 then
    call('SpaceVim#plugins#manager#install')
  else
    call('SpaceVim#plugins#manager#install', args)
  end
end

function M.version()
  local sha = M._SHA()
  local features = M._check_features({
    'tui', 'jemalloc', 'acl', 'arabic', 'autocmd', 'browse',
    'byte_offset', 'cindent', 'clientserver', 'clipboard',
    'cmdline_compl', 'cmdline_hist', 'cmdline_info', 'comments',
    'conceal', 'cscope', 'cursorbind', 'cursorshape', 'debug',
    'dialog_gui', 'dialog_con', 'dialog_con_gui', 'digraphs',
    'eval', 'ex_extra', 'extra_search', 'farsi', 'file_in_path',
    'find_in_path', 'folding', 'gettext', 'iconv', 'iconv/dyn',
    'insert_expand', 'jumplist', 'keymap', 'langmap', 'libcall',
    'linebreak', 'lispindent', 'listcmds', 'localmap', 'menu',
    'mksession', 'modify_fname', 'mouse', 'mouseshape',
    'multi_byte', 'multi_byte_ime', 'multi_lang', 'path_extra',
    'persistent_undo', 'postscript', 'printer', 'profile',
    'python', 'python3', 'quickfix', 'reltime', 'rightleft',
    'scrollbind', 'shada', 'signs', 'smartindent', 'startuptime',
    'statusline', 'syntax', 'tablineat', 'tag_binary',
    'tag_old_static', 'tag_any_white', 'termguicolors', 'terminfo',
    'termresponse', 'textobjects', 'tgetent', 'timers', 'title',
    'toolbar', 'user_commands', 'vertsplit', 'virtualedit',
    'visual', 'visualextra', 'vreplace', 'wildignore', 'wildmenu',
    'windows', 'writebackup', 'xim', 'xfontset', 'xpm', 'xpm_w32',
  })
  print('SpaceVim ' .. vim.g.spacevim_version .. sha .. '\n\n' ..
    'Optional features included (+) or not (-):\n' .. features)
end

function M._check_features(features)
  local rst = ''
  local id = 1
  for _, f in ipairs(features) do
    local sign = fn.has(f) == 1 and '+' or '-'
    local entry = sign .. f
    rst = rst .. '    ' .. entry .. string.rep(' ', 20 - #entry)
    if id == 3 then
      rst = rst .. '\n'
      id = 1
    else
      id = id + 1
    end
  end
  return rst:gsub('\n*%s*$', '')
end

function M._SHA()
  local sha = fn.system('git --no-pager -C ~/.SpaceVim  log -n 1 --oneline')
  if fn.v:shell_error ~= 0 or sha == '' then
    return ''
  end
  return '-' .. sha:sub(1, 7)
end

function M.complete_options(...)
  local completion = fn.getcompletion('g:spacevim_', 'var')
  local result = {}
  for _, v in ipairs(completion) do
    table.insert(result, v:sub(12))
  end
  return table.concat(result, '\n')
end

return M

