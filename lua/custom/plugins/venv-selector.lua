return {
  {
    'linux-cultist/venv-selector.nvim',
    ft = 'python',
    cmd = { 'VenvSelect', 'VenvSelectCached' },
    keys = {
      { '<leader>cv', '<cmd>VenvSelect<cr>', desc = '[C]hoose Python [v]env' },
    },
    opts = {
      options = {
        notify_user_on_venv_activation = true,
      },
      search = {
        cwd_venvs = {
          command = "$FD '/bin/python$' '$CWD/venvs' --full-path --color never -I -a -L",
        },
      },
    },
  },
}
