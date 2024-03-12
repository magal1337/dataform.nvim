local cjson = require("cjson")

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

function M.get_compiled_sql_job()
  local command = "dataform compile --json"
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()

  local json = cjson.decode(result)
  local tables = json.tables

  for _, table in pairs(tables) do
    if table.fileName == M.get_dataform_definitions_file_path() then
      return print(table.query)
    end
  end
end

return M
