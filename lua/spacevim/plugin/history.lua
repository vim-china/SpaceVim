--=============================================================================
-- history.lua --- history manager plugin
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger').derive('history')
local sp_file = require('spacevim.api.file')
local sp_json = require('spacevim.api.data.json')
local fn = vim.fn

local history_cache_path = sp_file.unify_path(vim.g.spacevim_data_dir, ':p') .. 'SpaceVim/nvim_history.json'
local filepos = {}

local function read_cache()
  logger.debug('read cache')
  if fn.filereadable(history_cache_path) == 1 then
    local his = sp_json.json_decode(fn.join(fn.readfile(history_cache_path, ''), ''))
    if type(his) == 'table' then
      if his.cmd and type(his.cmd) == 'table' then
        for _, cmd in ipairs(his.cmd) do
          fn.histadd('cmd', cmd)
        end
      end
      if his.search and type(his.search) == 'table' then
        for _, search in ipairs(his.search) do
          fn.histadd('search', search)
        end
      end
      filepos = his.filepos or {}
    end
  end
end

local function write_cache()
  logger.debug('write cache')
  local his = { cmd = {}, filepos = filepos, search = {} }
  for i = 1, 100 do
    local cmd = fn.histget('cmd', -i)
    if cmd == '' then
      break
    end
    table.insert(his.cmd, 1, cmd)
  end
  for i = 1, 100 do
    local search = fn.histget('search', -i)
    if search == '' then
      break
    end
    table.insert(his.search, 1, search)
  end
  fn.writefile({ sp_json.json_encode(his) }, history_cache_path)
end

function M.readcache()
  read_cache()
end

function M.writecache()
  write_cache()
end

function M.jumppos()
  -- BufReadPost event before VimEnter
  if vim.tbl_isempty(filepos) then
    read_cache()
  end
  local pos = filepos[fn.expand('%:p')] or { 0, 0 }
  local l, c = pos[1] or 0, pos[2] or 0
  logger.debug(string.format('jump to pos: [%s, %s]', l, c))
  if l ~= 0 and c ~= 0 then
    fn.cursor(l, c)
  end
end

function M.savepos()
  local bufname = fn.bufname()
  if bufname == '' or vim.o.buftype == 'nofile' then
    return
  end
  logger.debug('save pos for:' .. bufname)
  local pos = fn.getpos('.')
  local l, c = pos[2], pos[3]
  logger.debug(string.format('line %d, col %d', l, c))
  if l ~= 0 and c ~= 0 and fn.filereadable(bufname) == 1 then
    filepos[fn.expand('%:p')] = { l, c }
  end
end

return M

