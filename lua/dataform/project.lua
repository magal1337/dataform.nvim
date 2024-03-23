vim.notify = require("notify")
local M = {}
M.dataform_project_json = {}


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

local function open_file(file_path)
  vim.cmd("edit " .. file_path)
end

function M.go_to_ref()
  -- Get the current line
  local line = vim.fn.getline('.')
  -- Find the position of the 'ref{' pattern
  local _, _, schema, table_name = line:find('%${%s*ref%(%s*"([^"]+)"%s*,%s*"([^"]+)"%s*%)%s*}')

  local df_tables = M.dataform_project_json.tables
  local df_declarations = M.dataform_project_json.declarations
  -- union df_tables and df_declarations array to get all tables
  local tables = vim.fn.extend(df_tables, df_declarations)

  for _, table in pairs(tables) do
    if table.target.schema == schema and table.target.name == table_name then
      return open_file(table.fileName)
    end
  end
end

function M.compile()
  local command = "dataform compile"
  local status = os.execute(command .. " > /dev/null 2>&1")
  if status == 0 then
    local handle = io.popen(command .. " --json" .. " 2>/dev/null")
    local result = handle:read("*a")
    handle:close()
    M.dataform_project_json = vim.fn.json_decode(result)
    vim.notify("Dataform compile successful.", 2)
  else
    vim.notify("Error: Dataform compile failed.", 4)
    local handle = io.popen(command .. " 2>&1")
    local result = handle:read("*a")
    handle:close()
    vim.notify(result, 4)
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
  local tables = M.dataform_project_json.tables

  for _, table in pairs(tables) do
    if table.fileName == M.get_dataform_definitions_file_path() then
      -- Check if table.preOps and table.postOps are not nil
      -- and if they are tables (arrays), select the first element
      local preOps = type(table.preOps) == "table" and table.preOps[1] or ""
      local postOps = type(table.postOps) == "table" and table.postOps[1] or ""

      local preOpsClean = preOps:gsub("%s+$", "")
      if preOpsClean:sub(-1) ~= ";" and preOps ~= "" then preOps = preOps .. ";" end

      local composite_query = preOps .. table.query .. ";\n" .. postOps
      local bq_command = "echo " .. vim.fn.shellescape(composite_query) .. " | bq query --dry_run"

      local handle = io.popen(bq_command .. " 2>/dev/null")
      local result = handle:read("*a")
      handle:close()
      vim.notify(result, 3)
      return open_buffer_with_content(composite_query)
    end
  end
end

function M.get_compiled_sql_incremental_job()
  local tables = M.dataform_project_json.tables

  for _, table in pairs(tables) do
    if table.fileName == M.get_dataform_definitions_file_path() and table.type == "incremental" then
      -- Check if table.preOps and table.postOps are not nil
      -- and if they are tables (arrays), select the first element
      local preOps = type(table.incrementalPreOps) == "table" and table.incrementalPreOps[1] or ""
      local postOps = type(table.incrementalPostOps) == "table" and table.incrementalPostOps[1] or ""

      local preOpsClean = preOps:gsub("%s+$", "")
      if preOpsClean:sub(-1) ~= ";" and preOps ~= "" then preOps = preOps .. ";" end

      local composite_query = preOps .. table.incrementalQuery .. ";\n" .. postOps
      local bq_command = "echo " .. vim.fn.shellescape(composite_query) .. " | bq query --dry_run"

      local handle = io.popen(bq_command .. " 2>/dev/null")
      local result = handle:read("*a")
      handle:close()
      vim.notify(result, 3)
      return open_buffer_with_content(composite_query)
    end
  end
end

function M.dataform_run_all()
  local command = "dataform run"
  local n = os.tmpname()
  local status = os.execute(command .. " > " .. n .. " 2>&1")
  -- read file n as text
  local f = io.open(n, "r")
  local content = f:read("*all")
  f:close()
  os.remove(n)
  if status == 0 then
    return vim.notify("Dataform run executed successfully.", 2)
  else
    return vim.notify("Error: Dataform run failed. \n\n" .. content, 4)
  end
end

function M.dataform_run_tag(args)
  local tag = args
  local command = "dataform run --tags=" .. tag
  local n = os.tmpname()
  local status = os.execute(command .. " > " .. n .. " 2>&1")
  -- read file n as text
  local f = io.open(n, "r")
  local content = f:read("*all")
  f:close()
  os.remove(n)

  if status == 0 then
    return vim.notify("Dataform tag run executed successfully.", 2)
  else
    return vim.notify("Error: Dataform tag run failed. \n\n" .. content, 4)
  end
end

function M.dataform_run_action_job(full_refresh)
  local full_refresh = full_refresh or false
  local df_tables = M.dataform_project_json.tables
  local df_operations = M.dataform_project_json.operations
  local tables = vim.fn.extend(df_tables, df_operations)
  for _, table in pairs(tables) do
    if table.fileName == M.get_dataform_definitions_file_path() then
      local action = table.target.database .. "." .. table.target.schema .. "." .. table.target.name
      local command = "dataform run --full-refresh=" .. tostring(full_refresh) .. " --actions=" .. action
      local n = os.tmpname()
      local status = os.execute(command .. " > " .. n .. " 2>&1")
      -- read file n as text
      local f = io.open(n, "r")
      local content = f:read("*all")
      f:close()

      if status == 0 then
        return vim.notify("Dataform run executed successfully.", 2)
      else
        return vim.notify("Error: Dataform run failed. \n\n" .. content, 4)
      end
      os.remove(n)
    end
  end
end

function M.dataform_run_action_assertions()
  local assertions = M.dataform_project_json.assertions
  local target_assertions = {}
  for _, assertion in pairs(assertions) do
    if assertion.fileName == M.get_dataform_definitions_file_path() then
      local action = assertion.target.database .. "." .. assertion.target.schema .. "." .. assertion.target.name
      table.insert(target_assertions, action)
    end
  end
  -- union all table elements as a single string separeted by ','
  local final_actions = table.concat(target_assertions, ",")
  local command = "dataform run " .. "--actions=" .. final_actions
  local n = os.tmpname()
  local status = os.execute(command .. " > " .. n .. " 2>&1")
  -- read file n as text
  local f = io.open(n, "r")
  local content = f:read("*all")
  f:close()
  os.remove(n)
  if status == 0 then
    return vim.notify("Dataform assertions executed successfully.", 2)
  else
    return vim.notify("Error: Dataform assertions failed. \n\n" .. content, 4)
  end
end

return M
