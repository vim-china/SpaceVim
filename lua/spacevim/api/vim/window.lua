--=============================================================================
-- window.lua --- public window apis
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

function M.get_cursor(window_id)
  if vim.api.nvim_win_is_valid(window_id) then
    return vim.api.nvim_win_get_cursor(window_id)
  else
    return { 0, 0 }
  end
end

function M.set_cursor(window_id, pos)
  if vim.api.nvim_win_is_valid(window_id) then
    vim.api.nvim_win_set_cursor(window_id, pos)
  end
end

function M.close(window_id)
  if vim.api.nvim_win_is_valid(window_id) then
    vim.api.nvim_win_close(window_id, false)
  end
end

-- neovim winnr('$') includes floating windows
function M.is_last_win()
  local win_list = vim.api.nvim_tabpage_list_wins(0)
  local num = #win_list
  for _, v in ipairs(win_list) do
    if M.is_float(v) then
      num = num - 1
    end
  end
  return num == 1

end

function M.is_float(winid)
    if winid > 0 then
        local ok, c = pcall(vim.api.nvim_win_get_config, winid)
        if ok and c.col ~= nil then
            return true
        else
            return false
        end
    else
        return false
    end
end


return M

