# 💤 Config based on LazyVim

Refer to the [documentation](https://lazyvim.github.io/installation).

## Project specific setup via `.lazy.lua` file

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

- https://github.com/chentoast/marks.nvim
- https://github.com/hkupty/iron.nvim
