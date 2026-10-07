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
      win = {
        wo = {
          wrap = true,
        },
      },
    },

    keys = {
      -- {
      --   "<C-h>",
      --   ":cprevious<CR>",
      --   desc = "Previous quickfix item",
      -- },
      -- {
      --   "<C-l>",
      --   ":cnext<CR>",
      --   desc = "Next quickfix item",
      -- },

      -- <leader>cs is used by aerial
      { "<leader>cz", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },

      { "<Leader>xf", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics (Telescope)" },
      { "<Leader>xF", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Buffer diagnostics (Telescope)" },

      {
        "<Leader>xq",
        function()
          local winid = vim.fn.getqflist({ winid = 0 }).winid

          if winid ~= 0 then
            vim.cmd.cclose()
          else
            vim.cmd.copen()
          end
        end,
        desc = "Quickfix list",
      },

      {
        "<Leader>xsx",
        "<CMD>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<CR>",
        desc = "Toggle diagnostics ERROR",
      },
      {
        "<Leader>xsw",
        "<CMD>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.WARN<CR>",
        desc = "Toggle diagnostics WARN",
      },
      {
        "<Leader>xsi",
        "<CMD>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.INFO<CR>",
        desc = "Toggle diagnostics INFO",
      },

      {
        "<Leader>xSx",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<CR>",
        desc = "Toggle document diagnostics ERROR",
      },
      {
        "<Leader>xSw",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.WARN<CR>",
        desc = "Toggle document diagnostics WARN",
      },
      {
        "<Leader>xSi",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.INFO<CR>",
        desc = "Toggle document diagnostics INFO",
      },
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
      Snacks.util.lsp.on(function(_client, _buffer)
        vim.diagnostic.config({ virtual_text = false })
      end)
    end,
  },
}
