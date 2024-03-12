local M = {}

function M.get_current_file_path()
  return vim.fn.expand('%:p')
end

function M.get_dataform_definitions_file_path()
  local file = M.get_current_file_path()
  local pattern = ".*/definitions/"
  local is_match = string.match(file, pattern)
  local dataform_path = string.gsub(file, pattern, "")

  if is_match then
    return "definitions/" .. dataform_path
  else
    return error("Error: File does not exist inside a dataform definitions folder.")
  end
end

function M.compile()
  local command = "dataform compile"
  local status = os.execute(command .. " > /dev/null 2>&1")
  if status == 0 then
    print("Dataform compile successful.")
  else
    print("Error: Dataform compile failed.")
    local handle = io.popen(command .. " 2>&1")
    local result = handle:read("*a")
    handle:close()
    print(result)
  end
end

local function open_buffer_with_content(content)
  -- Create a new buffer
  local bufnr = vim.api.nvim_create_buf(false, true)
  -- Set the content of the buffer
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, vim.split(content, "\n"))
  -- Open the buffer in a new window
  vim.api.nvim_command("split")
  --                         -- Set the buffer for the new window
  vim.api.nvim_win_set_buf(0, bufnr)
end

function M.get_compiled_sql_job()
  local command = "dataform compile --json"
  local handle = io.popen(command .. " 2>/dev/null")
  local result = handle:read("*a")
  handle:close()

  local json = vim.fn.json_decode(result)
  local tables = json.tables

  for _, table in pairs(tables) do
    if table.fileName == M.get_dataform_definitions_file_path() then
      return open_buffer_with_content(table.query)
    end
  end
end

return M
