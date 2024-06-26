vim.notify = require("notify")
local utils = require("dataform.utils")

local dataform = {}
dataform.compiled_project_table = {}

function dataform.set_dataform_workdir_project_path()
  local current_path = utils.get_current_file_path()
  local is_match = string.match(current_path, "/definitions/.*")

  if is_match then
    local parent_path = current_path:gsub("/definitions/.*", "/")
    vim.api.nvim_set_current_dir(parent_path)
  else
    return vim.notify("Error: File does not exist inside dataform definitions folder.", 4)
  end
end

local function get_dataform_definitions_file_path()
  local file = utils.get_current_file_path()
  local pattern = ".*/definitions/"
  local is_match = string.match(file, pattern)
  local dataform_path = string.gsub(file, pattern, "")

  if is_match then
    return "definitions/" .. dataform_path
  end
  return vim.notify("Error: File does not exist inside dataform definitions folder.", 4)
end

function dataform.go_to_ref()
  local line = vim.fn.getline('.')
  local _, _, schema, table_name = line:find('%${%s*ref%(%s*["\']([^"]+)["\']%s*,%s*["\']([^"]+)["\']%s*%)%s*}')

  local df_tables = dataform.compiled_project_table.tables
  local df_declarations = dataform.compiled_project_table.declarations
  local tables = vim.fn.extend(df_tables, df_declarations)

  for _, table in pairs(tables) do
    if table.target.schema == schema and table.target.name == table_name then
      return utils.open_file(table.fileName)
    end
  end
end

function dataform.compile()
  local command = "dataform compile"
  local status, content = utils.os_execute_with_status(command .. " --json", true)
  if status == 0 then
    dataform.compiled_project_table = vim.fn.json_decode(content)
    vim.notify("Dataform compiled successfully.", 2)
  else
    local _, content_error = utils.os_execute_with_status(command)
    vim.notify("Error: Dataform compile failed. \n\n" .. content_error, 4)
  end
end

function dataform.get_compiled_sql_job(incremental)
  local tables = dataform.compiled_project_table.tables

  for _, table in pairs(tables) do
    if table.fileName == get_dataform_definitions_file_path() then
      local preOpsKey = incremental and "incrementalPreOps" or "preOps"
      local postOpsKey = incremental and "incrementalPostOps" or "postOps"
      local queryKey = incremental and "incrementalQuery" or "query"

      local preOps = type(table[preOpsKey]) == "table" and table[preOpsKey][1] or ""
      local postOps = type(table[postOpsKey]) == "table" and table[postOpsKey][1] or ""

      local preOpsClean = preOps:gsub("%s+$", "")
      if preOpsClean:sub(-1) ~= ";" and preOps ~= "" then preOps = preOps .. ";" end

      local composite_query = preOps .. table[queryKey] .. ";\n" .. postOps
      local bq_command = "echo " .. vim.fn.shellescape(composite_query) .. " | bq query --dry_run"

      local _, result = utils.os_execute_with_status(bq_command)

      vim.notify(result, 3)
      return utils.open_buffer_with_content(composite_query)
    end
  end
end

function dataform.run_all()
  local command = "dataform run"
  local status, content = utils.os_execute_with_status(command)
  if status == 0 then
    return vim.notify("Dataform run executed successfully.", 2)
  end
  return vim.notify("Error: Dataform run failed. \n\n" .. content, 4)
end

function dataform.run_tag(args)
  local tags = args or ""
  local command = "dataform run --tags=" .. tags
  local status, content = utils.os_execute_with_status(command)
  if status == 0 then
    return vim.notify("Dataform tag run executed successfully.", 2)
  end

  return vim.notify("Error: Dataform tag run failed. \n\n" .. content, 4)
end

function dataform.run_action_job(full_refresh)
  local full_refresh = full_refresh or false
  local df_tables = dataform.compiled_project_table.tables
  local df_operations = dataform.compiled_project_table.operations
  local tables = vim.fn.extend(df_tables, df_operations)

  for _, table in pairs(tables) do
    if table.fileName == get_dataform_definitions_file_path() then
      local action = table.target.database .. "." .. table.target.schema .. "." .. table.target.name
      local command = "dataform run --full-refresh=" .. tostring(full_refresh) .. " --actions=" .. action

      local status, content = utils.os_execute_with_status(command)

      if status == 0 then
        return vim.notify("Dataform run executed successfully.", 2)
      end
      return vim.notify("Error: Dataform run failed. \n\n" .. content, 4)
    end
  end
end

function dataform.run_assertions_job()
  local assertions = dataform.compiled_project_table.assertions
  local target_assertions = {}

  for _, assertion in pairs(assertions) do
    if assertion.fileName == get_dataform_definitions_file_path() then
      local action = assertion.target.database .. "." .. assertion.target.schema .. "." .. assertion.target.name
      table.insert(target_assertions, action)
    end
  end
  -- check if target_assertions is still empty and if it is raise error
  if vim.tbl_isempty(target_assertions) then
    return vim.notify("Error: There is no assertions for this file.", 4)
  end

  for _, assertion in pairs(target_assertions) do
    local command = "dataform run " .. "--actions=" .. assertion
    local status, content = utils.os_execute_with_status(command)

    if status == 0 then
      vim.notify("Dataform assertion: \n" .. assertion .. "\nexecuted successfully.", 2)
    else
      vim.notify("Error: Dataform assertions failed. \n\n" .. content, 4)
    end
  end
end

local function get_all_models()
  local tables = dataform.compiled_project_table.tables
  local operations = dataform.compiled_project_table.operations or {}
  local declarations = dataform.compiled_project_table.declarations
  local all_models = vim.fn.extend(tables, operations)

  return vim.fn.extend(all_models, declarations)
end

local function find_model_by_file_path(all_models, target_file_path)
  for _, model in pairs(all_models) do
    if model.fileName == target_file_path then
      return model
    end
  end
  return nil
end

local function find_file_name_by_schema_name(all_models, schema, name)
  for _, model in pairs(all_models) do
    if model.target.schema == schema and model.target.name == name then
      return model.fileName
    end
  end
  return nil
end

function dataform.find_model_dependents()
  local all_models = get_all_models()
  local target_file_path = get_dataform_definitions_file_path()
  local target_model = find_model_by_file_path(all_models, target_file_path)
  local target_paths = {}

  local schema = target_model.target.schema
  local name = target_model.target.name

  for _, model in pairs(all_models) do
    local dependency_targets = model.dependencyTargets
    if dependency_targets then
      for _, dependency in pairs(dependency_targets) do
        if dependency.schema == schema and dependency.name == name then
          table.insert(target_paths, model.fileName)
        end
      end
    end
  end

  return utils.custom_picker("Model Dependents", target_paths)
end

function dataform.find_model_dependencies()
  local all_models = get_all_models()
  local target_file_path = get_dataform_definitions_file_path()
  local target_model = find_model_by_file_path(all_models, target_file_path)
  local target_paths = {}

  if not target_model then
    return utils.custom_picker("Model Dependencies", target_paths)
  end

  local dependencies = target_model.dependencyTargets
  if dependencies then
    for _, dependency in pairs(dependencies) do
      local schema = dependency.schema
      local name = dependency.name
      local target_path = find_file_name_by_schema_name(all_models, schema, name)
      table.insert(target_paths, target_path)
    end
  end

  return utils.custom_picker("Model Dependencies", target_paths)
end

return dataform
