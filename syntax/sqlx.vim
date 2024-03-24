" Define SQL syntax highlighting
syn include @sql syntax/sql.vim

" Define JavaScript syntax highlighting
syn include @javascript syntax/javascript.vim

" Highlighting
hi def link sqlKeyword Keyword
hi def link sqlFunction Function
"hi def link sqlOperator Operator
hi def link sqlNumber Number
hi def link sqlString String
hi def link sqlComment Comment


" Define configblock syntax highlighting
syntax region sqlxConfigBlock start="^\s*config\s*{" end="}" contains=@javascript keepend fold extend
hi def link sqlxConfigBlock Statement

" Define jsblock syntax highlighting
syntax region sqlxJsBlock start="^\s*js\s*{" end="}" contains=@javascript
hi link sqlxJsBlock Statement

" Define inlinejs syntax highlighting
syntax region sqlxInlineJs start="\${" end="}" contains=@javascript
hi link sqlxInlineJs Statement

" Link sqlx scope to SQL syntax
syntax match sqlx ".*" contained
hi link sqlx sql

" Link JavaScript scope to JavaScript syntax
hi link sqlxJsBlock javaScript

" Link configblock scope to JavaScript syntax
hi link sqlxConfigBlock javaScript

" Link inlinejs scope to JavaScript syntax
hi link sqlxInlineJs javaScript
