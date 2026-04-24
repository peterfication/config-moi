return {
  {
    "folke/noice.nvim",
    keys = {
      {
        "<leader>sne",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker (Telescope/FzfLua)",
      },
    },
  },
}
