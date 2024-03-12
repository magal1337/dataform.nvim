local M = {}


function M.compile()
  local handle = io.popen("dataform compile 2>&1")
  local result = handle:read("*a")
  handle:close()

  if result == "" then
    print("Dataform compile successful.")
  else
    print("Error: Dataform compile failed.")
    print(result)
  end
end

return M
