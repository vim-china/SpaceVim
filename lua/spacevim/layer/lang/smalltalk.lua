local M = {}
function M.plugins() return { { vim.g._spacevim_root_dir .. 'bundle/smalltalk', { merged = false } } } end
function M.health() M.plugins() return true end
return M

