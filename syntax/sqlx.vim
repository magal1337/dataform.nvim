" Vim syntax file
" Language: SQLX
" Maintainer: Andres Lowrie
" Repository: https://github.com/andres-lowrie/vim-sqlx
" License: VIM
" Credits: https://github.com/vim/vim/blob/master/runtime/syntax/sqloracle.vim


" Need a way to know when we're in the process of setting up the syntax as
" well as a way to exit if we've already setup the syntax
if !exists("setting_up_sqlx")
  if exists("b:current_syntax")
    finish
  endif
  let setting_up_sqlx = 1
endif


syn case ignore


" todo
syn keyword sqlxTodo TODO FIXME XXX DEBUG NOTE contained


" Strings
syn match  sqlxSqlSpecial contained "\v\\%(x\x\x|u%(\x{4}|\{\x{4,5}})|c\u|.)"
syn region sqlxSqlString  start=+\z(["'`]\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+ contains=sqlxSqlSpecial extend


" Comments
syn region sqlxSqlComment start="/\*" end="\*/"  contains=sqlxTodo,@Spell fold
syn match  sqlxSqlComment "--.*$"                contains=sqlxTodo,@Spell
syn match  sqlxSqlComment "#.*$"                 contains=sqlxTodo,@Spell
syn sync   ccomment sqlxSqlComment


" SQL Dialects
" ---------------------
"  
" These should be keywords, statements, operators, and those types of thing.
" Note that "group-name" should follow the following pattern in order to not
" collide with the javascript "group-name"s:
"
" {prefix}Sql{group-name} eg:
"
" sqlxSqlKeyword or
" sqlxSqlType
"
" Basically with "Sql" following the prefix "sqlx"
"
"
" Picking a dialect happens using the following precedence:
"   - Reads the first line for a dialect
"
"         sqlx_dialect = 'some_supported_dialect'
"
"   - User sets the dialect via the variable 'g:sqlx_dialect' @TODO 
let filename = 'base'

if !exists("g:sqlx_dialect")
  let firstline = getline(1)

  if firstline =~ "sqlx_dialect"
    let [_, dialect] = split(firstline, '=')
    let g:sqlx_dialect = trim(dialect)
  else
    let g:sqlx_dialect = 'base'
  endif

endif

if globpath(&runtimepath, 'syntax/sql/sqlx_'.g:sqlx_dialect.'.vim') != ''
  let filename = g:sqlx_dialect
else
  " Setting the variable back to what it's defaulted to so that checks against
  " the variable yield the expected result
  echom "'".g:sqlx_dialect."' is not a supported dialect. Defaulting to 'base'"
  let g:sqlx_dialect = 'base'
endif

exec 'runtime syntax/sql/sqlx_'.filename.'.vim'



" Associate all SQL dialect syntax to highlight
hi def link Quote            Special
hi def link sqlxSqlSpecial   Special
hi def link sqlxSqlFunction  Function
hi def link sqlxSqlKeyword   Keyword
hi def link sqlxSqlOperator  Operator
hi def link sqlxSqlStatement Statement
hi def link sqlxSqlType      Type
hi def link sqlxSqlString    String
hi def link sqlxSqlComment   Comment
hi def link sqlxTodo         Todo




" Javascript Syntax
" ---------------------
" 
" SQLX allows for full on javascript code blocks:
" - js {...}      = All JavaScript except module related stuff (...I think)
" - config {...}  = Anything that can be defined within an 'Object'
" - ${...}        = Any 'In-Line' JavaScript...which probably means all JS
"                   since whitespace is insignificant in js
syn include @Js syntax/sqlx_javascript.vim

syn region sqlxSqlJsBlock matchgroup=sqlxSqlJsBlockId start="config {" end="}" contains=@Js keepend fold extend
syn region sqlxSqlJsBlock matchgroup=sqlxSqlJsBlockId start="js {"     end="}" contains=@Js keepend fold extend
syn region sqlxSqlJsBlock matchgroup=sqlxSqlJsBlockId start="${"       end="}" contains=@Js keepend fold extend

hi def link sqlxSqlJsBlockId  Special


let b:current_syntax = "sqlx"
if setting_up_sqlx == 1
  unlet setting_up_sqlx
endif
