return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<Leader> ", group = "<localleader>" },
        { "<Leader>fy", group = "Yank" },
        { "<Leader>fya", group = "Agent Refs" },
        { "<Leader>fz", group = "Yazi" },
        { "<Leader>G", group = "git 2" },
        { "<Leader>GH", group = "GitHub / Octo" },
        { "<Leader>GD", desc = "DiffView" },
        { "<Leader>GB", desc = "Git blame" },
        { "<Leader>h", group = "Harpoon" },
        { "<Leader>k", group = "Multi-cursor" },
        { "<Leader>m", group = "Marks" },
        { "<Leader>o", group = "" },
        { "<Leader>r", group = "Review" },
        { "<Leader>t", group = "Terminal / test" },
        { "<Leader>xs", group = "Severity" },
        { "<Leader>xS", group = "Severity (Buffer)" },
      },
    },
  },
}
