" Title:        Example Plugin
" Description:  A plugin to provide an example for creating Neovim plugins.
" Last Change:  8 November 2021
" Maintainer:   Example User <https://github.com/example-user>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_dataform")
    finish
endif
let g:loaded_dataform = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
let s:lua_rocks_deps_loc =  expand("<sfile>:h") . "/deps"
exe "lua package.path = package.path .. ';' .. s:lua_rocks_deps_loc .. '/?.lua'"

autocmd BufWritePost *.sqlx execute "lua require('dataform').compile()"
