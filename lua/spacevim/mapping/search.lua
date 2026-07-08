--=============================================================================
-- search.lua --- search tools in SpaceVim (Lua implementation)
-- Copyright (c) 2016-2025 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local call = vim.call
local fn = vim.fn

-- Search tools configuration
local search_tools = {}

search_tools.namespace = {
  rg = 'r',
  ag = 'a',
  hw = 'h',
  pt = 't',
  ack = 'k',
  grep = 'g',
  findstr = 'i',
}

search_tools.a = {
  command = 'ag',
  default_opts = { '-i', '--nocolor', '--filename', '--noheading', '--column', '--hidden', '--ignore', '.hg', '--ignore', '.svn', '--ignore', '.git', '--ignore', '.bzr' },
  recursive_opt = {},
  expr_opt = {},
  fixed_string_opt = { '-F' },
  default_fopts = { '--nonumber' },
  smart_case = { '-S' },
  ignore_case = { '-i' },
}

search_tools.t = {
  command = 'pt',
  default_opts = { '--nogroup', '--nocolor' },
  recursive_opt = {},
  expr_opt = { '-e' },
  fixed_string_opt = {},
  default_fopts = {},
  smart_case = { '-S' },
  ignore_case = { '-i' },
}

search_tools.h = {
  command = 'hw',
  default_opts = { '--no-group', '--no-color' },
  recursive_opt = {},
  expr_opt = {},
  fixed_string_opt = {},
  default_fopts = {},
  smart_case = {},
  ignore_case = {},
}

search_tools.r = {
  command = 'rg',
  default_opts = { '--hidden', '--no-heading', '--color=never', '--with-filename', '--line-number', '--column', '-g', '!.git' },
  recursive_opt = {},
  expr_opt = { '-e' },
  fixed_string_opt = { '-F' },
  default_fopts = { '-N' },
  smart_case = { '-S' },
  ignore_case = { '-i' },
}

search_tools.k = {
  command = 'ack',
  default_opts = { '-i', '--no-heading', '--no-color', '-k', '-H' },
  recursive_opt = {},
  expr_opt = {},
  fixed_string_opt = {},
  default_fopts = {},
  smart_case = { '--smart-case' },
  ignore_case = { '--ignore-case' },
}

search_tools.g = {
  command = 'grep',
  default_opts = { '-inHr' },
  expr_opt = { '-e' },
  fixed_string_opt = { '-F' },
  recursive_opt = { '.' },
  default_fopts = {},
  smart_case = {},
  ignore_case = { '-i' },
}

search_tools.G = {
  command = 'git',
  default_opts = { 'grep', '-n', '--column' },
  expr_opt = { '-E' },
  fixed_string_opt = { '-F' },
  recursive_opt = { '.' },
  default_fopts = {},
  smart_case = {},
  ignore_case = { '-i' },
}

search_tools.i = {
  command = 'findstr',
  default_opts = { '/RSN' },
  recursive_opt = {},
  expr_opt = {},
  fixed_string_opt = {},
  default_fopts = {},
  smart_case = {},
  ignore_case = { '/I' },
}

--- Open flygrep with search parameters
--- @param key string search tool key
--- @param scope string search scope (b/B/p/P/d/D/f/F)
function M.grep(key, scope)
  local tool = search_tools[key]
  if not tool then return end
  local cmd = tool.command
  local opt = tool.default_opts
  local ropt = tool.recursive_opt
  local ignore = tool.ignore_case
  local smart = tool.smart_case
  local expr = tool.expr_opt

  local function make_opts(input, extra)
    local opts = {
      input = input,
      cmd = cmd,
      opt = opt,
      ropt = ropt,
      ignore_case = ignore,
      smart_case = smart,
      expr_opt = expr,
    }
    for k, v in pairs(extra or {}) do
      opts[k] = v
    end
    return opts
  end

  if scope == 'b' then
    call('SpaceVim#plugins#flygrep#open', make_opts(fn.input('grep pattern:'), { files = '@buffers' }))
  elseif scope == 'B' then
    call('SpaceVim#plugins#flygrep#open', make_opts(fn.expand('<cword>'), { files = '@buffers' }))
  elseif scope == 'p' then
    call('SpaceVim#plugins#flygrep#open', make_opts(fn.input('grep pattern:')))
  elseif scope == 'P' then
    call('SpaceVim#plugins#flygrep#open', make_opts(fn.expand('<cword>')))
  elseif scope == 'd' then
    call('SpaceVim#plugins#flygrep#open', make_opts(fn.input('grep pattern:'), { dir = fn.fnamemodify(fn.expand('%'), ':p:h') }))
  elseif scope == 'D' then
    call('SpaceVim#plugins#flygrep#open', make_opts(fn.expand('<cword>'), { dir = fn.fnamemodify(fn.expand('%'), ':p:h') }))
  elseif scope == 'f' then
    call('SpaceVim#plugins#flygrep#open', make_opts(fn.input('grep pattern:'), { dir = fn.input('arbitrary dir:', '', 'dir') }))
  elseif scope == 'F' then
    call('SpaceVim#plugins#flygrep#open', make_opts(fn.expand('<cword>'), { dir = fn.input('arbitrary dir:', '', 'dir') }))
  end
end

--- Get the default search tool
--- @return table|string returns { exe, opt, ropt, expr_opt, fixed_opt, ignore_case, smart_case } or empty
function M.default_tool()
  if not search_tools.default_exe then
    local tools = vim.g.spacevim_search_tools or { 'rg', 'ag', 'pt', 'ack', 'grep' }
    for _, t in ipairs(tools) do
      if fn.executable(t) == 1 then
        search_tools.default_exe = t
        local key = search_tools.namespace[t]
        search_tools.default_opt = search_tools[key].default_opts
        search_tools.default_ropt = search_tools[key].recursive_opt
        search_tools.expr_opt = search_tools[key].expr_opt
        search_tools.fixed_string_opt = search_tools[key].fixed_string_opt
        search_tools.ignore_case = search_tools[key].ignore_case
        search_tools.smart_case = search_tools[key].smart_case
        break
      end
    end
    if not search_tools.default_exe then
      return { '', '', '', '', '', '', '' }
    end
  end
  return {
    search_tools.default_exe,
    search_tools.default_opt,
    search_tools.default_ropt,
    search_tools.expr_opt,
    search_tools.fixed_string_opt,
    search_tools.ignore_case,
    search_tools.smart_case,
  }
end

--- Get default file options for a search tool
--- @param exe string executable name
--- @return table
function M.getFopt(exe)
  local key = search_tools.namespace[exe]
  if key and search_tools[key] then
    return search_tools[key].default_fopts
  end
  return {}
end

--- Update search tool profiles
--- @param opt table profile options
function M.profile(opt)
  for key, val in pairs(opt) do
    if search_tools.namespace[key] then
      local ns_key = search_tools.namespace[key]
      for opt_key, _ in pairs(search_tools[ns_key]) do
        if val[opt_key] then
          search_tools[ns_key][opt_key] = val[opt_key]
        end
      end
    else
      -- TODO: add new search tool
    end
  end
end

--- Get search profile
--- @param tool_name? string optional tool name
--- @return table?
function M.getprofile(tool_name)
  if tool_name then
    local tool = search_tools.namespace[tool_name] or ''
    if tool ~= '' then
      return vim.deepcopy(search_tools[tool])
    end
  else
    if not search_tools.default_exe then
      local tools = vim.g.spacevim_search_tools or { 'rg', 'ag', 'pt', 'ack', 'grep' }
      for _, t in ipairs(tools) do
        if fn.executable(t) == 1 then
          search_tools.default_exe = t
          local key = search_tools.namespace[t]
          search_tools.default_opt = search_tools[key].default_opts
          search_tools.default_ropt = search_tools[key].recursive_opt
          search_tools.expr_opt = search_tools[key].expr_opt
          search_tools.fixed_string_opt = search_tools[key].fixed_string_opt
          search_tools.ignore_case = search_tools[key].ignore_case
          search_tools.smart_case = search_tools[key].smart_case
          break
        end
      end
    end
    if search_tools.default_exe then
      return vim.deepcopy(search_tools[search_tools.namespace[search_tools.default_exe]])
    end
  end
end

return M

