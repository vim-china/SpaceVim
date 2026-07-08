local M = {}
function M.plugins() return { { 'rhysd/vim-wasm', { merged = false } } } end
function M.health() M.plugins() return true end
return M

