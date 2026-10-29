return {
  {
    "esmuellert/codediff.nvim",
    event = "VeryLazy",
    -- See https://github.com/esmuellert/codediff.nvim#configuration
    opts = {
      highlights = {
        line_insert = "#1d3042",
        line_delete = "#351d2b",
        char_brightness = 1.5,
      },
      diff = {
        -- cycle_hunks_across_files = true, -- ]c/[c at file boundary hops to first/last hunk of next/prev file (explorer/history)
        gutter_signs = {
          insert_text = "＋",
          delete_text = "－",
          highlight_numbers = true,
          changed_priority = 100,
          unchanged_priority = nil,
        },
      },
      explorer = {
        view_mode = "tree", -- "list" or "tree"
      },

      -- Keymaps in diff view
      keymaps = {
        view = {
          next_hunk = "<localleader>n",
          prev_hunk = "<localleader>p",
        },
      },
    },
  },
  {
    "georgeguimaraes/review.nvim",
    -- "peterfication/review.nvim",
    -- branch = "...",
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
      { "<leader>re", "<cmd>Review edit<cr>", desc = "Edit comment" },
      { "<leader>rd", "<cmd>Review delete<cr>", desc = "Delete comment" },
      { "<leader>rl", "<cmd>Review list<cr>", desc = "List comments" },
      { "<leader>rx", "<cmd>Review export<cr>", desc = "Export comments" },
      { "<leader>rs", "<cmd>Review sidekick<cr>", desc = "Send comments via sidekick" },
      { "<leader>r-", "<cmd>Review clear<cr>", desc = "Clear comments" },
    },
    opts = {
      codediff = {
        readonly = false,
      },
      branch = {
        pick_base = true,
      },
      export = {
        header = table.concat({
          "Please address my review notes:",
          "",
        }, "\n"),
      },
      keymaps = {
        add_note = "<localleader>rn",
        delete_comment = "<localleader>rd",
        edit_comment = "<localleader>re",
        toggle_reviewed  = "<localleader>r",
        readonly_toggle_reviewed   = "<localleader>r",
      },
    },
  },

  {
    "tuicr",
    virtual = true,
    keys = function()
      local tuicr_term_open = function()
        local tuicr_term = require("toggleterm.terminal").Terminal:new({
          cmd = "tuicr",
          direction = "float",
          close_on_exit = true,
          count = 20,
          hidden = true,
        })
        tuicr_term:toggle()
      end

      return {
        { "<Leader>rt", tuicr_term_open, desc = "TUI Code Review (tuicr)" },
      }
    end,
  },
}
