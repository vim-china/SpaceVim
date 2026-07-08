local M = {}
function M.plugins() return { { 'wsdjeg/vim-actionscript', { merged = false } } } end
function M.health() M.plugins() return true end
return M

