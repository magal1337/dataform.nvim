local utils = require('dataform.completion.utils')

local source = {}

function source:is_available()
  return utils.is_sqlx_js_string_syntax()
end

function source:complete(params, callback)
  local action_names = utils.action_names()

  callback(action_names)
end

function source:get_trigger_characters()
  return utils.trigger_characters()
end

return source
