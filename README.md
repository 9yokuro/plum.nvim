# plum.nvim
An extremely minimal plugin manager for Neovim.

## Installation
Clone this repository to `$XDG_DATA_HOME/nvim/site/pack/plum/opt/plum.nvim`:
```console
git clone https://github.com/9yokuro/plum.nvim.git $XDG_DATA_HOME/nvim/site/pack/plum/opt/plum.nvim
```

And add the following line to `init.lua`:
```lua
vim.cmd.packadd("plum")
require("plum").setup({
    "9yokuro/plum.nvim",
})
```
