return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Navbuddy must initialize before LSP clients attach so that auto_attach can observe the attachment events.
      {
        "hasansujon786/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
        keys = {
          { "<Leader>cb", "<CMD>Navbuddy<CR>", desc = "Navbuddy" },
        },
      },
    },
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
      { "g<C-d>", group = "Goto definition" },
      {
        "g<C-d>s",
        "<CMD>vsplit | lua vim.lsp.buf.definition()<CR>",
        desc = "Open definition in a new split",
      },
      {
        "g<C-d>t",
        "<CMD>tab split | lua vim.lsp.buf.definition()<CR>",
        desc = "Open definition in a new tab",
      },
    },
    opts = {
      servers = {
        -- I'm using ty
        pylsp = { enabled = false },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- "buf", -- Protobufs
        "codebook",
        "gh-actions-language-server",
        "just-lsp",
        "protols",
      },
    },
  },

  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.actions = opts.picker.actions or {}
      opts.picker.sources = opts.picker.sources or {}

      opts.picker.actions.lsp_restart = function(_, item)
        if not item or not item.name then
          return
        end
        vim.cmd("lsp restart " .. item.name)
        Snacks.notifier.notify("LSP " .. item.name .. " restarted", "info", {
          style = "minimal",
        })
      end

      opts.picker.sources.lsp_config = vim.tbl_deep_extend("force", opts.picker.sources.lsp_config or {}, {
        win = {
          input = {
            keys = {
              ["<C-r>"] = { "lsp_restart", mode = { "n", "i" }, desc = "Restart LSP" },
            },
          },
        },
      })
    end,
    keys = {
      {
        "<Leader>cL",
        function()
          Snacks.picker.lsp_config({ attached = 0 })
        end,
        desc = "LSP Info (attached only)",
      },
    },
  },
}
