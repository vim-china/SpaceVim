local M = {}
function M.plugins() return { { 'tomlion/vim-solidity', { merged = false, on_ft = 'solidity' } } } end
function M.health() M.plugins() return true end
return M

