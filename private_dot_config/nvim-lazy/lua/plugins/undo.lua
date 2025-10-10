return {
  {
    "kevinhwang91/nvim-fundo",
    event = "VeryLazy",
    dependencies = { "kevinhwang91/promise-async" },
    build = function()
      require("fundo").install()
    end,
    config = true,
    keys = {
      {
        "<Leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo picker",
      },
    },
  },
}
