local utils = {}


function utils.get_current_file_path()
  return vim.fn.expand('%:p')
end

function utils.open_file(file_path)
  vim.cmd("edit " .. file_path)
end

function utils.os_execute_with_status(command, json_output)
  local is_json = json_output or false
  local handle_stdout = is_json and " 2>/dev/null" or " 2>&1"
  local n = os.tmpname()
  local status = os.execute(command .. " > " .. n .. handle_stdout)
  local f = io.open(n, "r")
  local content = f:read("*all")
  f:close()
  os.remove(n)

  return status, content
end

function utils.open_buffer_with_content(content)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, vim.split(content, "\n"))
  vim.api.nvim_command("split")
  vim.api.nvim_win_set_buf(0, bufnr)
end

return utils
