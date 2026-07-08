--=============================================================================
-- opt.lua --- The global option of spacevim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}

local mt = {
    -- this is call when we use opt.xxxx = xxx
    __newindex = function(table, key, value)
        vim.g['spacevim_' .. key] = value
    end,
    -- this is call when we use opt.xxxx
    __index = function(table, key)
        return vim.g['spacevim_' .. key] or nil
    end
}
setmetatable(M, mt)

return M

