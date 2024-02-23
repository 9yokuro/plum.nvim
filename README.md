# plum.nvim
An extremely minimal plugin manager for Neovim.

## Requirements
- `git`

## Installation
Clone this repository to `$XDG_DATA_HOME/nvim/site/pack/plum/opt/plum.nvim`:
```console
git clone https://github.com/9yokuro/plum.nvim.git $XDG_DATA_HOME/nvim/site/pack/plum/opt/plum.nvim
```

And add the following line to `init.lua`:
```lua
vim.cmd.packadd("plum.nvim")
require("plum").setup({
    "9yokuro/plum.nvim",
})
```

## Usage
To install plugins:
```lua
require("plum").setup({
    "9yokuro/plum.nvim",
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
})
```

To update plugins:
```vimscript
:PlumUpdate
```

To clean plugins that are no longer needed:
```vimscript
:PlumClean
```
