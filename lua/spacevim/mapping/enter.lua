--=============================================================================
-- enter.lua --- Enter key bindings (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local fn = vim.fn

--- Handle Enter key in insert mode
--- @return string key sequence to feed
function M.i_enter()
  local snippet_engine = vim.g.spacevim_snippet_engine or 'neosnippet'
  local col = fn.col('.')
  local line = fn.getline('.')
  local char_before = line:sub(col - 2, col - 2)
  local char_at = line:sub(col - 1, col - 1)

  if snippet_engine == 'neosnippet' then
    if fn.pumvisible() == 1 then
      if fn['neosnippet#expandable']() == 1 then
        return '<plug>(neosnippet_expand)'
      else
        return '<c-y>'
      end
    elseif char_before == '{' and char_at == '}' then
      return '<Enter><esc>ko'
    elseif char_before == '(' and char_at == ')' then
      return '<Enter><esc>ko'
    else
      return '<Enter>'
    end
  elseif snippet_engine == 'ultisnips' then
    if fn.pumvisible() == 1 then
      return '<c-y>'
    elseif char_before == '{' and char_at == '}' then
      return '<Enter><esc>ko'
    else
      return '<Enter>'
    end
  end
  return '<Enter>'
end

return M

