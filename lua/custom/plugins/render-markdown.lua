return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'quarto' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      file_types = { 'markdown', 'quarto' },
      -- Render headings, code blocks, tables, etc. in normal mode only.
      -- Disable if you prefer raw markdown.
      enabled = true,
      -- Code block rendering: show language icon and a subtle background
      code = {
        enabled = true,
        sign = false,
        style = 'full',
      },
      -- Heading rendering with distinct width per level
      heading = {
        enabled = true,
        sign = false,
      },
      -- Checkbox rendering for task lists
      checkbox = { enabled = true },
    },
  },
}
