" Title:        Dataform Plugin
" Description:  A plugin to provide simple dataform features. Caution: This is not a
" Dataform official product.
" Maintainer:   https://github.com/magal1337

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
let current_file_extension = fnamemodify(expand("%"), ":e")
if exists("g:loaded_dataform")
  finish
elseif (current_file_extension == "sqlx")
  lua require('dataform').set_dataform_workdir_project_path()
  lua require('dataform').compile()
  let g:loaded_dataform = 1
endif

autocmd BufNewFile,BufRead *.sqlx setfiletype sqlx

autocmd BufWritePost *.sqlx execute "lua require('dataform').compile()"

command! -nargs=0 DataformCompileFull lua require('dataform').get_compiled_sql_job()
command! -nargs=0 DataformCompileIncremental lua require('dataform').get_compiled_sql_job(true)
command! -nargs=0 DataformGoToRef lua require('dataform').go_to_ref()
command! -nargs=0 DataformRunActionIncremental lua require('dataform').run_action_job()
command! -nargs=0 DataformRunAction lua require('dataform').run_action_job(true)
command! -nargs=0 DataformRunAll lua require('dataform').run_all()
command! -nargs=0 DataformRunAssertions lua require('dataform').run_assertions_job()
command! -nargs=1 DataformRunTag lua require('dataform').run_tag(<f-args>)
