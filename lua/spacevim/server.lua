--=============================================================================
-- server.lua --- server manager for SpaceVim
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger')
local system = require('spacevim.api').import('system')
local fn = vim.fn

local flag = 0

function M.connect()
  if flag == 0 then
    if vim.env.SPACEVIM_SERVER_ADDRESS == nil or vim.env.SPACEVIM_SERVER_ADDRESS == '' then
      if system.isWindows then
        vim.env.SPACEVIM_SERVER_ADDRESS = '\\.\\pipe\\spacevim-nvim-server'
      else
        vim.env.SPACEVIM_SERVER_ADDRESS = '/tmp/spacevim_nvim_server'
      end
    end
    pcall(function()
      fn.serverstart(vim.env.SPACEVIM_SERVER_ADDRESS)
      logger.info('SpaceVim server startup at:' .. vim.env.SPACEVIM_SERVER_ADDRESS)
    end)
    flag = 1
  end
end

function M.export_server()
  if fn.executable('export') == 1 then
    fn.system('export $TEST_SPACEVIM="test"')
  end
end

function M.terminate()
  -- placeholder for future implementation
end

function M.list()
  return table.concat(fn.serverlist(), '\n')
end

return M

