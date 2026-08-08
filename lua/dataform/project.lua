local utils = require("dataform.utils")

local dataform = {}
dataform.compiled_project_table = {}
dataform._compile_hash = nil

---@alias DataformUserConfig table
---@field compile_on_save boolean? (default: true) Automatically compile Dataform project on saving a .sqlx file.
---@field bq_dry_run boolean? (default: true) Run `bq query --dry_run` after opening the SQL buffer and show the result as a notification.
---@field cache boolean? (default: true) Skip recompilation when project files are unchanged (in-memory check).
---@field cache_persist boolean? (default: false) Persist cache to disk so it survives across Neovim sessions.
local default_config = {
  compile_on_save = true,
  bq_dry_run = true,
  cache = true,
  cache_persist = false,
}
dataform.config = vim.deepcopy(default_config)

---@param user_config DataformUserConfig?
function dataform.setup(user_config)
  user_config = user_config or {}
  for key, value in pairs(user_config) do
    if default_config[key] ~= nil then
      dataform.config[key] = value
    end
  end
end

local function compute_project_hash(cwd)
  local uv = vim.uv or vim.loop
  local entries = {}
  local single_files = {
    cwd .. "/package.json",
    cwd .. "/dataform.json",
    cwd .. "/workflow_settings.yaml",
    cwd .. "/workflow_settings.yml",
  }
  for _, path in ipairs(single_files) do
    local stat = uv.fs_stat(path)
    if stat then
      table.insert(entries, path .. ":" .. stat.mtime.sec .. ":" .. stat.size)
    end
  end
  for _, dir in ipairs({ cwd .. "/includes/", cwd .. "/definitions/" }) do
    local raw = vim.fn.glob(dir .. "**", false, false)
    if raw ~= "" then
      for _, path in ipairs(vim.split(raw, "\n", { plain = true })) do
        if path ~= "" then
          local stat = uv.fs_stat(path)
          if stat then
            table.insert(entries, path .. ":" .. stat.mtime.sec .. ":" .. stat.size)
          end
        end
      end
    end
  end
  table.sort(entries)
  return vim.fn.sha256(table.concat(entries, "|"))
end

local function get_cache_paths(cwd)
  local base = vim.fn.stdpath("cache") .. "/dataform.nvim/" .. vim.fn.sha256(cwd):sub(1, 16)
  return { dir = base, hash_file = base .. "/hash", json_file = base .. "/compiled.json" }
end

local function load_from_cache(paths, current_hash)
  local hash_file = io.open(paths.hash_file, "r")
  if not hash_file then return nil end
  local stored_hash = hash_file:read("*l")
  hash_file:close()

  if stored_hash ~= current_hash then return nil end

  local json_file = io.open(paths.json_file, "r")
  if not json_file then return nil end
  local cached = json_file:read("*all")
  json_file:close()

  local ok, decoded = pcall(vim.fn.json_decode, cached)
  if ok and type(decoded) == "table" then return decoded end
  return nil
end

local function save_to_cache(paths, current_hash, content)
  vim.fn.mkdir(paths.dir, "p")
  local json_file = io.open(paths.json_file, "w")
  if json_file then json_file:write(content); json_file:close() end
  local hash_file = io.open(paths.hash_file, "w")
  if hash_file then hash_file:write(current_hash); hash_file:close() end
end

function dataform.set_dataform_workdir_project_path()
  local current_path = utils.get_current_file_path()
  local is_match = string.match(current_path, "/definitions/.*")

  if is_match then
    local parent_path = current_path:gsub("/definitions/.*", "/")
    vim.api.nvim_set_current_dir(parent_path)
  else
    return utils.notify(
      "Error: File does not exist inside dataform definitions folder.",
      vim.log.levels.ERROR
    )
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
  return utils.notify(
    "Error: File does not exist inside dataform definitions folder.",
    vim.log.levels.ERROR
  )
end

function dataform.go_to_ref()
  local line = vim.fn.getline('.')
  local _, _, schema, table_name = line:find('%${%s*ref%(%s*["\']([^"]+)["\']%s*,%s*["\']([^"]+)["\']%s*%)%s*}')
  if not schema then
      _, _, table_name = line:find('%${%s*ref%(%s*["\']([^"]+)["\']%s*%)%s*}')
  end

  local df_tables = dataform.compiled_project_table.tables or {}
  local df_declarations = dataform.compiled_project_table.declarations or {}
  local actions = vim.fn.extend(df_tables, df_declarations)

  for _, action in pairs(actions) do
    if action.target.name == table_name and (action.target.schema == schema or not schema)  then
      return utils.open_file(action.fileName)
    end
  end
end

function dataform.compile()
  local command = "dataform compile"

  if not dataform.config.cache then
    local status, content = utils.os_execute_with_status(command .. " --json", true)
    if status == 0 then
      dataform.compiled_project_table = vim.fn.json_decode(content)
      utils.notify("Dataform compiled successfully.", vim.log.levels.INFO)
    else
      local _, err = utils.os_execute_with_status(command)
      utils.notify("Error: Dataform compile failed. \n\n" .. err, vim.log.levels.ERROR)
    end
    return
  end

  local cwd = vim.fn.getcwd()
  local current_hash = compute_project_hash(cwd)

  if current_hash == dataform._compile_hash then
    utils.notify("Dataform compiled successfully (cached).", vim.log.levels.INFO)
    return
  end

  if dataform.config.cache_persist then
    local paths = get_cache_paths(cwd)
    local cached = load_from_cache(paths, current_hash)
    if cached then
      dataform.compiled_project_table = cached
      dataform._compile_hash = current_hash
      utils.notify("Dataform compiled successfully (cached).", vim.log.levels.INFO)
      return
    end
  end

  local status, content = utils.os_execute_with_status(command .. " --json", true)
  if status == 0 then
    dataform.compiled_project_table = vim.fn.json_decode(content)
    dataform._compile_hash = current_hash
    utils.notify("Dataform compiled successfully.", vim.log.levels.INFO)
    if dataform.config.cache_persist then
      save_to_cache(get_cache_paths(cwd), current_hash, content)
    end
  else
    local _, err = utils.os_execute_with_status(command)
    utils.notify("Error: Dataform compile failed. \n\n" .. err, vim.log.levels.ERROR)
  end
end

function dataform.get_compiled_sql_job(incremental)
  local actions = dataform.compiled_project_table.tables

  for _, action in pairs(actions) do
    if action.fileName == get_dataform_definitions_file_path() then
      local preOpsKey = incremental and "incrementalPreOps" or "preOps"
      local postOpsKey = incremental and "incrementalPostOps" or "postOps"
      local queryKey = incremental and "incrementalQuery" or "query"

      local preOps = type(action[preOpsKey]) == "table" and action[preOpsKey][1] or ""
      local postOps = type(action[postOpsKey]) == "table" and action[postOpsKey][1] or ""

      local preOpsClean = preOps:gsub("%s+$", "")
      if preOpsClean:sub(-1) ~= ";" and preOps ~= "" then preOps = preOps .. ";" end

      local composite_query = preOps .. action[queryKey] .. ";\n" .. postOps

      utils.open_buffer_with_content(composite_query)

      if dataform.config.bq_dry_run then
        local bq_command = "echo " .. vim.fn.shellescape(composite_query) .. " | bq query --dry_run"
        local stdout_lines = {}
        vim.fn.jobstart({ "sh", "-c", bq_command }, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data then vim.list_extend(stdout_lines, data) end
          end,
          on_exit = function(_, code)
            local trimmed = table.concat(stdout_lines, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
            if trimmed ~= "" then
              vim.schedule(function()
                utils.notify(trimmed, code == 0 and vim.log.levels.INFO or vim.log.levels.WARN)
              end)
            end
          end,
        })
      end

      return
    end
  end
end

function dataform.run_all()
  local command = "dataform run"
  local status, content = utils.os_execute_with_status(command)
  if status == 0 then
    return utils.notify(
      "Dataform run executed successfully.",
      vim.log.levels.INFO
    )
  end
  return utils.notify(
    "Error: Dataform run failed. \n\n" .. content,
    vim.log.levels.ERROR
  )
end

function dataform.run_tag(args)
  local tags = args or ""
  local command = "dataform run --tags=" .. tags
  local status, content = utils.os_execute_with_status(command)
  if status == 0 then
    return utils.notify(
      "Dataform tag run executed successfully.",
      vim.log.levels.INFO
    )
  end

  return utils.notify(
    "Error: Dataform tag run failed. \n\n" .. content,
    vim.log.levels.ERROR
  )
end

function dataform.run_action_job(full_refresh)
  local full_refresh = full_refresh or false
  local df_tables = dataform.compiled_project_table.tables or {}
  local df_operations = dataform.compiled_project_table.operations or {}
  local actions = vim.fn.extend(df_tables, df_operations)

  for _, action in pairs(actions) do
    if action.fileName == get_dataform_definitions_file_path() then
      local action = action.target.database .. "." .. action.target.schema .. "." .. action.target.name
      local command = "dataform run --full-refresh=" .. tostring(full_refresh) .. " --actions=" .. action

      local status, content = utils.os_execute_with_status(command)

      if status == 0 then
        return utils.notify(
          "Dataform run executed successfully.",
          vim.log.levels.INFO
        )
      end
      return utils.notify(
        "Error: Dataform run failed. \n\n" .. content,
        vim.log.levels.ERROR
      )
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
    return utils.notify(
      "Error: There is no assertions for this file.",
      vim.log.levels.ERROR
    )
  end

  for _, assertion in pairs(target_assertions) do
    local command = "dataform run " .. "--actions=" .. assertion
    local status, content = utils.os_execute_with_status(command)

    if status == 0 then
      utils.notify(
        "Dataform assertion: \n" .. assertion .. "\nexecuted successfully.",
        vim.log.levels.INFO
      )
    else
      utils.notify(
        "Error: Dataform assertions failed. \n\n" .. content,
        vim.log.levels.ERROR
      )
    end
  end
end

local function get_all_models()
  local tables = dataform.compiled_project_table.tables or {}
  local operations = dataform.compiled_project_table.operations or {}
  local declarations = dataform.compiled_project_table.declarations or {}
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

function dataform.compile_on_save()
  if dataform.config.compile_on_save then
    dataform.compile()
  end
end

function dataform.clear_cache()
  dataform._compile_hash = nil
  local cwd = vim.fn.getcwd()
  local paths = get_cache_paths(cwd)
  os.remove(paths.json_file)
  os.remove(paths.hash_file)
  vim.fn.delete(paths.dir, "d")
  utils.notify("Dataform cache cleared.", vim.log.levels.INFO)
end

return dataform
