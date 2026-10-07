return {
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    keys = {
      { "m]", mode = "n", desc = "Next mark" },
      { "m[", mode = "n", desc = "Previous mark" },
      { "dm", mode = "n", desc = "Delete mark <char>" },
      { "dm-", mode = "n", desc = "Delete marks current line" },
      { "dm<Space>", mode = "n", desc = "Delete marks current buffer" },
      { "dm=", mode = "n", desc = "Delete bookmark under cursor" },
      {
        "<Leader>mn",
        function()
          require("marks").next()
        end,
        mode = "n",
        desc = "Next mark",
      },
      {
        "<Leader>mp",
        function()
          require("marks").prev()
        end,
        mode = "n",
        desc = "Previous mark",
      },
      {
        "<Leader>md",
        function()
          require("marks").delete()
        end,
        mode = "n",
        desc = "Delete mark <char>",
      },
      {
        "<Leader>ml",
        function()
          require("marks").delete_line()
        end,
        mode = "n",
        desc = "Delete marks current line",
      },
      {
        "<Leader>mb",
        function()
          require("marks").delete_buf()
        end,
        mode = "n",
        desc = "Delete marks current buffer",
      },
    },
    opts = {},
  },
}
