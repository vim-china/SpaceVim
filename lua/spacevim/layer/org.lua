--=============================================================================
-- org.lua --- SpaceVim org layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  return vim.call('SpaceVim#layers#lang#org#plugins')
end

function M.config()
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

