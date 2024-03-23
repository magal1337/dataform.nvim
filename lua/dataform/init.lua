-- Imports the plugin's additional Lua modules.
local project = require("dataform.project")

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

-- Routes calls made to this module to functions in the
-- plugin's other modules.
M.compile = project.compile
M.get_current_file_path = project.get_current_file_path
M.get_compiled_sql_job = project.get_compiled_sql_job
M.get_compiled_sql_incremental_job = project.get_compiled_sql_incremental_job
M.go_to_ref = project.go_to_ref
M.dataform_run_action_job = project.dataform_run_action_job
M.dataform_run_all = project.dataform_run_all
M.dataform_run_tag = project.dataform_run_tag
M.dataform_run_action_assertions = project.dataform_run_action_assertions

return M
