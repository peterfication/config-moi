local function select_textobject(query)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      select = {
        lookahead = true,
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        keys = {
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
        },
      },
    },
    keys = {
      { "aj", select_textobject("@comment.outer"), mode = { "x", "o" }, desc = "Around comment" },
      { "af", select_textobject("@function.outer"), mode = { "x", "o" }, desc = "Around function" },
      { "if", select_textobject("@function.inner"), mode = { "x", "o" }, desc = "Inside function" },
      { "ab", select_textobject("@block.outer"), mode = { "x", "o" }, desc = "Around block" },
      { "ib", select_textobject("@block.inner"), mode = { "x", "o" }, desc = "Inside block" },
      { "ah", select_textobject("@call.outer"), mode = { "x", "o" }, desc = "Around call" },
      { "ih", select_textobject("@call.inner"), mode = { "x", "o" }, desc = "Inside call" },
      { "ac", select_textobject("@class.outer"), mode = { "x", "o" }, desc = "Around class" },
      { "ic", select_textobject("@class.inner"), mode = { "x", "o" }, desc = "Inside class" },
      { "ak", select_textobject("@conditional.outer"), mode = { "x", "o" }, desc = "Around conditional" },
      { "ik", select_textobject("@conditional.inner"), mode = { "x", "o" }, desc = "Inside conditional" },
      { "al", select_textobject("@loop.outer"), mode = { "x", "o" }, desc = "Around loop" },
      { "il", select_textobject("@loop.inner"), mode = { "x", "o" }, desc = "Inside loop" },
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
    "hasansujon786/nvim-navbuddy",
    cmd = { "Navbuddy" },
    opts = { lsp = { auto_attach = true } },
    keys = {
      { "<Leader>cb", "<CMD>Navbuddy<CR>", desc = "Navbuddy" },
    },
  },
  {
    "SmiteshP/nvim-navic",
    cmd = { "Navbuddy" },
  },
  {
    "numToStr/Comment.nvim",
    cmd = { "Navbuddy" },
    opts = {},
  },
}
