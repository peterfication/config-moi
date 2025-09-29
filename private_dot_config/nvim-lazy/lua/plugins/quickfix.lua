return {
  {
    -- Better quickfix features
    "kevinhwang91/nvim-bqf",
    -- priority = 1001,
    event = "VeryLazy",
  },

  {
    "stevearc/quicker.nvim",
    -- priority = 1000,
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    opts = {
      {
        win = {
          wo = {
            wrap = true,
          },
        },
      },
    },
    config = function()
      vim.diagnostic.config({ virtual_text = false })
    end,

    keys = {
      {
        "<C-h>",
        ":cprevious<CR>",
        desc = "Previous quickfix item",
      },
      {
        "<C-l>",
        ":cnext<CR>",
        desc = "Next quickfix item",
      },
      -- ["A-j"] = { ":cnext<CR>", "Next quickfix item" },
      -- ["A-k"] = { ":cprevious<CR>", "Previous quickfix item" },

      { "<Leader>q",  group = "Quickfix" },
      {
        "<Leader>qc",
        ":cclose<CR>",
        desc = "Close quickfix list",
      },
      {
        "<Leader>qo",
        ":copen<CR>",
        desc = "Open quickfix list",
      },
      {
        "<Leader>qt",
        ":cg quickfix.out | cwindow<CR>",
        desc = "Load quickfix from rspec-quickfix tests",
      },

      { "<Leader>x",  group = "Trouble" },
      { "<Leader>xl", "<CMD>Trouble loclist toggle<CR>",                                    desc = "Toggle loclist" },
      { "<Leader>xn", "<CMD>Trouble diagnostics next<CR><CMD>Trouble diagnostics jump<CR>", desc = "Next" },
      { "<Leader>xq", "<CMD>Trouble qflist toggle<CR>",                                     desc = "Toggle quickfix" },
      {
        "<Leader>xw",
        "<CMD>Trouble diagnostics toggle<CR>",
        desc = "Toggle workspace diagnostics",
      },
      { "<Leader>xx",  group = "Trouble document diagnostics" },
      {
        "<Leader>xxx",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<CR>",
        desc = "Toggle document diagnostics",
      },
      {
        "<Leader>xxw",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.WARN<CR>",
        desc = "Toggle document diagnostics",
      },
      { "<Leader>xxe", "<CMD>Telescope diagnostics<CR>",      desc = "Telescope document diagnostics" },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false })

      -- This is needed because other plugins that lazy load later might overwrite it.
      LazyVim.lsp.on_attach(function(_client, _buffer)
        vim.diagnostic.config({ virtual_text = false })
      end)
    end,
  },
}
