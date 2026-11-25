local function gh(repo) return 'https://github.com/' .. repo end

-- Avante needs Neovim >= 0.12. The sidebar buffers use the `Avante*` filetypes;
-- `Avante` is added to render-markdown's file_types, and the `AvanteInput`
-- completion source is registered in kickstart/plugins/blink-cmp.lua.
vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'MunifTanjim/nui.nvim',
  gh 'ColinKennedy/mega.logging',
  gh 'ColinKennedy/mega.cmdparse',
  gh 'HakonHarnes/img-clip.nvim',
  { src = gh 'avante-corp/avante.nvim', version = 'v0.5.0' },
}

require('img-clip').setup {
  default = {
    embed_image_as_base64 = false,
    prompt_for_file_name = false,
    drag_and_drop = { insert_mode = true },
  },
}

require('avante').setup {
  provider = 'ollama',
  providers = {
    ollama = {
      endpoint = 'http://127.0.0.1:11434', -- no /v1 suffix
      model = 'qwen3.8:27b',
      -- Large tool calls (write_to_file sends the whole file) are slow on a 27b model over a tunnel.
      timeout = 600000,
    },
  },
  -- Set to true while debugging; requests/responses are kept on disk (see :messages / :AvanteShowLogs).
  debug = false,
  behaviour = {
    -- Inline suggestions are experimental and off by default; keep them off so
    -- avante never claims <M-l>/<M-]>/<M-[>/<C-]>.
    auto_suggestions = false,
    -- Approval is checked by the name of the tool that finally asks for confirmation.
    -- write_to_file, str_replace and edit_file all delegate to `replace_in_file`, and
    -- the `view` tool's create command asks as `create`; without these two entries
    -- avante waits for a manual confirmation and appears stuck.
    auto_approve_tool_permissions = {
      'glob',
      'git_diff',
      'git_commit',
      'ls',
      'grep',
      'delete_tool_use_messages',
      'read_todos',
      'write_todos',
      'read_file_toplevel_symbols',
      'str_replace',
      'view',
      'write_to_file',
      'insert',
      'undo_edit',
      'move_path',
      'copy_path',
      'create_dir',
      'think',
      'get_diagnostics',
      'edit_file',
      'read_definitions',
      'replace_in_file',
      'create',
    },
    use_cwd_as_project_root = true,
  },
  disabled_tools = {
    'dispatch_agent',
    'rag_search',
    'run_python',
    'read_global_file',
    'write_global_file',
    'delete_path',
    'bash',
    'attempt_completion',
    'web_search_tavily',
    'fetch',
  },
  instructions_file = 'avante.md',
  -- Reuse telescope, which is already installed, for file/model/history selection.
  selector = { provider = 'telescope' },
}

-- vim: ts=2 sts=2 sw=2 et
