local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'linux-cultist/venv-selector.nvim' }

require('venv-selector').setup {
  options = {
    notify_user_on_venv_activation = true,
  },
  search = {
    cwd_venvs = {
      command = "$FD '/bin/python$' '$CWD/venvs' --full-path --color never -I -a -L",
    },
  },
}

vim.keymap.set('n', '<leader>cv', '<cmd>VenvSelect<cr>', { desc = '[C]hoose Python [v]env' })

-- vim: ts=2 sts=2 sw=2 et
