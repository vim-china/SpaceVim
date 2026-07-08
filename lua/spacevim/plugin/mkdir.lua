--=============================================================================
-- mkdir.lua --- mkdir plugin in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local logger = require('spacevim.logger').derive('mkdir')
local fn = vim.fn

local function mkdir(dir)
    if fn.exists('*mkdir') == 1 then
        fn.mkdir(dir, 'p')
    else
    end
end

local function create_directory(dir)
    if vim.regex('^[a-z]\\+:/'):match_str(dir) then
        return
    end
    if fn.isdirectory(dir) == 0 then
        mkdir(dir)
    end
end

function M.create_current()
    local directory = fn.fnamemodify(fn.expand('<afile>'), ':p:h')
    create_directory(directory)
end

return M

