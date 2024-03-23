" Title:        Example Plugin
" Description:  A plugin to provide an example for creating Neovim plugins.
" Last Change:  8 November 2021
" Maintainer:   Example User <https://github.com/example-user>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
let current_file_extension = fnamemodify(expand("%"), ":e")
if exists("g:loaded_dataform")
  finish
"fix this elif for me 
elseif (current_file_extension == "sqlx")
  lua require('dataform').compile()
  let g:loaded_dataform = 1
endif

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
"let s:lua_rocks_deps_loc =  expand("<sfile>:h") . "/deps"
"exe "lua package.path = package.path .. ';' .. s:lua_rocks_deps_loc .. '/?.lua'"
autocmd BufWritePost *.sqlx execute "lua require('dataform').compile()"

command! -nargs=0 DataformCompileFull lua require('dataform').get_compiled_sql_job()
command! -nargs=0 DataformCompileIncremental lua require('dataform').get_compiled_sql_incremental_job()
command! -nargs=0 DataformGoToRef lua require('dataform').go_to_ref()
command! -nargs=0 DataformRunActionIncremental lua require('dataform').dataform_run_action_job()
command! -nargs=0 DataformRunAction lua require('dataform').dataform_run_action_job(true)
command! -nargs=0 DataformRunAll lua require('dataform').dataform_run_all()
command! -nargs=0 DataformRunAssertions lua require('dataform').dataform_run_action_assertions()
command! -nargs=1 DataformRunTag lua require('dataform').dataform_run_tag(<f-args>)
