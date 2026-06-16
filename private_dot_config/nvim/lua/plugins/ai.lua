if true then
  return {
    {
      "folke/sidekick.nvim",
      opts = {
        cli = {
          mux = {
            enabled = true,
            create = "window",
          },
          tools = {
            antigravity = {
              cmd = { "agy" },
              is_proc = "\\<agy\\>",
              resume = { "--continue" },
              continue = { "--continue" },
              url = "https://antigravity.google/docs/cli-overview",
              format = function(text)
                require("sidekick.text").transform(text, function(str)
                  return str:find("[^%w/_%.%-]") and ('"' .. str .. '"') or str
                end, "SidekickLocFile")
              end,
            },
          },
        },
      },
    },
  }
end

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      auto_insert_mode = false,
      window = {
        layout = "float", -- 'vertical', 'horizontal', 'float'
        border = "double", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        width = 0.9,
        height = 0.8,
      },
    },
    keys = {
      { "<Leader>aa", false },
      {
        "<Leader>ag",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "x" },
      },
    },
  },

  {
    "yetone/avante.nvim",
    opts = {
      provider = "codex",

      acp_providers = {
        codex = {
          command = "codex-acp",
          args = {},
        },
      },

      windows = {
        edit = {
          start_insert = false,
        },
        ask = {
          start_insert = false,
        },
      },
    },
    keys = {
      { "<Leader>aa", "<cmd>AvanteAsk<CR>", desc = "Ask Avante" },
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
        "<Leader>ak",
        "<CMD>CodeCompanionChat Toggle<CR>",
        desc = "Chat with Code Companion",
      },
    },
  },
}
