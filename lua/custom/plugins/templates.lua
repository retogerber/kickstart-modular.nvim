-- Auto-insert a template into new .qmd files
local template_dir = vim.fn.stdpath('config') .. '/templates'

vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = '*.qmd',
  group = vim.api.nvim_create_augroup('qmd-template', { clear = true }),
  callback = function()
    vim.cmd('0r ' .. template_dir .. '/skeleton.qmd')
    -- Replace a placeholder with the file name
    local name = vim.fn.expand('%:t:r')
    vim.cmd('silent! %s/{{title}}/' .. name .. '/g')
    vim.cmd('normal! G')
  end,
})

return {}
