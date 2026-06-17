local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'obsidian-nvim/obsidian.nvim' }

require('obsidian').setup {
  legacy_commands = false,
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
    template = '~/.config/nvim/obsidian_test/templates/Daily_template.md',
    workdays_only = true,
  },
  templates = {
    folder = 'templates',
    date_format = '%A %dth %B %Y',
    time_format = '%H:%M',
  },
}

vim.keymap.set('n', '<localleader>it', function() vim.api.nvim_put({ os.date '%H:%M' }, 'c', true, true) end, { desc = '[I]nsert current [t]ime' })

-- vim: ts=2 sts=2 sw=2 et
