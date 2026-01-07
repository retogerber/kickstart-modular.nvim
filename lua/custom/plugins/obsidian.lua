return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*', -- use latest release, remove to use latest commit
    ft = 'markdown',
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in the next major release
      workspaces = {
        {
          name = 'work',
          path = '~/.config/nvim/obsidian_test',
        },
      },
      daily_notes = {
        folder = '.',
        date_format = '%Y/%m/%Y_%m_%d',
        alias_format = '%dth %B %Y',
        default_tags = { 'type/daily-notes' },
        template = 'templates/Daily_template.md',
        workdays_only = true,
      },
      templates = {
        folder = 'templates',
        date_format = '%A %dth %B %Y',
        time_format = '%H:%M',
      },
    },
    -- vim.keymap.set('n', '<localleader>on', function()
    --   local api = require 'obsidian.api'
    --   api.new_from_template('id', '/Daily_template.md')
    -- end, { desc = 'Execute code block + jump to next ```' }),
  },
}
