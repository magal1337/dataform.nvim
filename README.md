# <img src="images/dataform-logo.png" width="120" height="120">  dataform.nvim
## Dataform Core Plugin for Neovim

⚠️ **This is not an officially supported Google product.**
<br>
<br>

[![asciicast](https://asciinema.org/a/PV7XeWQqBBotCx8EhhXLVZlyG.svg)](https://asciinema.org/a/PV7XeWQqBBotCx8EhhXLVZlyG)

## 🪄 Features

- Compile dataform project when open `.sqlx` file first time within neovim session or when write a sqlx file
- Compile dataform current model to sql script with bq cli validation (full load and incremental)
- Go to reference sqlx file when line has the `${ref()}` pattern
- Run current dataform model (full or incremental)
- Run current dataform model assertions
- Run entire dataform project
- Run dataform specific tag
- Syntax highlighting for both sql and javascript blocks
- Search for dependencies and dependents for a specific model
- Autocompletion for Dataform action names (e.g., within `ref("...")`, `resolve("...")`) in `.sqlx` files using `nvim-cmp` or `blink.cmp`.

## 📜 Requirements

- [Dataform CLI](https://cloud.google.com/dataform/docs/use-dataform-cli) to get stuff done
- [nvim-notify](https://github.com/rcarriga/nvim-notify) for amazing notifications
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim/tree/master) for smart dependencies/dependents finder
- [BigQuery CLI Tool](https://cloud.google.com/bigquery/docs/bq-command-line-tool?hl=pt-br) to validate BigQuery sql script

## 🧪 Installation

Use your favorite plugin manager to install it. For example:

```lua
use {
  'magal1337/dataform.nvim',
  requires = {
    'rcarriga/nvim-notify',
    'nvim-telescope/telescope.nvim'
  },
  config = function ()
    require('dataform').setup({
        -- refresh dataform metadata on each save
        compile_on_save = true
    })
  end
}
```

## 🚀 Completions

This plugin provides an `nvim-cmp` source named `dataform_actions` and `blink.cmp` source in module `dataform.completion.blink` for autocompleting Dataform action names.
This is particularly useful when writing `ref("...")` or `resolve("...")` calls within the JavaScript blocks or string literals in your `.sqlx` files.

#### Example Setup for `nvim.cmp`
To use the autocompletion, you need to add it to your `nvim-cmp` sources configuration, typically for the `sqlx` filetype.
Here's how you can prepend the `dataform_actions` source to your existing global sources for `sqlx` files:

```lua
local cmp = require('cmp')

cmp.setup.filetype('sqlx', {
  sources = vim.fn.extend(
    { { name = 'dataform_actions' } },
    cmp.get_config().sources
  )
})
```

#### Example Setup for `blink.cmp`
To integrate the Dataform autocompletion with `blink.cmp`, you need to configure its sources to include the `dataform.completion.blink` module, either specifically for `sqlx` filetypes or add it to the list of `default` sources.

Here's how you can set up `blink.cmp` to use the Dataform completion provider:
```lua
blink.setup({
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      dataform = {
        name = "Dataform",
        module = "dataform.completion.blink",
      },
    },
    per_filetype = {
      sqlx = { 'dataform', 'lsp', 'path', 'snippets', 'buffer' }
    },
  },
})
```

## 🧙‍♂️ Usage

First time that you open a dataform project with a `.sqlx` file in neovim session, it will automatically compile the project.
And also every time that you edit your `.sqlx` file, and hit `:w` it will recompile it again for you not worry to do it manually. 🔮


This auto-compile on save behavior is controlled by the `compile_on_save` option in the plugin's `setup` function.


If you set `compile_on_save = false` in the setup, the plugin will not automatically recompile on save.
You can then trigger compilation manually at any time using the command:
```vim
lua require('dataform').compile()
```

## 🌀 Commands
| Command | Action | Arguments|
|---|---|---|
|`:DataformCompileFull` | Will compile your current file as a BigQuery SQL Script and it will evaluate it using bq CLI. The results will be presented in a new buffer. ||
|`:DataformCompileIncremental` | Same thing as `:DataformCompileFull` but it will compile the Bigquery SQL Script with incremental option if your model is of type `incremental`. ||
|`:DataformGoToRef` |It will open the source file of your reference but only if your cursor is in the same line of your `${ref()}` expression. ||
|`:DataformRunAll`|Will run your entire dataform project.||
|`:DataformRunAction`|Will run the current model in your opened `.sqlx` file.||
|`:DataformRunActionIncremental`|Same thing as `:DataformRunAction` but it will run the current model with incremental option if your model is of type `incremental`.||
|`:DataformRunTag`|Will run a specific tag that you specify.| A specific tag name like `:DataformRunTag tag_name` or a list of tags like `:DataformRunTag tag_name1,tag_name2` |
|`:DataformRunAssertions`| Will run the current model assertions. ||
|`:DataformFindDependencies`| Will return a Telescope Finder with all dependencies for current model ||
|`:DataformFindDependents`| Will return a Telescope Finder with all dependents for current model ||

🔮 It's recommended to use these commands encapsulated in some custom keymaps to make it more convenient. Choose what suits you best.
## 📖 Syntax Highlight
From a syntax perspective sqlx acts like a combination of `sql` and `js` and the aim of this project is to support both syntaxes in parody with how [Dataform](https://github.com/dataform-co/dataform) uses them, more precisely:

- The javascript supported by NodeJs
- The sql supported by BigQuery

✨ Still under development...
## 🏰 How to contribute
To know more on how to contribute please check our [Contributing Guide](https://github.com/magal1337/dataform.nvim/blob/main/CONTRIBUTING.md)
## 🙏 Thanks adventurer 🧙‍♀️
Like this Plugin? Star it on [GitHub](https://github.com/magal1337/dataform.nvim)
