# plum.nvim
An extremely minimal plugin manager for Neovim.

## Requirements
- `git`

## Installation
Add the following code to your `init.lua`:
```lua
local plumpath = vim.fn.stdpath("data") .. "/site/pack/plum/start/plum.nvim"

if not vim.loop.fs_stat(plumpath) then
    vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/9yokuro/plum.nvim.git",
        plumpath,
    })
end

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
