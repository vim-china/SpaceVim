local M = {}
function M.plugins() return { { 'slim-template/vim-slim', { on_ft = { 'slim' } } } } end
function M.health() M.plugins() return true end
return M

