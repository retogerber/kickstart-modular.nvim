local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'Vigemus/iron.nvim',
  gh 'jmbuhr/otter.nvim',
}

local iron = require 'iron.core'

iron.setup {
  config = {
    scratch_repl = true,
    close_window_on_exit = true,
    repl_definition = {
      R = {
        command = { 'R', '--no-save', '--quiet' },
      },
      r = {
        command = { 'R', '--no-save', '--quiet' },
      },
      python = {
        command = { 'python' },
        format = require('iron.fts.common').bracketed_paste,
      },
    },
    repl_open_cmd = require('iron.view').split.vertical.botright '40%',
  },
  keymaps = {
    cr = '<localleader>rA<cr>',
    interrupt = '<localleader>r<space>',
    exit = '<localleader>rQ',
    clear = '<localleader>rC',
  },
  highlight = false,
  ignore_blank_lines = true,
}

vim.keymap.set('n', '<localleader>rS', '<cmd>IronRepl<cr>', { desc = '[R]EPL [S]tart' })
vim.keymap.set('n', '<localleader>rR', '<cmd>IronRestart<cr>', { desc = '[R]EPL [R]estart' })
vim.keymap.set('n', '<localleader>rH', '<cmd>IronHide<cr>', { desc = '[R]EPL [H]ide' })

local function get_ft()
  local ft = vim.bo.filetype
  if ft == 'quarto' then
    local keeper = require 'otter.keeper'
    return keeper.get_current_language_context()
  else
    return ft
  end
end

local function send_selection()
  local data = iron.mark_visual()
  local lang = get_ft()
  iron.send(lang, data)
end

local function send_line()
  local lang = get_ft()
  local linenr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local cur_line = vim.api.nvim_buf_get_lines(0, linenr, linenr + 1, 0)[1]
  local width = vim.fn.strwidth(cur_line)
  if width == 0 then return end
  iron.send(lang, cur_line)
end

local function focus_repl()
  local lang = get_ft()
  if lang == 'iron' then
    return
  else
    return iron.focus_on(lang)
  end
end

local function hide_repl()
  local lang = get_ft()
  if lang == 'iron' then
    return
  else
    return iron.hide_repl(lang)
  end
end

local function toggle_repl()
  local lang = get_ft()
  if lang == 'iron' then
    return
  else
    return iron.repl_for(lang)
  end
end

vim.keymap.set('v', '<leader>r', send_selection, { desc = 'run selection', silent = true })
vim.keymap.set('n', '<leader>rl', send_line, { desc = 'run line', silent = true })
vim.keymap.set('n', '<leader>rf', focus_repl, { desc = 'focus REPL', silent = true })
vim.keymap.set('n', '<leader>rh', hide_repl, { desc = 'hide REPL', silent = true })
vim.keymap.set('n', '<leader>rt', toggle_repl, { desc = 'toggle REPL', silent = true })

-- vim: ts=2 sts=2 sw=2 et
