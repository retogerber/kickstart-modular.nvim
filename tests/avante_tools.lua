-- Run from the repository root with: nvim --headless -u NONE -l tests/avante_tools.lua
vim.pack.add = function() end
package.preload['img-clip'] = function() return { setup = function() end } end
package.preload['avante.providers.ollama'] = function() return { check_endpoint_alive = function() end } end
local config
package.preload.avante = function() return { setup = function(value) config = value end } end
dofile 'lua/custom/plugins/avante.lua'

local tools = {}
for _, tool in ipairs(config.custom_tools()) do
  tools[tool.name] = tool
end
local list = assert(tools.list_shared_directory).func
local db = '/tungstenfs/groups/gbioinfo/DB'
local appz = '/tungstenfs/groups/gbioinfo/Appz'
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp .. '/DB/nested', 'p')
vim.fn.mkdir(tmp .. '/Appz', 'p')
vim.fn.writefile({ 'data' }, tmp .. '/DB/nested/file')
vim.fn.writefile({ 'software' }, tmp .. '/Appz/software')
assert(vim.uv.fs_symlink(tmp .. '/Appz', tmp .. '/DB/escape'))

local realpath = vim.uv.fs_realpath
vim.uv.fs_realpath = function(path)
  if path == db or path:sub(1, #db + 1) == db .. '/' then
    path = tmp .. '/DB' .. path:sub(#db + 1)
  elseif path == appz or path:sub(1, #appz + 1) == appz .. '/' then
    path = tmp .. '/Appz' .. path:sub(#appz + 1)
  end
  return realpath(path)
end

local entries, err = list { path = db }
assert(not err and vim.deep_equal(entries, { 'escape (link)', 'nested (directory)' }), vim.inspect(err or entries))
entries, err = list { path = db .. '/nested' }
assert(not err and vim.deep_equal(entries, { 'file (file)' }), vim.inspect(err or entries))
entries, err = list { path = appz }
assert(not err and vim.deep_equal(entries, { 'software (file)' }), vim.inspect(err or entries))
for _, path in ipairs {
  db .. '/escape',
  db .. '/../Appz',
  db .. '-other',
  '/etc',
  db .. '/missing',
  db .. '/nested/file',
} do
  entries, err = list { path = path }
  assert(entries == nil and err, 'Expected a rejection for ' .. path)
end
entries, err = list {}
assert(entries == nil and err)
assert(vim.deep_equal(vim.fn.readfile(tmp .. '/DB/nested/file'), { 'data' }))
vim.uv.fs_realpath = realpath
assert(vim.fn.delete(tmp, 'rf') == 0)

local module = assert(tools.module).func
local original_system = vim.system
local invoked
vim.system = function(args)
  invoked = args
  return { wait = function() return { code = 0, stdout = 'module output', stderr = '' } end }
end
local result
result, err = module { command = 'avail', argument = 'python' }
assert(result == 'module output' and not err and vim.deep_equal(invoked, { 'bash', '-lc', 'module "$@" 2>&1', 'module', 'avail', 'python' }))
for _, input in ipairs {
  { command = 'show' },
  { command = 'list', argument = 'python' },
  { command = 'avail', argument = '$(id)' },
  { command = 'load', argument = 'python' },
} do
  result, err = module(input)
  assert(result == nil and err)
end
vim.system = original_system
