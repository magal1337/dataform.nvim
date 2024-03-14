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
      -- Check if table.preOps and table.postOps are not nil
      -- and if they are tables (arrays), select the first element
      local preOps = type(table.preOps) == "table" and table.preOps[1] or ""
      local postOps = type(table.postOps) == "table" and table.postOps[1] or ""
      local composite_query = preOps .. table.query .. ";\n" .. postOps
      local bq_command = "echo " .. vim.fn.shellescape(composite_query) .. " | bq query --dry_run"

      local handle = io.popen(bq_command .. " 2>/dev/null")
      local result = handle:read("*a")
      handle:close()
      print(result)
      return open_buffer_with_content(composite_query)
    end
  end
end

function M.get_compiled_sql_incremental_job()
  local command = "dataform compile --json"
  local handle = io.popen(command .. " 2>/dev/null")
  local result = handle:read("*a")
  handle:close()

  local json = vim.fn.json_decode(result)
  local tables = json.tables

  for _, table in pairs(tables) do
    if table.fileName == M.get_dataform_definitions_file_path() and table.type == "incremental" then
      -- Check if table.preOps and table.postOps are not nil
      -- and if they are tables (arrays), select the first element
      local preOps = type(table.incrementalPreOps) == "table" and table.incrementalPreOps[1] or ""
      local postOps = type(table.incrementalPostOps) == "table" and table.incrementalPostOps[1] or ""
      local composite_query = preOps .. table.incrementalQuery .. ";\n" .. postOps
      local bq_command = "echo " .. vim.fn.shellescape(composite_query) .. " | bq query --dry_run"

      local handle = io.popen(bq_command .. " 2>/dev/null")
      local result = handle:read("*a")
      handle:close()
      print(result)
      return open_buffer_with_content(composite_query)
    end
  end
end

return M
