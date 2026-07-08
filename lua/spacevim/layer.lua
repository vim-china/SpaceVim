--=============================================================================
-- layer.lua --- spacevim layer module
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger').derive('layer')
local spsys = require('spacevim.api').import('system')

-- enabled layers list
local enabled_layers = {}
-- layer variables (per-layer config)
local layers_vars = {}

function M.isLoaded(layer)
  return vim.fn.index(enabled_layers, layer) ~= -1
end

function M.load(layer, ...)
  if layer == '-l' then
    M.list_layers()
    return
  elseif layer == '' or type(layer) ~= 'string' then
    return
  end
  logger.info('load layer:' .. layer)
  local loadable = 1
  local ok = pcall(function()
    loadable = vim.call('SpaceVim#layers#' .. layer .. '#loadable')
  end)
  if not ok then
    logger.info(layer .. ' layer do not implement loadable function')
  end
  if vim.fn.index(enabled_layers, layer) == -1 then
    if loadable == 1 then
      table.insert(enabled_layers, layer)
    else
      logger.warn('Failed to load ' .. layer .. ' layer, read :h SpaceVim-layer-' .. layer .. ' for more info!')
    end
  end
  local argv = { ... }
  if #argv == 1 and type(argv[1]) == 'table' then
    local ok2 = pcall(function()
      vim.call('SpaceVim#layers#' .. layer .. '#set_variable', argv[1])
    end)
    if ok2 then
      layers_vars[layer] = argv[1]
    else
      logger.info(layer .. ' layer do not implement set_variable function')
    end
  end
  if #argv > 0 and type(argv[1]) == 'string' then
    for _, l in ipairs(argv) do
      M.load(l)
    end
  end
  logger.info('layer loaded.')
end

function M.disable(layer)
  local idx = vim.fn.index(enabled_layers, layer)
  if idx ~= -1 then
    table.remove(enabled_layers, idx + 1)
  end
end

function M.get()
  return vim.deepcopy(enabled_layers)
end

function M.report()
  local info = "```toml\n"
  for _, name in ipairs(enabled_layers) do
    info = info .. "[[layers]]\n"
    info = info .. '  name="' .. name .. '"\n'
    if layers_vars[name] then
      for var, val in pairs(layers_vars[name]) do
        if var ~= 'name' then
          info = info .. '  ' .. var .. '=' .. vim.fn.string(val) .. "\n"
        end
      end
    end
  end
  info = info .. "```\n"
  return info
end

function M.list()
  local layers = vim.fn.globpath(vim.o.runtimepath, 'autoload/SpaceVim/layers/**/*.vim', 0, 1)
  local pattern = spsys.isWindows == 1 and '\\autoload\\SpaceVim\\layers\\' or '/autoload/SpaceVim/layers/'
  local result = {}
  for _, file in ipairs(layers) do
    local layer
    if spsys.isWindows == 1 then
      layer = string.sub(file, string.find(file, pattern) and string.find(file, pattern) + #pattern or 1, -5)
      layer = string.gsub(layer, '\\', '/')
    else
      layer = string.sub(file, string.find(file, pattern) and string.find(file, pattern) + #pattern or 1, -5)
    end
    table.insert(result, string.gsub(layer, '/', '#'))
  end
  return result
end

local function find_layers()
  local layers = vim.fn.globpath(vim.o.runtimepath, 'autoload/SpaceVim/layers/**/*.vim', 0, 1)
  local rst = {}
  for _, layer in pairs(layers) do
    local name = layer:gsub('.+SpaceVim[\\/]layers[\\/]', ''):gsub('.vim$', ''):gsub('[\\/]', '/')
    local status = ''
    local url = ''
    local website = ''
    if name == 'lsp' then
      url = 'language-server-protocol'
    else
      url = name
    end
    if vim.fn.filereadable(vim.fn.expand('~/.SpaceVim/docs/layers/' .. url .. '.md')) == 1 then
      website = 'https://spacevim.org/layers/' .. url .. '/'
    else
      website = 'no exists'
    end
    name = vim.fn.substitute(name, '/', '#', 'g')
    if M.isLoaded(name) then
      status = 'loaded'
    else
      status = 'not loaded'
    end
    if status == 'loaded' then
      table.insert(rst, '+ ' .. name .. ':' .. vim.fn['repeat'](' ', 25 - vim.fn.len(name)) .. status .. vim.fn['repeat'](' ', 10) .. website)
    else
      table.insert(rst, '- ' .. name .. ':' .. vim.fn['repeat'](' ', 21 - vim.fn.len(name)) .. status .. vim.fn['repeat'](' ', 10) .. website)
    end
  end
  return rst
end

function M.list_layers()
  vim.cmd('tabnew SpaceVimLayers')
  vim.cmd('nnoremap <buffer> q :q<cr>')
  vim.cmd('setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell')
  vim.cmd('setf SpaceVimLayerManager')
  vim.cmd('nnoremap <silent> <buffer> q :bd<CR>')
  local info = { 'SpaceVim layers:', '' }
  for _, v in pairs(find_layers()) do
    table.insert(info, v)
  end
  vim.fn.setline(1, info)
  vim.cmd('setl nomodifiable')
end

return M

