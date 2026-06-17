local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add {
  gh 'zbirenbaum/copilot.lua',
  gh 'copilotlsp-nvim/copilot-lsp',
}

require('copilot').setup {
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = '[[',
      jump_next = ']]',
      accept = '<CR>',
      refresh = 'gr',
      open = '<M-CR>',
    },
    layout = {
      position = 'bottom',
      ratio = 0.4,
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    hide_during_completion = true,
    debounce = 15,
    trigger_on_accept = true,
    keymap = {
      accept = '<M-l>',
      accept_word = false,
      accept_line = false,
      next = '<M-]>',
      prev = '<M-[>',
      dismiss = '<C-]>',
      toggle_auto_trigger = false,
    },
  },
  nes = {
    enabled = false,
    auto_trigger = false,
    keymap = {
      accept_and_goto = false,
      accept = false,
      dismiss = false,
    },
  },
  auth_provider_url = nil,
  logger = {
    file = vim.fn.stdpath 'log' .. '/copilot-lua.log',
    file_log_level = vim.log.levels.OFF,
    print_log_level = vim.log.levels.WARN,
    trace_lsp = 'off',
    trace_lsp_progress = false,
    log_lsp_messages = false,
  },
  copilot_node_command = (function()
    local node = vim.fn.exepath 'node'
    if node ~= '' then return node end
    return '/tachyon/groups/scratch/gturco/gerbreto/misc/.local/nvm/versions/node/v24.13.1/bin/node'
  end)(),
  workspace_folders = {},
  copilot_model = '',
  disable_limit_reached_message = false,
  root_dir = function() return vim.fs.dirname(vim.fs.find('.git', { upward = true })[1]) end,
  should_attach = function(_, _)
    if not vim.bo.buflisted then
      vim.notify("not attaching, buffer is not 'buflisted'", vim.log.levels.DEBUG)
      return false
    end

    if vim.bo.buftype ~= '' then
      vim.notify("not attaching, buffer 'buftype' is " .. vim.bo.buftype, vim.log.levels.DEBUG)
      return false
    end

    return true
  end,
  server = {
    type = 'nodejs',
    custom_server_filepath = nil,
  },
  server_opts_overrides = {},
}

-- vim: ts=2 sts=2 sw=2 et
