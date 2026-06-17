<<<<<<< HEAD
---@module 'lazy'
---@type LazySpec
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    dev = false,
    branch = 'main',

    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        init = function()
          -- Disable entire built-in ftplugin mappings to avoid conflicts.
          -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
          vim.g.no_plugin_maps = true

          -- Or, disable per filetype (add as you like)
          -- vim.g.no_python_maps = true
          -- vim.g.no_ruby_maps = true
          -- vim.g.no_rust_maps = true
          -- vim.g.no_go_maps = true
        end,
        config = function()
          require('nvim-treesitter-textobjects').setup {
            select = {
              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,
            },
          }

          -- select
          vim.keymap.set({ 'x', 'o' }, 'am', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'x', 'o' }, 'im', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
          end)
          vim.keymap.set({ 'x', 'o' }, 'ac', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
          end)
          vim.keymap.set({ 'x', 'o' }, 'ic', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
          end)
          -- You can also use captures from other query groups like `locals.scm`
          vim.keymap.set({ 'x', 'o' }, 'as', function()
            require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
          end)

          -- move
          vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@class.inner', 'textobjects')
          end)
          -- You can also pass a list to group multiple queries.
          vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
            require('nvim-treesitter-textobjects.move').goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
          end)
          -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
          vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
            require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
          end)

          vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
            require('nvim-treesitter-textobjects.move').goto_next_end('@class.inner', 'textobjects')
          end)

          vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
            require('nvim-treesitter-textobjects.move').goto_previous_start('@class.inner', 'textobjects')
          end)

          vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
          end)
          vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
            require('nvim-treesitter-textobjects.move').goto_previous_end('@class.inner', 'textobjects')
          end)
        end,
      },
    },

    build = ':TSUpdate',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      -- ensure parsers are installed
      local parsers = {
        'r', 'python', 'markdown', 'markdown_inline', 'julia', 'bash', 'yaml',
        'lua', 'luadoc', 'vim', 'query', 'vimdoc', 'latex', 'html', 'css',
        'dot', 'javascript', 'mermaid', 'norg', 'typescript', 'c', 'diff',
      }
      require('nvim-treesitter').install(parsers)
=======
local function gh(repo) return 'https://github.com/' .. repo end
>>>>>>> upstream/master

-- [[ Configure Treesitter ]]
--  Used to highlight, edit, and navigate code
--
--  See `:help nvim-treesitter-intro`

-- NOTE: You can also specify a branch or a specific commit
vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

-- Ensure basic parsers are installed
local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if a parser exists and load it
  if not vim.treesitter.language.add(language) then return end
  -- Enable syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Enable treesitter based folds
  -- For more info on folds see `:help folds`
  -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  -- vim.wo.foldmethod = 'expr'

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  -- Enable treesitter based indentation
  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- Enable the parser if it is already installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})

<<<<<<< HEAD
          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
}
=======
-- vim: ts=2 sts=2 sw=2 et
>>>>>>> upstream/master
