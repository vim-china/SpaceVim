--=============================================================================
-- tab.lua --- tab key binding (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local fn = vim.fn

--- Handle Tab key in insert mode
--- @return string key sequence to feed
function M.i_tab()
  local snippet_engine = vim.g.spacevim_snippet_engine or 'neosnippet'
  local col = fn.col('.')
  local line = fn.getline('.')
  local char_before = line:sub(col - 2, col - 2)
  local acp_method = vim.g.spacevim_autocomplete_method or ''

  if snippet_engine == 'neosnippet' then
    if char_before == '{' and fn.pumvisible() == 1 then
      return '<C-n>'
    end
    if fn['neosnippet#expandable']() == 1 and char_before == '(' and fn.pumvisible() == 0 then
      return '<Plug>(neosnippet_expand)'
    elseif fn['neosnippet#jumpable']() == 1
      and char_before == '(' and fn.pumvisible() == 0
      and fn['neosnippet#expandable']() == 0 then
      return '<plug>(neosnippet_jump)'
    elseif fn['neosnippet#expandable_or_jumpable']() == 1 and char_before ~= '(' then
      return '<plug>(neosnippet_expand_or_jump)'
    elseif fn.pumvisible() == 1
      or (acp_method == 'nvim-cmp' and require('cmp').visible()) then
      return '<C-n>'
    elseif acp_method == 'coc' and fn['coc#pum#visible']() == 1 then
      return fn['coc#pum#next'](1)
    elseif fn.exists('*complete_parameter#jumpable') == 1
      and acp_method ~= 'nvim-cmp'
      and fn['complete_parameter#jumpable'](1) == 1
      and char_before ~= ')' then
      return '<plug>(complete_parameter#goto_next_parameter)'
    else
      return '<tab>'
    end
  elseif snippet_engine == 'ultisnips' then
    if char_before == '{' and fn.pumvisible() == 1 then
      return '<C-n>'
    end
    return '<C-R>=SpaceVim#mapping#tab#expandable()<cr>'
  end
  return '<tab>'
end

--- UltiSnips expandable handler
--- @return string
function M.expandable()
  local snippet = fn['UltiSnips#ExpandSnippetOrJump']()
  if vim.g.ulti_expand_or_jump_res and vim.g.ulti_expand_or_jump_res > 0 then
    return snippet
  elseif fn.pumvisible() == 1 then
    return '<C-n>'
  elseif vim.g.spacevim_autocomplete_method == 'coc' and fn['coc#pum#visible']() == 1 then
    return fn['coc#pum#next'](1)
  else
    return '<TAB>'
  end
end

return M

