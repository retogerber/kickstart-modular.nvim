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
  provider = 'claude',
  instructions_file = 'avante.md',
  -- Reuse telescope, which is already installed, for file/model/history selection.
  selector = { provider = 'telescope' },
  -- Inline suggestions are experimental and off by default; keep them off so
  -- avante never claims <M-l>/<M-]>/<M-[>/<C-]>.
  behaviour = { auto_suggestions = false },
}

-- vim: ts=2 sts=2 sw=2 et
