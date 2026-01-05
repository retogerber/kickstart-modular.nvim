return {
  {
    'Vigemus/iron.nvim',
    config = function()
      local iron = require 'iron.core'
      local common = require 'iron.fts.common'
      local bracketed_paste_quarto = function(lines, extras)
        lines = common.bracketed_paste_python(lines, extras)
        table.remove(lines, 1)
        table.insert(lines, ' ')
        return lines
      end
      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Automatically closes the repl window on process end
          close_window_on_exit = true,
          -- Your repl definitions come here
          repl_definition = {
            R = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { 'R' },
            },
            r = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { 'R' },
            },
            quarto = {
              command = { 'R' },
              block_dividers = {
                '```{python}',
                '```{r}',
                '```',
              },
              format = bracketed_paste_quarto,
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require('iron.view').split.vertical.botright '40%',
        },
        -- iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          toggle_repl = '<localleader>rr', -- toggles the repl open and closed.
          send_motion = '<localleader>R',
          visual_send = '<localleader>r<cr>',
          send_file = '<localleader>rf<cr>',
          send_line = '<localleader>rl',
          send_paragraph = '<localleader>rp',
          send_until_cursor = '<localleader>rU<cr>',
          send_code_block = '<localleader>rb',
          send_code_block_and_move = '<localleader>rn',
          -- send_mark = '<localleader>rm',
          -- mark_motion = '<localleader>mc',
          -- mark_visual = '<localleader>mc',
          -- remove_mark = '<localleader>md',
          cr = '<localleader>rA<cr>',
          interrupt = '<localleader>r<space>',
          exit = '<localleader>rQ',
          clear = '<localleader>rC',
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = false,
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }

      -- iron also has a list of commands, see :h iron-commands for all available commands
      vim.keymap.set('n', '<localleader>rS', '<cmd>IronRepl<cr>', { desc = '[R]EPL [S]tart' })
      vim.keymap.set('n', '<localleader>rR', '<cmd>IronRestart<cr>', { desc = '[R]EPL [R]estart' })
      vim.keymap.set('n', '<localleader>rF', '<cmd>IronFocus<cr>', { desc = '[R]EPL [F]ocus' })
      vim.keymap.set('n', '<localleader>rH', '<cmd>IronHide<cr>', { desc = '[R]EPL [H]ide' })
      vim.keymap.set('n', '<localleader>rm', function()
        local found = vim.fn.search('```{', 'bW')
        if found == 0 then
          vim.fn.search('```{', 'W')
        end
        iron.send_code_block(true)
        vim.defer_fn(function()
          vim.fn.search('```{', 'W')
          vim.cmd 'normal! j'
        end, 20)
      end, { desc = 'Execute code block + jump to next ```' })
    end,
  },
}
