local M = {}
function M.plugins() return { { 'posva/vim-vue', { merged = false } } } end
function M.health() M.plugins() return true end
return M

