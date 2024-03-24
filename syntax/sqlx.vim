" Define SQL syntax highlighting
syntax include @sql syntax/sql.vim

" Define JavaScript syntax highlighting
syntax include @javascript syntax/javascript.vim

" Link sqlx scope to SQL syntax
syntax match sqlx ".*" contains=@sql
hi link sqlx sql

" Define configblock syntax highlighting
syntax region sqlxConfigBlock start="^\s*config\s*{" end="}" contains=@javascript keepend fold extend
hi link sqlxConfigBlock Special

" Define jsblock syntax highlighting
syntax region sqlxJsBlock start="^\s*js\s*{" end="}" contains=@javascript
hi link sqlxJsBlock Statement

" Define inlinejs syntax highlighting
syntax region sqlxInlineJs start="\${" end="}" contains=@javascript
hi link sqlxInlineJs Statement

" Link JavaScript scope to JavaScript syntax
hi link sqlxJsBlock javaScript

" Link configblock scope to JavaScript syntax
hi link sqlxConfigBlock javaScript

" Link inlinejs scope to JavaScript syntax
hi link sqlxInlineJs javaScript

" Set the file type for .sqlx files
autocmd BufNewFile,BufRead *.sqlx set filetype=sqlx

" Define custom highlight groups
highlight Statement ctermfg=yellow guifg=yellow
