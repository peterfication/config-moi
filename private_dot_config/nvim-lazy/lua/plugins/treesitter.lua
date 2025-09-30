return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["aj"] = "@comment.outer",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
          ["ah"] = "@call.outer",
          ["ih"] = "@call.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ak"] = "@conditional.outer",
          ["ik"] = "@conditional.inner",
          ["al"] = "@loop.outer",
          ["il"] = "@loop.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["glfn"] = "@function.outer",
          ["glcn"] = "@class.outer",
          ["glkn"] = "@conditional.outer",
          ["glln"] = "@loop.outer",
          ["glbn"] = "@block.outer",
          ["glhn"] = "@call.outer",
          ["gljn"] = "@comment.outer",
        },
        goto_next_end = {
          ["glfe"] = "@function.outer",
          ["glce"] = "@class.outer",
          ["glke"] = "@conditional.outer",
          ["glle"] = "@loop.outer",
          ["glbe"] = "@block.outer",
          ["glhe"] = "@call.outer",
          ["glje"] = "@comment.outer",
        },
        goto_previous_start = {
          ["glfp"] = "@function.outer",
          ["glcp"] = "@class.outer",
          ["glkp"] = "@conditional.outer",
          ["gllp"] = "@loop.outer",
          ["glbp"] = "@block.outer",
          ["glhp"] = "@call.outer",
          ["gljp"] = "@comment.outer",
        },
        goto_previous_end = {},
      },
    },
  },

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
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
  },
  {
    "hasansujon786/nvim-navbuddy",
    event = "VeryLazy",
    opts = { lsp = { auto_attach = true } },
    keys = {
      { "<leader>zb", "<CMD>Navbuddy<CR>", desc = "Navbuddy" },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
