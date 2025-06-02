local utils = require('dataform.completion.utils')

--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts
  return self
end

function source:enabled()
  return vim.bo.filetype == 'sqlx' and utils.is_sqlx_js_string_syntax()
end

function source:get_trigger_characters()
  return utils.trigger_characters()
 end

function source:get_completions(ctx, callback)
  --- @type lsp.CompletionItem[]
  local action_names = utils.action_names()

  callback({
    items = action_names,
    is_incomplete_backward = false,
    is_incomplete_forward = false,
  })

  return function() end
end

return source
