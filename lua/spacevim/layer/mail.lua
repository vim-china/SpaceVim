--=============================================================================
-- mail.lua --- SpaceVim mail layer
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local imap_host = 'imap.163.com'
local imap_port = 143
local imap_login = ''
local imap_password = ''

function M.plugins()
  return {
    { vim.g._spacevim_root_dir .. 'bundle/vim-mail', { merged = false, loadconf = true } },
  }
end

function M.set_variable(opt)
  imap_host = opt.imap_host or imap_host
  imap_port = opt.imap_port or imap_port
  imap_login = opt.imap_login or imap_login
  imap_password = opt.imap_password or imap_password
end

function M.config()
  vim.call('SpaceVim#mapping#space#def', 'nnoremap', { 'a', 'm' }, 'call mail#client#open()', 'Start mail client', 1)
  vim.g.mail_imap_host = imap_host
  vim.g.mail_imap_port = imap_port
  vim.g.mail_imap_login = imap_login
  vim.g.mail_imap_password = imap_password
end

function M.health()
  M.plugins()
  M.config()
  return true
end

return M

