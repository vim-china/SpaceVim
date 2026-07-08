--=============================================================================
-- issue.lua --- issue reporter for SpaceVim
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local cmp = require('spacevim.api').import('vim#compatible')
local str = require('spacevim.api').import('data#string')
local system = require('spacevim.api').import('system')
local fn = vim.fn
local cmd = vim.cmd

local function spacevim_status()
  local pwd = fn.getcwd()
  local status
  pcall(function()
    cmd('cd ' .. fn.fnamemodify(vim.g._spacevim_root_dir, ':p:h'))
    status = cmp.systemlist('git status')
  end)
  if not status then
    pcall(function()
      cmd('cd ~/.SpaceVim')
      status = cmp.systemlist('git status')
    end)
  end
  cmd('cd ' .. pwd)
  if type(status) == 'table' then
    return status
  else
    return { status }
  end
end

local function spacevim_version()
  local pwd = fn.getcwd()
  local status
  pcall(function()
    cmd('cd ' .. fn.fnamemodify(vim.g._spacevim_root_dir, ':p:h'))
    status = cmp.systemlist('git rev-parse --short HEAD')
  end)
  if not status then
    pcall(function()
      cmd('cd ~/.SpaceVim')
      status = cmp.systemlist('git rev-parse --short HEAD')
    end)
  end
  cmd('cd ' .. pwd)
  if type(status) == 'table' then
    return str.trim(table.concat(status))
  else
    return ''
  end
end

local function template()
  local info = {
    '<!-- please remove the issue template when request for a feature -->',
    '## Expected behavior, english is recommend',
    '',
    '## Environment Information',
    '',
    '- OS: ' .. system.name(),
    '- vim version: -',
    '- neovim version: ' .. cmp.version(),
    '- SpaceVim version: ' .. vim.g.spacevim_version,
    '- SpaceVim status: ' .. spacevim_version(),
    '',
    '```',
  }
  local s = spacevim_status()
  for _, v in ipairs(s) do
    table.insert(info, v)
  end
  table.insert(info, '```')
  table.insert(info, '')
  table.insert(info, '## The reproduce ways from Vim starting (Required!)')
  table.insert(info, '')
  table.insert(info, '## Output of the `:SPDebugInfo!`')
  table.insert(info, '')
  local debug_info = vim.split(cmp.execute(':SPDebugInfo'), '\n')
  for _, v in ipairs(debug_info) do
    table.insert(info, v)
  end
  table.insert(info, '## Screenshots')
  table.insert(info, '')
  table.insert(info, 'If you have any screenshots for this issue please upload here. BTW you can use https://asciinema.org/ for recording video in terminal.')
  return info
end

local function open()
  cmd('silent tabnew ' .. fn.tempname() .. '/issue_report.md')
  vim.b.spacevim_issue_template = 1
  local t = template()
  fn.setline(1, t)
  fn.setreg('+', table.concat(t, '\n'))
  cmd('silent w')
end

function M.report()
  open()
end

function M.new()
  if vim.b.spacevim_issue_template == 1 then
    local title = fn.input('Issue title:')
    local username = fn.input('github username:')
    local password = fn.input('github password:')
    local issue = {
      title = title,
      body = table.concat(fn.getline(1, '$'), '\n'),
    }
    -- Note: github#api#issues#Create is still vim script
    local response = vim.call('github#api#issues#Create', 'SpaceVim', 'SpaceVim', username, password, issue)
    if response and response.html_url then
      print('Issue created done: ' .. response.html_url)
    else
      print('Failed to create issue, please check the username and password')
    end
  end
end

function M.reopen(id)
  local issue = { state = 'open' }
  local username = fn.input('github username:')
  local password = fn.input('github password:')
  vim.call('github#api#issues#Edit', 'SpaceVim', 'SpaceVim', id, username, password, issue)
end

function M.close(id)
  local issue = { state = 'closed' }
  local username = fn.input('github username:')
  local password = fn.input('github password:')
  vim.call('github#api#issues#Edit', 'SpaceVim', 'SpaceVim', id, username, password, issue)
end

return M

