local M = {}

local system = require('spacevim.api').import('system')
local fn = vim.fn

if system.isWindows then
    M.separator = '\\'
    M.pathSeparator = ';'
else
    M.separator = '/'
    M.pathSeparator = ':'
end

local file_node_extensions = {
    ['styl'] = '',
    ['scss'] = '',
    ['htm'] = '',
    ['html'] = '',
    ['erb'] = '',
    ['slim'] = '',
    ['ejs'] = '',
    ['wxml'] = '',
    ['css'] = '',
    ['less'] = '',
    ['wxss'] = '',
    ['md'] = '',
    ['markdown'] = '',
    ['json'] = '',
    ['js'] = '',
    ['jsx'] = '',
    ['rb'] = '',
    ['php'] = '',
    ['py'] = '',
    ['pyc'] = '',
    ['pyo'] = '',
    ['pyd'] = '',
    ['coffee'] = '',
    ['mustache'] = '',
    ['hbs'] = '',
    ['conf'] = '',
    ['ini'] = '',
    ['yml'] = '',
    ['bat'] = '',
    ['jpg'] = '',
    ['jpeg'] = '',
    ['bmp'] = '',
    ['png'] = '',
    ['gif'] = '',
    ['ico'] = '',
    ['twig'] = '',
    ['cpp'] = '',
    ['c++'] = '',
    ['cxx'] = '',
    ['cc'] = '',
    ['cp'] = '',
    ['c'] = '',
    ['hs'] = '',
    ['lhs'] = '',
    ['lua'] = '',
    ['java'] = '',
    ['sh'] = '',
    ['fish'] = '',
    ['ml'] = 'λ',
    ['mli'] = 'λ',
    ['diff'] = '',
    ['db'] = '',
    ['sql'] = '',
    ['dump'] = '',
    ['clj'] = '',
    ['cljc'] = '',
    ['cljs'] = '',
    ['edn'] = '',
    ['scala'] = '',
    ['go'] = '',
    ['dart'] = '',
    ['xul'] = '',
    ['sln'] = '',
    ['suo'] = '',
    ['pl'] = '',
    ['pm'] = '',
    ['t'] = '',
    ['rss'] = '',
    ['f#'] = '',
    ['fsscript'] = '',
    ['fsx'] = '',
    ['fs'] = '',
    ['fsi'] = '',
    ['rs'] = '',
    ['rlib'] = '',
    ['d'] = '',
    ['erl'] = '',
    ['hrl'] = '',
    ['vim'] = '',
    ['ai'] = '',
    ['psd'] = '',
    ['psb'] = '',
    ['ts'] = '',
    ['tsx'] = '',
    ['jl'] = '',
    ['ex'] = '',
    ['exs'] = '',
    ['eex'] = '',
    ['leex'] = ''
}

local file_node_exact_matches = {
    ['exact-match-case-sensitive-1.txt']  = 'X1',
    ['exact-match-case-sensitive-2']      = 'X2',
    ['gruntfile.coffee']                  = '',
    ['gruntfile.js']                      = '',
    ['gruntfile.ls']                      = '',
    ['gulpfile.coffee']                   = '',
    ['gulpfile.js']                       = '',
    ['gulpfile.ls']                       = '',
    ['dropbox']                           = '',
    ['.ds_store']                         = '',
    ['.gitconfig']                        = '',
    ['.gitignore']                        = '',
    ['.bashrc']                           = '',
    ['.bashprofile']                      = '',
    ['favicon.ico']                       = '',
    ['license']                           = '',
    ['node_modules']                      = '',
    ['react.jsx']                         = '',
    ['Procfile']                          = '',
    ['.vimrc']                            = '',
    ['mix.lock']                          = '',
}

local file_node_pattern_matches = {
    ['.*jquery.*\\.js$']       = '',
    ['.*angular.*\\.js$']      = '',
    ['.*backbone.*\\.js$']     = '',
    ['.*require.*\\.js$']      = '',
    ['.*materialize.*\\.js$']  = '',
    ['.*materialize.*\\.css$'] = '',
    ['.*mootools.*\\.js$']     = ''
}

function M.fticon(path)
    local file = fn.fnamemodify(path, ':t')
    if file_node_exact_matches[file] ~= nil then
        return file_node_exact_matches[file]
    end
    for k,v in ipairs(file_node_pattern_matches) do
        if fn.match(file, k) ~= -1 then
            return v
        end
    end
    local ext = fn.fnamemodify(file, ':e')
    if file_node_extensions[ext] ~= nil then
        return file_node_extensions[ext]
    else
        return ''
    end
end

function M.write(msg, fname)
    local flags
    if fn.filereadable(fname) == 1 then
        flags = 'a'
    else
        flags = ''
    end
    fn.writefile({msg}, fname, flags)
end

function M.override(msg, fname)
    local flags
    if fn.filereadable(fname) == 1 then
        flags = 'b'
    else
        flags = ''
    end
    fn.writefile({msg}, fname, flags)
end

function M.read(fname)
    if fn.filereadable(fname) == 1 then
        return fn.readfile(fname, '')
    else
        return ''
    end
end

function M.unify_path(_path, ...)
  local mod = select(1, ...)
  if mod == nil then
      mod = ':p'
  end
  local path = fn.fnamemodify(_path, mod .. ':gs?[\\\\/]?/?')
  if fn.isdirectory(path) == 1 and string.sub(path, -1) ~= '/' then
    return path .. '/'
  elseif string.sub(_path, -1) == '/' and string.sub(path, -1) ~= '/' then
    return path .. '/'
  else
    return path
  end
end

function M.path_to_fname(path)
    return fn.substitute(M.unify_path(path), '[\\/:;.]', '_', 'g')
end



function M.findfile(what, where, ...)
  -- let old_suffixesadd = &suffixesadd
  -- let &suffixesadd = ''
  local count = select(1, ...)
  if count == nil then
      count = 0
  end

  local file = ''
  local path = ''

  if fn.filereadable(where) == 1 and  fn.isdirectory(where) == 0 then
    path = fn.fnamemodify(where, ':h')
  else
    path = where
  end
  if count > 0 then
    file = fn.findfile(what, fn.escape(path, ' ') .. ';', count)
  elseif #{...} == 0 then
    file = fn.findfile(what, fn.escape(path, ' ') .. ';')
  elseif count == 0 then
    file = fn.findfile(what, fn.escape(path, ' ') .. ';', -1)
  else
    file = fn.get(fn.findfile(what, fn.escape(path, ' ') .. ';', -1), count, '')
  end
  -- let &suffixesadd = old_suffixesadd
  return file
end

function M.finddir(what, where, ...)
  -- let old_suffixesadd = &suffixesadd
  -- let &suffixesadd = ''
  local count = select(1, ...)
  if count == nil then
      count = 0
  end
  local path = ''
  local file = ''
  if fn.filereadable(where) == 1 and fn.isdirectory(where) == 0 then
    path = fn.fnamemodify(where, ':h')
  else
    path = where
  end
  if count > 0 then
    file = fn.finddir(what, fn.escape(path, ' ') .. ';', count)
  elseif #{...} == 0 then
    file = fn.finddir(what, fn.escape(path, ' ') .. ';')
  elseif count == 0 then
    file = fn.finddir(what, fn.escape(path, ' ') .. ';', -1)
  else
    file = fn.get(fn.finddir(what, fn.escape(path, ' ') .. ';', -1), count, '')
  end
  -- let &suffixesadd = old_suffixesadd
  return file
end

return M

