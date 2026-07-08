--=============================================================================
-- windowsmanager.lua --- windows manager for SpaceVim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local fn = vim.fn
local cmd = vim.cmd
local o = vim.o

local restore_windows_stack = {}
local redo_stack = {}
local unmarked = 0

local function get_window_restore_data()
  return {
    bufname = fn.fnamemodify(fn.bufname('%'), ':p'),
    tabpagenr = fn.tabpagenr(),
    view = fn.winsaveview(),
    newtab = 0,
    oldwinid = -1,
    same_w = 0,
  }
end

function M.UpdateRestoreWinInfo()
  if not o.buflisted then
    if o.buftype == 'terminal' then
      cmd('noautocmd q')
    end
    return
  end
  unmarked = 1
  local win_data = get_window_restore_data()
  if #fn.tabpagebuflist() == 1 then
    win_data.newtab = 1
    win_data.open_command = (fn.tabpagenr() - 1) .. 'tabnew'
  else
    if fn.winwidth(fn.winnr()) == o.columns then
      win_data.same_w = 1
    end
    win_data.oldwinid = fn.winnr()
  end
  table.insert(restore_windows_stack, win_data)
  redo_stack = {}
end

function M.UndoQuitWin()
  if #restore_windows_stack == 0 then
    return
  end
  local win_data = table.remove(restore_windows_stack)
  if win_data.newtab then
    cmd(win_data.open_command .. ' ' .. win_data.bufname)
  else
    cmd(win_data.open_command)
  end
  table.insert(redo_stack, { fn.tabpagenr(), fn.winnr() })
end

function M.RedoQuitWin()
  if #redo_stack > 0 then
    local entry = table.remove(redo_stack)
    local tabpage, winnr = entry[1], entry[2]
    cmd('tabnext ' .. tabpage)
    cmd(winnr .. 'wincmd w')
    cmd('quit')
  end
end

function M.MarkBaseWin()
  if unmarked == 1 then
    local win_data = restore_windows_stack[#restore_windows_stack]
    if win_data.same_w then
      -- split
      if win_data.oldwinid == fn.winnr() then
        win_data.open_command = 'topleft split ' .. win_data.bufname
      else
        win_data.open_command = 'rightbelow split ' .. win_data.bufname
      end
    else
      -- vsplit
      if win_data.oldwinid == fn.winnr() then
        win_data.open_command = 'topleft vsplit ' .. win_data.bufname
      else
        win_data.open_command = 'rightbelow vsplit ' .. win_data.bufname
      end
    end
    unmarked = 0
  end
end

return M

