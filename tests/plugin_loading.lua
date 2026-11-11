-- Run from the repository root with: nvim --headless -u NONE -l tests/plugin_loading.lua
local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root)

local stdpath = vim.fn.stdpath
vim.fn.stdpath = function(what)
  if what == 'config' then return root end
  return stdpath(what)
end

local loaded = {}
for _, module in ipairs { 'options', 'pack', 'keymaps' } do
  package.preload[module] = function() loaded[module] = true end
end

for _, group in ipairs { 'kickstart', 'custom' } do
  for file, kind in vim.fs.dir(root .. '/lua/' .. group .. '/plugins') do
    if kind == 'file' and file:match '%.lua$' and file ~= 'init.lua' then
      local module = group .. '.plugins.' .. file:gsub('%.lua$', '')
      package.preload[module] = function() loaded[module] = true end
    end
  end
end

dofile(root .. '/init.lua')

assert(loaded['kickstart.plugins.telescope'], 'core plugins were not loaded')
assert(loaded['custom.plugins.quarto'], 'custom plugins were not loaded')
for file, kind in vim.fs.dir(root .. '/lua/custom/plugins') do
  if kind == 'file' and file:match '%.lua$' and file ~= 'init.lua' then
    local module = 'custom.plugins.' .. file:gsub('%.lua$', '')
    assert(loaded[module], module .. ' was not loaded')
  end
end
assert(loaded.keymaps, 'startup did not reach keymaps')

package.loaded['custom.plugins.obsidian'] = nil
package.preload['custom.plugins.obsidian'] = nil
vim.pack.add = function() end
local obsidian_config
package.preload.obsidian = function()
  return { setup = function(config) obsidian_config = config end }
end
require 'custom.plugins.obsidian'

local workspace = vim.fs.joinpath(root, 'obsidian_test')
assert(obsidian_config.workspaces[1].path == workspace, 'Obsidian workspace does not use the active config path')
assert(
  obsidian_config.daily_notes.template == vim.fs.joinpath(workspace, 'templates', 'Daily_template.md'),
  'Obsidian template does not use the active config path'
)
