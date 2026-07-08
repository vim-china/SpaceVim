--=============================================================================
-- buffer.lua --- public buffer apis
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.create_buf(listed, scratch)
  return vim.api.nvim_create_buf(listed, scratch)
end

function M.set_lines(bufnr, startindex, endindex, replacement)
  vim.api.nvim_buf_set_lines(bufnr, startindex, endindex, false, replacement)
end

function M.listed_buffers() -- {{{
  return vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 'buflisted(v:val)')
end
-- }}}

function M.resize(size, ...)
  local arg = { ... }
  local cmd = arg[1] or 'vertical'
  vim.cmd(cmd .. ' resize ' .. size)
end

function M.open_pos(cmd, filename, line, col)
  vim.cmd('silent ' .. cmd .. ' ' .. filename)
  vim.fn.cursor(line, col)
end

---@param bufnr number the buffer number
---@param opt string option name
---@param value any option value
function M.set_option(bufnr, opt, value)
  if vim.api.nvim_set_option_value then
    return vim.api.nvim_set_option_value(opt, value, {
      buf = bufnr
    })
  end
  if vim.api.nvim_buf_set_option then
    return vim.api.nvim_buf_set_option(bufnr, opt, value)
  end
end

function M.get_option(bufnr, name)
  if vim.api.nvim_get_option_value then
    return vim.api.nvim_get_option_value(name, { buf = bufnr })
  end
  if vim.api.nvim_buf_get_option then
    return vim.api.nvim_buf_get_option(bufnr, name)
  end
end

return M

