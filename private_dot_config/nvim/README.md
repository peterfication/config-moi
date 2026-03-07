# 💤 Config based on LazyVim

Refer to the [documentation](https://lazyvim.github.io/installation).

## Project specific setup via .lazy.lua

See [LOCAL_SPEC](https://github.com/folke/lazy.nvim/blob/306a05526ada86a7b30af95c5cc81ffba93fef97/lua/lazy/core/plugin.lua#L21).

Example:

```lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rubocop = {
          enabled = false,
        },
      },
    },
  },
}
```

## TODO

- chrisgrieser/nvim-spider
- mrjones2014/legendary.nvim
- davidmh/cspell.nvim
- more configs from nvimtools/none-ls.nvim
- chentoast/marks.nvim
- simnalamburt/vim-mundo
- hkupty/iron.nvim
- L3MON4D3/LuaSnip
- stevearc/overseer.nvim
- lukas-reineke/indent-blankline.nvim
- akinsho/bufferline.nvim
- nvim-lualine/lualine.nvim
- wfxr/minimap.vim

- https://github.com/nvim-neorg/neorg
- https://github.com/dhruvasagar/vim-zoom
- https://github.com/liuchengxu/vista.vim
- https://github.com/lewis6991/impatient.nvim
- https://github.com/dstein64/vim-startuptime
- https://github.com/NTBBloodbath/doom-nvim
- https://github.com/NTBBloodbath/cheovim

### Treesitter

- incremental_selection
- function show_line_diagnostics

- RRethy/nvim-treesitter-textsubjects
- kevinhwang91/nvim-ufo
- chrisgrieser/nvim-various-textobjs
