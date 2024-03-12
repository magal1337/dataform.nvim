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

return M
