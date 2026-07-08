local M = {}
function M.plugins() return { { vim.g._spacevim_root_dir .. 'bundle/vim-assembly', { merged = false } } } end
function M.health() M.plugins() return true end
return M

