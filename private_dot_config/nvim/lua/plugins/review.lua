return {
  {
    "esmuellert/codediff.nvim",
    event = "VeryLazy",
    -- See https://github.com/esmuellert/codediff.nvim#configuration
    opts = {
      diff = {
        cycle_hunks_across_files = true, -- ]c/[c at file boundary hops to first/last hunk of next/prev file (explorer/history)
      },
      explorer = {
        view_mode = "tree", -- "list" or "tree"
      },

      -- Keymaps in diff view
      keymaps = {
        view = {
          -- This does not work because Gitsigns seems to load later and overwrites it
          -- next_hunk = "]h",
          -- prev_hunk = "[h",
        },
      },
    },
  },
  {
    "georgeguimaraes/review.nvim",
    version = "*",
    dependencies = {
      "esmuellert/codediff.nvim",
      "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    keys = {
      { "<leader>rr", "<cmd>Review<cr>", desc = "Review working tree" },
      { "<leader>rc", "<cmd>Review commits<cr>", desc = "Review commits" },
      { "<leader>rb", "<cmd>Review branch<cr>", desc = "Review branch" },
      { "<leader>rn", ":Review note<cr>", mode = { "n", "v" }, desc = "Review: note here" },
      {
        "<leader>rD",
        ":Review note<cr>DELETE / not needed<C-s>",
        mode = { "n", "v" },
        remap = true,
        desc = "Review: note 'DELETE / not needed'",
      },
      { "<leader>re", "<cmd>Review edit<cr>", desc = "Review: edit comment" },
      { "<leader>rd", "<cmd>Review delete<cr>", desc = "Review: delete comment" },
      { "<leader>rx", "<cmd>Review export<cr>", desc = "Review: export" },
      { "<leader>rs", "<cmd>Review sidekick<cr>", desc = "Review: sidekick" },
      { "<leader>r-", "<cmd>Review clear<cr>", desc = "Review: clear" },
    },
    opts = {},
  },
}
