return {
  {
    "neovim/nvim-lspconfig",
    -- opts = function()
    --   local keys = require("lazyvim.plugins.lsp.keymaps").get()
    --   -- change a keymap
    --   keys[#keys + 1] = { "K", "<cmd>echo 'hello'<cr>" }
    --   -- disable a keymap
    --   keys[#keys + 1] = { "K", false }
    --   -- add a keymap
    --   keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
    -- end,
    opts = {
      -- See
      -- https://www.lazyvim.org/plugins/lsp
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua
      servers = {
        ["*"] = {
          keys = {
            {
              "<A-n>",
              function()
                Snacks.words.jump(vim.v.count1, true)
              end,
              has = "documentHighlight",
              desc = "Next Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
            {
              "<A-p>",
              function()
                Snacks.words.jump(-vim.v.count1, true)
              end,
              has = "documentHighlight",
              desc = "Prev Reference",
              cond = function()
                return Snacks.words.is_enabled()
              end,
            },
          },
        },
      },
    },
    keys = {
      { "<Leader>z", group = "LSP" },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        null_ls.builtins.code_actions.gitsigns,
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Protobufs
        -- "buf",
        "protols",
      },
    },
  },
}
