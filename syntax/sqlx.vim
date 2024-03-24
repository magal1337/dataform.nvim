" Define SQL syntax highlighting
syntax include @sql syntax/sql.vim

" Define JavaScript syntax highlighting
syntax include @javascript syntax/javascript.vim

" Link sqlx scope to SQL syntax
syntax match sqlx ".*" contains=@sql
hi link sqlx sql

" Define configblock syntax highlighting
syntax region sqlxConfigBlock matchgroup=sqlxBlocks start="^\s*config\s*{" end="}" contains=@javascript keepend fold extend
syntax region sqlxJsBlock matchgroup=sqlxBlocks start="^\s*js\s*{" end="}" contains=@javascript keepend fold extend
syntax region sqlxInlineJs matchgroup=sqlxBlocks start="\${" end="}" contains=@javascript keepend fold extend
hi link sqlxBlocks Special

" Set the file type for .sqlx files
autocmd BufNewFile,BufRead *.sqlx set filetype=sqlx

