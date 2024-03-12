local M = {}

function M.compile()
  local command = "dataform compile"
  local status = os.execute(command)
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

return M
