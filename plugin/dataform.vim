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
  lua require('dataform').compile()
  let g:loaded_dataform = 1
endif

" Define SQL syntax highlighting
syntax include @sql syntax/sql.vim

" Define JavaScript syntax highlighting
syntax include @javascript syntax/javascript.vim

" Define configblock syntax highlighting
syntax region sqlxConfigBlock start="^\s*config\s*{" end="}" contains=@javascript

" Define jsblock syntax highlighting
syntax region sqlxJsBlock start="^\s*js\s*{" end="}" contains=@javascript

" Define inlinejs syntax highlighting
syntax region sqlxInlineJs start="\${" end="}" contains=@javascript

" Link sqlx scope to SQL syntax
syntax match sqlx ".*" contained
hi link sqlx sql

" Link JavaScript scope to JavaScript syntax
hi link sqlxJsBlock javascript

" Link configblock scope to JavaScript syntax
hi link sqlxConfigBlock javascript

" Link inlinejs scope to JavaScript syntax
hi link sqlxInlineJs javascript

" Set the file type for .sqlx files
autocmd BufNewFile,BufRead *.sqlx set filetype=sqlx
" Define custom highlight groups
highlight Statement ctermfg=yellow guifg=yellow

autocmd BufWritePost *.sqlx execute "lua require('dataform').compile()"

command! -nargs=0 DataformCompileFull lua require('dataform').get_compiled_sql_job()
command! -nargs=0 DataformCompileIncremental lua require('dataform').get_compiled_sql_job(true)
command! -nargs=0 DataformGoToRef lua require('dataform').go_to_ref()
command! -nargs=0 DataformRunActionIncremental lua require('dataform').run_action_job()
command! -nargs=0 DataformRunAction lua require('dataform').run_action_job(true)
command! -nargs=0 DataformRunAll lua require('dataform').run_all()
command! -nargs=0 DataformRunAssertions lua require('dataform').run_assertions_job()
command! -nargs=1 DataformRunTag lua require('dataform').run_tag(<f-args>)
