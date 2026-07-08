--=============================================================================
-- plugins.lua --- plugin manager
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')
local call = vim.call
local fn = vim.fn

function M.load()
  call('SpaceVim#plugins#load')
end

function M.complete_plugs(ArgLead, CmdLine, CursorPos)
  return call('SpaceVim#plugins#complete_plugs', ArgLead, CmdLine, CursorPos)
end

function M.get(...)
  return call('SpaceVim#plugins#get')
end

function M.begin(path)
  call('SpaceVim#plugins#begin', path)
end

function M._end()
  call('SpaceVim#plugins#end')
end

function M.defind_hooks(bundle)
  call('SpaceVim#plugins#defind_hooks', bundle)
end

function M.fetch()
  call('SpaceVim#plugins#fetch')
end

function M.add(repo, ...)
  local args = { ... }
  if #args > 0 then
    call('SpaceVim#plugins#add', repo, args[1])
  else
    call('SpaceVim#plugins#add', repo)
  end
end

function M.tap(plugin)
  return call('SpaceVim#plugins#tap', plugin)
end

function M.enable_plug()
  return call('SpaceVim#plugins#enable_plug')
end

function M.loadPluginBefore(plugin)
  call('SpaceVim#plugins#loadPluginBefore', plugin)
end

return M

