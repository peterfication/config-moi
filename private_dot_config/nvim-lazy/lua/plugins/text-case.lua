return {
  {
    "tpope/vim-abolish",
    event = "BufReadPre",
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    opts = function()
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("textcase")
      end)
    end,
    keys = {
      { "ga",  group = "Text Case" },
      { "ga.", "<CMD>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
      {
        "gar",
        "<CMD>lua require('textcase').start_replacing_command_with_part({ parts_count = 1 })<CR>",
        { desc = "Run Subs command for first part of text under cursor" },
      },
      {
        "ga2r",
        "<CMD>lua require('textcase').start_replacing_command_with_part({ parts_count = 2 })<CR>",
        { desc = "Run Subs command for first part of text under cursor" },
      },
      {
        "gaR",
        "<CMD>TextCaseStartReplacingCommand<CR>",
        desc = "Run Subs command for text under cursor",
        mode = { "n", "v" },
      },
      { "gaR", "<CMD>TextCaseStartReplacingCommand<CR>", desc = "Run Subs command for text under cursor" },
    },
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },
}
