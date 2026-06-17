local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { { src = gh 'snakemake/snakemake', name = 'snakemake' } }

local runtime_dir
for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
  if path:sub(-#'snakemake') == 'snakemake' then
    local candidate = path .. '/misc/vim'
    if (vim.uv or vim.loop).fs_stat(candidate) then
      runtime_dir = candidate
      break
    end
  end
end

if runtime_dir then
  vim.opt.rtp:append(runtime_dir)
  vim.cmd 'runtime! ftdetect/*'
else
  vim.filetype.add {
    extension = {
      smk = 'snakemake',
    },
    filename = {
      Snakefile = 'snakemake',
    },
  }
end

-- vim: ts=2 sts=2 sw=2 et
