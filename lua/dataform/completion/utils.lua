local M = {}

function M.action_names()
  local dataform = require('dataform.project')
  local compiled = dataform.compiled_project_table or {}
  local tables = compiled.tables or {}

  local names = {}
  for _, action in ipairs(tables) do
    local target = action.target or {}
    if target.name ~= nil then
      table.insert(
        names,
        {
          label = target.name,
          kind = 9, -- Module
          detail = action.fileName
        }
      )
    end
  end
  return names
end

function M.is_sqlx_js_string_syntax()
  local synID = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
  local synGroupName = vim.fn.synIDattr(synID, "name")
  return synGroupName and synGroupName == "sqlxJsString"
end

function M.trigger_characters()
  return { "'", '"' }
end

return M
