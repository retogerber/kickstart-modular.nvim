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
  -- { src = gh 'avante-corp/avante.nvim', version = 'v0.5.0' },
  { src = gh 'avante-corp/avante.nvim', version = 'main' },
}

require('img-clip').setup {
  default = {
    embed_image_as_base64 = false,
    prompt_for_file_name = false,
    drag_and_drop = { insert_mode = true },
  },
}

require('avante').setup {
  provider = 'openwebui',
  providers = {
    openwebui = {
      __inherited_from = 'openai',
      endpoint = 'http://127.0.0.1:11435/api',
      api_key_name = 'OPENWEBUI_API_KEY',
      model = 'qwen3.8:27b',
      timeout = 600000,
      use_response_api = false,
      num_ctx = 262144,
      use_ReAct_prompt = true,
      disable_tools = false,
      extra_request_body = {
        stream = true,
        files = {{type = "collection", id = "3d019716-aa20-4fdf-8f7e-d43c2869389b"}},
      },
    },
    ollama = {
      endpoint = 'http://127.0.0.1:11434', -- no /v1 suffix
      model = 'qwen3.8:27b',
      timeout = 600000,
      is_env_set = require('avante.providers.ollama').check_endpoint_alive,
      disable_tools = false,
      num_ctx = 262144,
      use_ReAct_prompt = true,
      extra_request_body = {
        stream = true
      },
    },
  },
  -- Set to true while debugging; requests and responses are kept on the filesystem.
  debug = false,
  -- mode = "legacy", -- suggest edits as diffs to review; no automatic tool execution
  behaviour = {
    auto_apply_diff_after_generation = false,
    -- Inline suggestions are experimental and off by default; keep them off so
    -- avante never claims <M-l>/<M-]>/<M-[>/<C-]>.
    auto_suggestions = false,
    -- Approval is checked by the name of the tool that finally asks for confirmation.
    -- write_to_file, str_replace and edit_file all delegate to `replace_in_file`, and
    -- the `view` tool's create command asks as `create`; without these two entries
    -- avante waits for a manual confirmation and appears stuck.
    auto_approve_tool_permissions = {
      'glob',
      'attempt_completion',
      'git_diff',
      'git_commit',
      'ls',
      'grep',
      'delete_tool_use_messages',
      'read_todos',
      'write_todos',
      'read_file_toplevel_symbols',
      -- 'str_replace',
      'view',
      -- 'write_to_file',
      -- 'insert',
      'undo_edit',
      'move_path',
      -- 'copy_path',
      -- 'create_dir',
      'think',
      'get_diagnostics',
      -- 'edit_file',
      'read_definitions',
      -- 'replace_in_file',
      -- 'create',
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
    'web_search_tavily',
    'fetch',
  },
  instructions_file = 'avante.md',
  -- Reuse telescope, which is already installed, for file/model/history selection.
  selector = { provider = 'telescope' },
}

-- vim: ts=2 sts=2 sw=2 et
