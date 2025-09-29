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
    opts = function()
      -- See
      -- https://www.lazyvim.org/plugins/lsp
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- Change keympas von <Leader>c to <Leader>z
      keys[#keys + 1] = { "<Leader>ca", false }
      keys[#keys + 1] = { "<Leader>cc", false }
      keys[#keys + 1] = { "<Leader>cC", false }
      keys[#keys + 1] = { "<Leader>cR", false }
      keys[#keys + 1] = { "<Leader>cr", false }
      keys[#keys + 1] = { "<Leader>cA", false }
      keys[#keys + 1] = { "<Leader>cf", false }

      keys[#keys + 1] =
        { "<Leader>za", vim.lsp.buf.code_action, desc = "[LSP] Code Action", mode = { "n", "v" }, has = "codeAction" }

      keys[#keys + 1] =
        { "<Leader>zc", vim.lsp.codelens.run, desc = "[LSP] Run Codelens", mode = { "n", "v" }, has = "codeLens" }
      keys[#keys + 1] = {
        "<Leader>zC",
        vim.lsp.codelens.refresh,
        desc = "[LSP] Refresh & Display Codelens",
        mode = { "n" },
        has = "codeLens",
      }
      keys[#keys + 1] = {
        "<Leader>zR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "[LSP] Rename File",
        mode = { "n" },
        has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
      }
      keys[#keys + 1] = { "<Leader>zr", vim.lsp.buf.rename, desc = "[LSP] Rename", has = "rename" }
      keys[#keys + 1] = { "<Leader>zA", LazyVim.lsp.action.source, desc = "[LSP] Source Action", has = "codeAction" }
      keys[#keys + 1] = { "<Leader>zf", vim.lsp.buf.format, desc = "[LSP] Format", has = "format" }
    end,
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
}
