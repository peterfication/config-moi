return {
  {
    "aaronik/treewalker.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    keys = {
      { "<A-k>", "<CMD>Treewalker Up<CR>", silent = true, mode = { "n", "v" } },
      { "<A-j>", "<CMD>Treewalker Down<CR>", silent = true, mode = { "n", "v" } },
      { "<A-h>", "<CMD>Treewalker Left<CR>", silent = true, mode = { "n", "v" } },
      { "<A-l>", "<CMD>Treewalker Right<CR>", silent = true, mode = { "n", "v" } },

      { "<A-S-k>", "<CMD>Treewalker SwapUp<CR>", silent = true },
      { "<A-S-j>", "<CMD>Treewalker SwapDown<CR>", silent = true },
      { "<A-S-h>", "<CMD>Treewalker SwapLeft<CR>", silent = true },
      { "<A-S-l>", "<CMD>Treewalker SwapRight<CR>", silent = true },
    },
  },

  {
    "mawkler/refjump.nvim",
    event = "LspAttach",
    opts = {
      keymaps = {
        enable = true,
        next = "<A-n>",
        prev = "<A-p>",
      },
    },
  },
}
