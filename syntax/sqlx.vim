" Define SQL syntax highlighting
syntax include @sql syntax/sql.vim

" Define JavaScript syntax highlighting
syntax include @javascript syntax/javascript.vim

" Link sqlx scope to SQL syntax
syntax match sqlx ".*" contains=@sql
hi link sqlx sql

" Define configblock syntax highlighting
"syntax region sqlxConfigBlock matchgroup=sqlxBlocks start="^\s*config\s*{" end="}" contains=@javascript keepend fold extend
"syntax region sqlxJsBlock matchgroup=sqlxBlocks start="^\s*js\s*{" end="}" contains=@javascript keepend fold extend
" syntax region sqlxInlineJs matchgroup=sqlxBlocks start="\${" end="}" contains=@javascript keepend fold extend
"hi link sqlxBlocks Special

syntax region sqlxConfigBlock start="^\s*config\s*{" end="}" contained transparent contains=@sqlxConfigInnerBlock,javascript

syntax region sqlxConfigInnerBlock start="{" end="}" contained transparent contains=@sqlxConfigInnerBlock,sqlxConfigKeyValue,sqlxConfigString, javascript

syntax match sqlxConfigKeyValue /\v\s*\zs\w+\ze\s*:/
syntax match sqlxConfigString /\v".*?"/

hi def link sqlxConfigBlock Statement
hi def link sqlxConfigInnerBlock Statement
hi def link sqlxConfigKeyValue Type
hi def link sqlxConfigString String

" Set the file type for .sqlx files
autocmd BufNewFile,BufRead *.sqlx set filetype=sqlx

