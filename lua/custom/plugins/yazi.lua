local function gh(repo) return 'https://github.com/' .. repo end

vim.g.loaded_netrwPlugin = 1

vim.pack.add {
  gh 'mikavilpas/yazi.nvim',
  gh 'nvim-lua/plenary.nvim',
}

require('yazi').setup {
  open_for_directories = false,
  keymaps = {
    show_help = '<f1>',
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>-', '<cmd>Yazi<cr>', { desc = 'Open yazi at the current file' })
vim.keymap.set('n', '<leader>cw', '<cmd>Yazi cwd<cr>', { desc = "Open the file manager in nvim's working directory" })
vim.keymap.set('n', '<c-up>', '<cmd>Yazi toggle<cr>', { desc = 'Resume the last yazi session' })

-- vim: ts=2 sts=2 sw=2 et
