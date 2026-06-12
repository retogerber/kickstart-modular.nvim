return {
  {
    'Vigemus/iron.nvim',
    config = function()
      local iron = require 'iron.core'
      -- local common = require 'iron.fts.common'
      -- local bracketed_paste_quarto = function(lines, extras)
      --   local cleaned = {}

      --   for _, line in ipairs(lines) do
      --     -- Remove fenced code block dividers
      --     if not line:match("^```") then
      --       table.insert(cleaned, line)
      --     end
      --   end

      --   -- If nothing left (e.g. user triggered on just ```), avoid sending empty paste
      --   if #cleaned == 0 then
      --     return {}
      --   end

      --   return common.bracketed_paste_python(cleaned, extras)
      -- end
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
              command = {"R", "--no-save", "--quiet"},
            },
            r = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = {"R", "--no-save", "--quiet"},
            },
	    python = {
	       command = {"python"},
	       format = require("iron.fts.common").bracketed_paste,
	    },
            -- Rmd = {
            --   command = {"R", "--no-save", "--quiet"},
            --   block_dividers = {
            --     '```{python}',
            --     '```{r}',
            --     '```{r',
            --     '```',
            --   },
            --   format = bracketed_paste_quarto,
            -- },
            -- quarto = {
            --   command = {"R", "--no-save", "--quiet"},
            --   block_dividers = {
            --     '```{python}',
            --     '```{r}',
            --     '```{r',
            --     '```',
            --   },
            --   format = bracketed_paste_quarto,
            -- },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require('iron.view').split.vertical.botright '40%',
        },
        -- iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          -- toggle_repl = '<localleader>rr', -- toggles the repl open and closed.
          -- send_motion = '<localleader>R',
          -- visual_send = '<localleader>r',
          -- send_file = '<localleader>rf<cr>',
          -- send_line = '<localleader>rL',
          -- send_paragraph = '<localleader>rp',
          -- send_until_cursor = '<localleader>rU<cr>',
          -- send_code_block = '<localleader>rb',
          -- send_code_block_and_move = '<localleader>rn',
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
      -- vim.keymap.set('n', '<localleader>rF', '<cmd>IronFocus<cr>', { desc = '[R]EPL [F]ocus' })
      vim.keymap.set('n', '<localleader>rH', '<cmd>IronHide<cr>', { desc = '[R]EPL [H]ide' })
      -- vim.keymap.set('n', '<localleader>rm', function()
      --   local found = vim.fn.search('```{', 'bW')
      --   if found == 0 then
      --     vim.fn.search('```{', 'W')
      --   end
      --   iron.send_code_block(true)
      --   vim.defer_fn(function()
      --     vim.fn.search('```{', 'W')
      --     vim.cmd 'normal! j'
      --   end, 20)
      -- end, { desc = 'Execute code block + jump to next ```' })
      local function get_ft()
        local ft = vim.bo.filetype
        if ft == "quarto" then
	  local keeper = require("otter.keeper")
          return keeper.get_current_language_context()
	else
	  return ft
	end
      end

      local function send_selection()
	local data = iron.mark_visual()
	local lang = get_ft()
	iron.send(lang, data)
      end

      local function send_line()
	local lang = get_ft()
        local linenr = vim.api.nvim_win_get_cursor(0)[1] - 1
        local cur_line = vim.api.nvim_buf_get_lines(0, linenr, linenr + 1, 0)[1]
        local width = vim.fn.strwidth(cur_line)
        if width == 0 then return end
	iron.send(lang, cur_line)
      end

      local function focus_repl()
	local lang = get_ft()
	if lang == "iron" then
	  return
	else
	  return iron.focus_on(lang)
	end
      end

      local function hide_repl()
	local lang = get_ft()
	if lang == "iron" then
	  return
	else
	  return iron.hide_repl(lang)
	end
      end

      local function toggle_repl()
	local lang = get_ft()
	if lang == "iron" then
	  return
	else
	  return iron.repl_for(lang)
	end
      end

      vim.keymap.set("v", "<leader>r", send_selection, { desc = "run selection", silent = true })
      vim.keymap.set("n", "<leader>rl", send_line, { desc = "run line", silent = true })
      vim.keymap.set("n", "<leader>rf", focus_repl, { desc = "focus REPL", silent = true })
      vim.keymap.set("n", "<leader>rh", hide_repl, { desc = "hide REPL", silent = true })
      vim.keymap.set("n", "<leader>rt", toggle_repl, { desc = "toggle REPL", silent = true })

    end,
  },
}
