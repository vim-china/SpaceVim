local M = {}
function M.plugins() return { { 'wsdjeg/vim-wdl', { merged = false } } } end
function M.health() M.plugins() return true end
return M

