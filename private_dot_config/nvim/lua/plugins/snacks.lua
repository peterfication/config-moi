return {
  {
    "snacks.nvim",
    opts = {
      scroll = {
        animate = {
          duration = { step = 10, total = 100 },
          easing = "linear",
        },
      },
      notifier = { enabled = false },
    },
  },

  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPre",
    opts = {
      set_highlights = true,
      handlers = {
        gitsigns = true,
      },
      marks = {
        GitAdd = { text = "┃" },
        GitChange = { text = "┃" },
        GitDelete = { text = "_" },
      },
    },
  },
}
