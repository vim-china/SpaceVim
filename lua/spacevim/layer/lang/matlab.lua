local M = {}
function M.plugins() return { { 'wsdjeg/matlab.vim', { merged = false } } } end
function M.health() M.plugins() return true end
return M

