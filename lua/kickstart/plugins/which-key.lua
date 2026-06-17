local function gh(repo) return 'https://github.com/' .. repo end

<<<<<<< HEAD
---@module 'lazy'
---@type LazySpec
return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    enabled = true,
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function()
      require('which-key').setup(
        {
          -- delay between pressing a key and opening which-key (milliseconds)
          -- this setting is independent of vim.o.timeoutlen
          delay = 0,
          icons = { mappings = vim.g.have_nerd_font },
          -- Document existing key chains
          spec = {
            { '<leader>c', group = '[C]ode/[C]cell/[C]hunk' },
            { '<leader>i', group = '[I]nsert' },
            { '<leader>s', group = '[S]earch' },
            { '<leader>t', group = '[T]oggle' },
            { '<leader>r', group = '[R]un' },
            { '<leader>q', group = '[Q]uarto' },
          },
        }
      )
      require 'keymaps'
    end,
=======
-- Useful plugin to show you pending keybinds.
vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
>>>>>>> upstream/master
  },
}

-- vim: ts=2 sts=2 sw=2 et
