local wk = require 'which-key'
local ms = vim.lsp.protocol.Methods


-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = '[D]iagnostic Quickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Terminal mode
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = 'Move focus to the left window' })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = 'Move focus to the right window' })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = 'Move focus to the lower window' })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = 'Move focus to the upper window' })


-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})


---Is the current context a code chunk?
---@param lang string language of the code chunk
---@return boolean
local is_code_chunk = function(lang)
  local current = require('otter.keeper').get_current_language_context()
  if current == lang then
    return true
  else
    return false
  end
end


--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
--- @param curly boolean
local insert_a_code_chunk = function(lang, curly)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
  local keys
  if curly == nil then
    curly = true
  end
  if is_code_chunk(lang) then
    if curly then
      keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
    else
      keys = [[o```<cr><cr>```]] .. lang .. [[<esc>o]]
    end
  else
    if curly then
      keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
    else
      keys = [[o```]] .. lang .. [[<cr>```<esc>O]]
    end
  end
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end

local insert_code_chunk = function(lang)
  insert_a_code_chunk(lang, true)
end

local insert_plain_code_chunk = function(lang)
  insert_a_code_chunk(lang, false)
end

local insert_r_chunk = function()
  insert_code_chunk 'r'
end

local insert_py_chunk = function()
  insert_code_chunk 'python'
end


--
-- normal mode
wk.add({
  { '<m-I>', insert_py_chunk, desc = 'python code chunk' },
  { '<m-i>', insert_r_chunk, desc = 'r code chunk' },
}, { mode = 'n', silent = true })
--
-- insert mode
wk.add({
  {
    mode = { 'i' },
    { '<m-->', ' <- ', desc = 'assign' },
    { '<m-I>', insert_py_chunk, desc = 'python code chunk' },
    { '<m-i>', insert_r_chunk, desc = 'r code chunk' },
    { '<m-m>', ' |>', desc = 'pipe' },
  },
}, { mode = 'i' })



wk.add({
  {
    { '<leader>ir', insert_r_chunk, desc = '[r] code chunk' },
    { '<leader>ip', insert_py_chunk, desc = '[py] code chunk' },
  },
}, { mode = 'n' })



local function new_terminal(lang)
  vim.cmd('vsplit term://' .. lang)
end

local function new_terminal_python()
  new_terminal 'python'
end

local function new_terminal_r()
  new_terminal 'R --no-save'
end

local function new_terminal_ipython()
  new_terminal 'ipython --no-confirm-exit --no-autoindent'
end

local function new_terminal_shell()
  new_terminal '$SHELL'
end


local function get_otter_symbols_lang()
  local otterkeeper = require 'otter.keeper'
  local main_nr = vim.api.nvim_get_current_buf()
  local langs = {}
  for i, l in ipairs(otterkeeper.rafts[main_nr].languages) do
    langs[i] = i .. ': ' .. l
  end
  -- promt to choose one of langs
  local i = vim.fn.inputlist(langs)
  local lang = otterkeeper.rafts[main_nr].languages[i]
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
    otter = {
      lang = lang,
    },
  }
  -- don't pass a handler, as we want otter to use it's own handlers
  vim.lsp.buf_request(main_nr, ms.textDocument_documentSymbol, params, nil)
end

vim.keymap.set('n', '<leader>os', get_otter_symbols_lang, { desc = 'otter [s]ymbols' })


wk.add({
  {
    { '<leader>ci', new_terminal_ipython, desc = 'new [i]python terminal' },
    { '<leader>cn', new_terminal_shell, desc = '[n]ew terminal with shell' },
    { '<leader>cp', new_terminal_python, desc = 'new [p]ython terminal' },
    { '<leader>cr', new_terminal_r, desc = 'new [R] terminal' },
    { '<leader>h', group = '[h]elp / [h]ide / debug' },
    { '<leader>hc', group = '[c]onceal' },
    { '<leader>ht', group = '[t]reesitter' },
    { '<leader>htt', vim.treesitter.inspect_tree, desc = 'show [t]ree' },
    { '<leader>l', group = '[l]anguage/lsp' },
    { '<leader>ld', group = '[d]iagnostics' },
    {
      '<leader>ldd',
      function()
        vim.diagnostic.enable(false)
      end,
      desc = '[d]isable',
    },
    { '<leader>lde', vim.diagnostic.enable, desc = '[e]nable' },
    { '<leader>le', vim.diagnostic.open_float, desc = 'diagnostics (show hover [e]rror)' },
    { '<leader>lg', ':Neogen<cr>', desc = 'neo[g]en docstring' },

  },
}, { mode = 'n' })

