local function gh(repo) return 'https://github.com/' .. repo end

-- Useful plugin to show you pending keybinds.
vim.pack.add { { src = gh 'folke/which-key.nvim', version = vim.version.range '3.*' } }
if not pcall(require, 'which-key.util') then
  vim.schedule(function()
    vim.notify('Skipping which-key setup: local installation is outdated. Run :lua vim.pack.update() and restart Neovim.', vim.log.levels.WARN)
  end)
  return
end

require('which-key').setup {
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    { '<leader>c', group = '[C]ode/[C]ell/[C]hunk' },
    { '<leader>i', group = '[I]nsert' },
    { '<leader>r', group = '[R]un' },
    { '<leader>q', group = '[Q]uarto' },
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

-- vim: ts=2 sts=2 sw=2 et
