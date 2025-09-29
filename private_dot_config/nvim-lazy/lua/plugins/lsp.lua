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
    keys = {
      { "<Leader>z",  group = "LSP" },
      { "<Leader>za", "<CMD>lua vim.lsp.buf.code_action()<CR>", desc = "[LSP] Code action" },
      { "<Leader>zr", "<CMD>lua vim.lsp.buf.rename()<CR>",      desc = "[LSP] Rename" },
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
