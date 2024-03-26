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

## 📜 Requirements

- [Dataform CLI](https://cloud.google.com/dataform/docs/use-dataform-cli) to get stuff done
- [nvim-notify](https://github.com/rcarriga/nvim-notify) for amazing notifications
- [BigQuery CLI Tool](https://cloud.google.com/bigquery/docs/bq-command-line-tool?hl=pt-br) to validate BigQuery sql script

## 🧪 Installation

Use your favorite plugin manager to install it. For example:

```lua
use {
  'magal1337/dataform.nvim',
  requires = {
    'rcarriga/nvim-notify',
  },
  config = function ()
    require"dataform".setup()
  end
}
```

## 🧙‍♂️ Usage

First time that you open a dataform project with a `.sqlx` file in neovim session, it will automatically compile the project.
And also every time that you edit your `.sqlx` file, and hit `:w` it will recompile it again for you not worry to do it manually. 🔮

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

🔮 It's recommended to use these commands encapsulated in some custom keymaps to make it more convenient. Choose what suits you best.
## Syntax Highlight
✨ Still under development...
## How to contribute
To know more on how to contribute please check our [Contributing Guide](https://github.com/magal1337/dataform.nvim/blob/main/CONTRIBUTING.md)
## 🙏 Thanks adventurer 🧙‍♀️
Like this Plugin? Star it on [GitHub](https://github.com/magal1337/dataform.nvim)
