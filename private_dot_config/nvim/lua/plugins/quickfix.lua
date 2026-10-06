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
        desc = "Toggle quickfix list",
      },

      -- Intended duplicate of <leader>jx/X
      {
        "<Leader>xj",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Diagnostics of project with Telescope",
      },
      {
        "<Leader>xJ",
        ":Telescope diagnostics bufnr=0<CR>",
        desc = "Diagnostics of current buffer with Telescope",
      },

      {
        "<Leader>xW",
        "<CMD>Trouble diagnostics toggle<CR>",
        desc = "Workspace diagnostics (Trouble)",
      },
      {
        "<Leader>xxx",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<CR>",
        desc = "Toggle document diagnostics ERROR",
      },
      {
        "<Leader>xxw",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.WARN<CR>",
        desc = "Toggle document diagnostics WARN",
      },
      {
        "<Leader>xxi",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.INFO<CR>",
        desc = "Toggle document diagnostics INFO",
      },
      { "<Leader>xxe", "<CMD>Telescope diagnostics<CR>", desc = "Telescope document diagnostics" },
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
