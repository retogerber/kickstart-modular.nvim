local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  { src = gh 'R-nvim/R.nvim', version = 'v1.0.0' },
}

require('r').setup {
  R_args = { '--quiet', '--no-save' },
  external_term = '',
  user_maps_only = true,
  hook = {
    on_filetype = function()
      local opts = { buffer = true, silent = true }
      vim.keymap.set('n', '<localleader>Rs', '<Plug>RStart', vim.tbl_extend('force', opts, { desc = 'Start or reopen R' }))
      vim.keymap.set('n', '<localleader>Rq', '<Plug>RClose', vim.tbl_extend('force', opts, { desc = 'Quit R' }))
      vim.keymap.set('n', '<localleader>Ro', '<Plug>ROBToggle', vim.tbl_extend('force', opts, { desc = 'R object browser' }))
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
