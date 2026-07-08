--=============================================================================
-- util.lua --- SpaceVim utils
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local system = require('spacevim.api').import('system')
local file_api = require('spacevim.api').import('file')
local fn = vim.fn
local cmd = vim.cmd

local cache_py3_libs = {}

function M.findFileInParent(what, where)
  local old_suffixesadd = vim.o.suffixesadd
  vim.o.suffixesadd = ''
  local file = fn.findfile(what, fn.escape(where, ' ') .. ';')
  vim.o.suffixesadd = old_suffixesadd
  return file
end

function M.findDirInParent(what, where)
  local old_suffixesadd = vim.o.suffixesadd
  vim.o.suffixesadd = ''
  local dir = fn.finddir(what, fn.escape(where, ' ') .. ';')
  vim.o.suffixesadd = old_suffixesadd
  return dir
end

function M.loadConfig(file)
  local config_path = vim.g._spacevim_root_dir .. '/config/' .. file
  if fn.filereadable(config_path) == 1 then
    cmd('source ' .. config_path)
  end
end

function M.echoWarn(msg)
  cmd('echohl WarningMsg | echo "' .. msg .. '" | echohl None')
end

function M.haspy3lib(lib)
  if cache_py3_libs[lib] ~= nil then
    return cache_py3_libs[lib]
  end
  local ok = pcall(function()
    cmd('py3 import ' .. lib)
  end)
  cache_py3_libs[lib] = ok and 1 or 0
  return cache_py3_libs[lib]
end

function M.haspylib(lib)
  -- deprecated, use haspy3lib
  return 0
end

function M.haspyxlib(lib)
  -- deprecated, use haspy3lib
  return M.haspy3lib(lib)
end

function M.Generate_ignore(ignore, tool, ...)
  local result = {}
  local ignore_list = vim.split(ignore, ',')
  local use_quote = select(1, ...) or 0
  if tool == 'ag' then
    for _, ig in ipairs(ignore_list) do
      table.insert(result, '--ignore')
      table.insert(result, "'" .. ig .. "'")
    end
  elseif tool == 'rg' then
    for _, ig in ipairs(ignore_list) do
      table.insert(result, '-g')
      if use_quote == 1 then
        table.insert(result, "'!" .. ig .. "'")
      else
        table.insert(result, '!' .. ig)
      end
    end
  end
  return result
end

function M.UpdateHosts(...)
  local url
  if select('#', ...) == 0 then
    url = vim.g.spacevim_hosts_url or ''
  else
    url = select(1, ...)
  end
  local hosts = fn.systemlist('curl -s ' .. url)
  local local_hosts
  if system.isWindows then
    local_hosts = vim.env.SystemRoot .. '\\System32\\drivers\\etc\\hosts'
  else
    local_hosts = '/etc/hosts'
  end
  local ret = fn.writefile(hosts, local_hosts, 'a')
  if ret == -1 then
    print('failed!')
  else
    print('successfully!')
  end
end

function M.listDirs(dir)
  dir = fn.fnamemodify(dir, ':p')
  if fn.isdirectory(dir) == 1 then
    local output = fn.systemlist(string.format('ls -F %s | grep /$', dir))
    local result = {}
    for _, v in ipairs(output) do
      table.insert(result, v:sub(1, -2))
    end
    return result
  end
  return {}
end

function M.CopyToClipboard(...)
  local argc = select('#', ...)
  if argc > 0 then
    local mode = select(1, ...)
    if fn.executable('git') == 1 then
      local find_path = file_api.finddir('.git/', fn.expand('%:p'), -1)
      local repo_home = file_api.unify_path(find_path, ':h:h')
      if repo_home ~= '' and fn.isdirectory(repo_home) == 1 then
        local branch_line = fn.systemlist('git -C ' .. repo_home .. ' branch -vv')
        local current_branch = ''
        for _, line in ipairs(branch_line) do
          if line:match('^%*') then
            current_branch = line
            break
          end
        end
        if current_branch ~= '' then
          local parts = vim.split(current_branch, '%s+')
          local remote_info = parts[4] or ''
          local remote_parts = vim.split(remote_info, '/')
          if #remote_parts >= 2 then
            local remote_name = remote_parts[1]:sub(2)
            local branch = remote_parts[2]:sub(1, -2)
            local remotes = fn.systemlist('git -C ' .. repo_home .. ' remote -v')
            local remote = nil
            for _, r in ipairs(remotes) do
              if r:match('^' .. remote_name) and r:match('fetch') then
                remote = r
                break
              end
            end
            if remote then
              local repo_url
              if remote:find('@') then
                local at_part = vim.split(remote, '@')[2]
                local host_part = vim.split(at_part, ':')[1]
                local path_part = vim.split(vim.split(remote, ' ')[1], ':')[2]
                repo_url = 'https://' .. host_part .. '/' .. path_part
                repo_url = repo_url:sub(1, #repo_url - 4)
              else
                local http_idx = remote:find('http')
                if http_idx then
                  repo_url = remote:sub(http_idx, #remote - 4)
                end
              end
              if repo_url then
                local head_sha = fn.systemlist('git rev-parse HEAD')[1]
                local f_url = repo_url .. '/blob/' .. head_sha .. '/' .. file_api.unify_path(fn.expand('%'), ':.')
                if mode == 2 then
                  f_url = f_url .. '#L' .. fn.line('.')
                elseif mode == 3 then
                  f_url = f_url .. '#L' .. fn.getpos("'<")[2] .. '-L' .. fn.getpos("'>")[2]
                end
                pcall(function()
                  vim.fn.setreg('+', f_url)
                  print('Copied to clipboard: ' .. f_url)
                end)
              end
            end
          end
        end
      end
    end
  else
    pcall(function()
      local path = fn.expand('%:p')
      vim.fn.setreg('+', path)
      if path ~= '' or fn.filereadable(path) == 1 then
        print('Copied to clipboard ' .. path)
      else
        print('buffer name is empty!')
      end
    end)
  end
end

return M

