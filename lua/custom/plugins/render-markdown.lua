local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  file_types = { 'markdown', 'quarto' },
  enabled = true,
  code = {
    enabled = true,
    sign = false,
    style = 'full',
  },
  heading = {
    enabled = true,
    sign = false,
  },
  checkbox = { enabled = true },
}

-- vim: ts=2 sts=2 sw=2 et
