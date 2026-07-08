local M = {}
function M.plugins() return { { 'wsdjeg/riv.vim', { merged = false } } } end
function M.health() M.plugins() return true end
return M

