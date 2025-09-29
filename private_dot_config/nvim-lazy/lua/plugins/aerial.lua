return {
  {
    "stevearc/aerial.nvim",

    opts = {
      close_on_select = true,
      float = {
        relative = "editor",
      },
    },

    keys = {
      { "<Leader>zo", ":AerialToggle float<CR>", desc = "Toggle Aerial to select (LSP) tags" },
      { "<Leader>zz", ":Telescope aerial<CR>",   desc = "Open Aerial (LSP) tags in Telescope" },
    },
  },
}
