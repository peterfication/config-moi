return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      auto_insert_mode = false,
      window = {
        layout = "float",  -- 'vertical', 'horizontal', 'float'
        border = "double", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        width = 0.9,
        height = 0.8,
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    cmd = { "CodeCompanionChat", "CodeCompanionChatEdit" },
    opts = {
      interactions = {
        chat = {
          adapter = "codex",
        },
        -- ACP adapters are for chat only; don't set inline = "codex"
      },

      adapters = {
        acp = {
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chatgpt", -- or: "openai-api-key" | "codex-api-key"
              },
            })
          end,
        },
      },

      opts = {
        log_level = "INFO",
      },
    },
    keys = {
      {
        "<Leader>ac",
        "<CMD>CodeCompanionChat<CR>",
        desc = "Chat with Code Companion",
      },
    },
  },
}
