-- Run from the repository root with: nvim --headless -u NONE -l tests/r_integration.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.pack.add = function() end

local r_config, quarto_config, preview_args
package.preload.r = function() return { setup = function(opts) r_config = opts end } end
package.preload.otter = function() return { setup = function() end } end
package.preload.quarto = function()
  return {
    setup = function(opts) quarto_config = opts end,
    quartoPreview = function(opts) preview_args = opts.args end,
  }
end
package.preload['quarto.runner'] = function() return { run_cell = function() end, run_all = function() end, run_range = function() end } end
package.preload['iron.fts.common'] = function() return { bracketed_paste_python = function() end } end
package.preload['iron.view'] = function() return { split = { vertical = { botright = function() end } } } end

local selection = { 'x <- 1', 'x + 1' }
local iron_sent, commands = {}, {}
local accept = true
package.preload['iron.core'] = function()
  return {
    setup = function() end,
    mark_visual = function() return selection end,
    send = function(ft, text) table.insert(iron_sent, { ft, text }) end,
  }
end
package.preload['r.send'] = function()
  return { cmd = function(cmd) table.insert(commands, cmd); return accept end }
end
local language = 'r'
package.preload['otter.keeper'] = function() return { get_current_language_context = function() return language end } end

require 'custom.plugins.r'
require 'custom.plugins.iron'
require 'custom.plugins.quarto'

assert(r_config.external_term == '' and r_config.user_maps_only)
r_config.hook.on_filetype()
assert(vim.fn.maparg(' Rs', 'n') == '<Plug>RStart')
assert(vim.fn.maparg(' Rq', 'n') == '<Plug>RClose')
assert(vim.fn.maparg(' Ro', 'n') == '<Plug>ROBToggle')

local selection_map = vim.fn.maparg(' r', 'v', false, true).callback
local line_map = vim.fn.maparg(' rl', 'n', false, true).callback
vim.bo.filetype = 'quarto'
selection_map()
local first_path = vim.json.decode(commands[1]:match 'source%((\".-\")')
assert(vim.deep_equal(vim.fn.readfile(first_path), selection))
quarto_config.codeRunner.ft_runners.r { text = { 'y <- 2' } }
local second_path = vim.json.decode(commands[2]:match 'source%((\".-\")')
assert(first_path ~= second_path and vim.deep_equal(vim.fn.readfile(second_path), { 'y <- 2' }))
assert(commands[2]:find('finally = unlink', 1, true))
vim.fn.delete(first_path)
vim.fn.delete(second_path)

vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'x + 1' })
line_map()
assert(commands[3] == 'x + 1')
language = 'python'
selection_map()
line_map()
assert(iron_sent[1][1] == 'python' and iron_sent[1][2] == selection)
assert(iron_sent[2][1] == 'python' and iron_sent[2][2] == 'x + 1')
assert(quarto_config.codeRunner.default_method == 'iron')

accept = false
language = 'r'
selection_map()
local failed_path = vim.json.decode(commands[4]:match 'source%((\".-\")')
assert(vim.fn.filereadable(failed_path) == 0, 'failed sends must remove their temporary files')

local preview = vim.fn.maparg(' qp', 'n', false, true).callback
vim.env.SSH_CONNECTION = 'test'
preview()
assert(preview_args == '--host 127.0.0.1 --port 4200 --no-browser')
vim.env.SSH_CONNECTION = nil
preview()
assert(preview_args == '')
