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
    opts = {},
  },
}
