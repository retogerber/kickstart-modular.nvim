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

-- Environment modules tool. `module` is a shell function, so run it through a
-- login shell; the module command prints to stderr, hence the 2>&1.
local function module_tool()
  local commands = { 'avail', 'list', 'show' }
  return {
    name = 'module',
    description = 'Query environment modules. command "avail" lists available modules (optional argument: search term), "list" lists currently loaded modules, "show" displays information about one module (argument required).',
    param = {
      type = 'table',
      fields = {
        { name = 'command', description = 'One of: avail, list, show', type = 'string' },
        { name = 'argument', description = 'Search term for avail (optional), module name for show (required), unused for list', type = 'string', optional = true },
      },
    },
    returns = {
      { name = 'output', description = 'Output of the module command', type = 'string' },
      { name = 'error', description = 'Error message if the command failed', type = 'string', optional = true },
    },
    func = function(input, opts)
      local on_complete = opts and opts.on_complete
      local cmd, arg = input.command, input.argument
      if arg == '' then arg = nil end
      local err
      if not vim.tbl_contains(commands, cmd) then
        err = 'command must be one of: avail, list, show'
      elseif cmd == 'show' and not arg then
        err = 'show requires a module name'
      elseif cmd == 'list' and arg then
        err = 'list takes no argument'
      elseif arg and not arg:match '^[%w%._/+:@%-]+$' then
        err = 'invalid characters in argument'
      end
      if err then
        if on_complete then return on_complete(nil, err) end
        return nil, err
      end
      -- The argument is passed positionally so it is never interpreted by the shell.
      local sh = 'module "$@" 2>&1'
      local args = { 'bash', '-lc', sh, 'module', cmd }
      if arg then table.insert(args, arg) end
      local function finish(res)
        if res.code ~= 0 then return nil, (res.stdout ~= '' and res.stdout or res.stderr) end
        return res.stdout, nil
      end
      if not on_complete then return finish(vim.system(args, { text = true, timeout = 30000 }):wait()) end
      vim.system(args, { text = true, timeout = 30000 }, function(res)
        local out, e = finish(res)
        vim.schedule(function() on_complete(out, e) end)
      end)
    end,
  }
end

local function shared_directory_tool()
  local roots = {
    '/tungstenfs/groups/gbioinfo/DB',
    '/tungstenfs/groups/gbioinfo/Appz',
  }
  return {
    name = 'list_shared_directory',
    description = 'List files and directories in the shared bioinformatics DB (databases) or Appz (software and some databases) directories. Only paths within these directories are allowed.',
    param = {
      type = 'table',
      fields = {
        { name = 'path', description = 'Absolute path to a directory in DB or Appz', type = 'string' },
      },
    },
    returns = {
      { name = 'entries', description = 'Directory entries with their types', type = 'string[]' },
      { name = 'error', description = 'Error message if the directory could not be listed', type = 'string', optional = true },
    },
    func = function(input)
      local path = input.path
      if type(path) ~= 'string' or path:find('\0', 1, true) then return nil, 'A valid absolute directory path is required' end
      local root
      for _, candidate in ipairs(roots) do
        if path == candidate or path:sub(1, #candidate + 1) == candidate .. '/' then
          root = candidate
          break
        end
      end
      if not root then return nil, 'Path must be inside the shared DB or Appz directory' end

      local resolved_root, root_err = vim.uv.fs_realpath(root)
      if not resolved_root then return nil, 'Cannot resolve shared directory: ' .. tostring(root_err) end
      local resolved_path, path_err = vim.uv.fs_realpath(path)
      if not resolved_path then return nil, 'Cannot resolve path: ' .. tostring(path_err) end
      if resolved_path ~= resolved_root and resolved_path:sub(1, #resolved_root + 1) ~= resolved_root .. '/' then
        return nil, 'Path resolves outside the shared directory'
      end

      local scan, scan_err = vim.uv.fs_scandir(resolved_path)
      if not scan then return nil, 'Cannot list directory: ' .. tostring(scan_err) end
      local entries = {}
      while true do
        local name, kind = vim.uv.fs_scandir_next(scan)
        if not name then break end
        entries[#entries + 1] = string.format('%s (%s)', name, kind or 'unknown')
      end
      table.sort(entries)
      return entries, nil
    end,
  }
end

require('avante').setup {
  custom_tools = function() return { module_tool(), shared_directory_tool() } end,
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
      'module',
      'list_shared_directory',
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
