local dataform = require("dataform.project")

local M = {}

-- Routes calls made to this module to functions in the
-- plugin's other modules.
M.setup = dataform.setup
M.set_dataform_workdir_project_path = dataform.set_dataform_workdir_project_path
M.compile = dataform.compile
M.compile_on_save = dataform.compile_on_save
M.get_compiled_sql_job = dataform.get_compiled_sql_job
M.go_to_ref = dataform.go_to_ref
M.run_action_job = dataform.run_action_job
M.run_all = dataform.run_all
M.run_tag = dataform.run_tag
M.run_assertions_job = dataform.run_assertions_job
M.find_model_dependencies = dataform.find_model_dependencies
M.find_model_dependents = dataform.find_model_dependents
M.completion_cmp_source = require("dataform.completion.cmp")

return M
