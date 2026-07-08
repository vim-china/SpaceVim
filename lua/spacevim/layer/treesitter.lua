--=============================================================================
-- treesitter.lua --- SpaceVim treesitter layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.plugins()
  local version = ''
  if vim.fn.has('nvim-0.8.0') == 1 then
    version = '-0.9.1'
  end
  return {
    { vim.g._spacevim_root_dir .. 'bundle/nvim-treesitter' .. version, {
      merged = false,
      loadconf = true,
      ['do'] = 'TSUpdate',
      loadconf_before = true,
    } },
  }
end

function M.health()
  M.plugins()
  return true
end

function M.setup()
  require('spacevim.treesitter').setup()
end

function M.loadable()
  return vim.fn.has('nvim') == 1
end

return M

