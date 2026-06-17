local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'quarto-dev/quarto-nvim',
  gh 'jmbuhr/otter.nvim',
}

require('quarto').setup {
  debug = false,
  closePreviewOnExit = true,
  lspFeatures = {
    enabled = true,
    chunks = 'curly',
    languages = { 'r', 'python', 'julia', 'bash', 'html' },
    diagnostics = {
      enabled = true,
      triggers = { 'BufWritePost' },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
    enabled = true,
    default_method = 'iron',
    ft_runners = {},
    never_run = { 'yaml' },
  },
}

local quarto = require 'quarto'
local runner = require 'quarto.runner'

vim.keymap.set('n', '<leader>qp', quarto.quartoPreview, { silent = true, noremap = true, desc = '[q]uarto[p]review' })
vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
vim.keymap.set('v', '<localleader>R', runner.run_range, { desc = 'run visual range', silent = true })

-- vim: ts=2 sts=2 sw=2 et
