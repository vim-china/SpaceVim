local M = {}
function M.plugins() return { { 'SpaceVim/vim-swig' } } end
function M.health() M.plugins() return true end
return M

