-- Run from the repository root with: nvim --headless -u NONE -l tests/python_repl.lua
local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root)
vim.pack.add = function() end
vim.g.mapleader = ' '

local python_format = function() end
package.preload['iron.fts.common'] = function()
  return { bracketed_paste = function() end, bracketed_paste_python = python_format }
end
package.preload['iron.view'] = function()
  return { split = { vertical = { botright = function() end } } }
end

local config, sent
local selection = { 'if True:', "    print('hello')" }
package.preload['iron.core'] = function()
  return {
    setup = function(opts) config = opts end,
    mark_visual = function() return selection end,
    send = function(ft, lines) sent = { ft, lines } end,
  }
end
package.preload['otter.keeper'] = function()
  return { get_current_language_context = function() return 'python' end }
end

require 'custom.plugins.iron'
assert(config.config.repl_definition.python.format == python_format, 'Python must use Iron’s Python formatter')
assert(config.config.repl_definition.python.env.PYTHON_BASIC_REPL == '1', 'Python must use the basic REPL')

local send_selection = vim.fn.maparg(vim.g.mapleader .. 'r', 'v', false, true).callback
assert(send_selection, 'Python selection mapping is missing')
for _, ft in ipairs { 'python', 'quarto' } do
  vim.bo.filetype = ft
  send_selection()
  assert(sent[1] == 'python' and sent[2] == selection, ft .. ' selection did not reach the Python REPL')
end
