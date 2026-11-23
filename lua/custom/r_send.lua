local M = {}

function M.lines(lines)
  if #lines == 0 then return end

  -- Each send needs its own file: Quarto can queue several cells before R reads them.
  local path = vim.fn.tempname()
  if vim.fn.writefile(lines, path) ~= 0 then
    vim.notify('Could not write R code to ' .. path, vim.log.levels.ERROR)
    return
  end
  local quoted_path = vim.json.encode(path)
  local cmd = ('tryCatch(source(%s, local = .GlobalEnv, echo = TRUE, print.eval = TRUE), finally = unlink(%s))'):format(quoted_path, quoted_path)
  if not require('r.send').cmd(cmd) then vim.fn.delete(path) end
end

return M
