local M = {}
function M.plugins() return { { vim.g._spacevim_root_dir .. 'bundle/vim-qml', { merged = false } } } end
function M.health() return true end
return M

