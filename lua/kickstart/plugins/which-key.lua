-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `opts` key (recommended), the configuration runs
-- after the plugin has been loaded as `require(MODULE).setup(opts)`.

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
          delay = 300,
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
  },
}
-- vim: ts=2 sts=2 sw=2 et
