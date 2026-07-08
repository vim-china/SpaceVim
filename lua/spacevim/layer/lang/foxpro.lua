local M = {}
function M.plugins() return { { 'wsdjeg/vim-foxpro', { merged = false } } } end
function M.health() M.plugins() return true end
return M

