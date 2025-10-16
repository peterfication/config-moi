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
      { "<Leader>v", group = "chatgpt" },
      { "<Leader>vv", ":CopilotChatToggle<CR>", desc = "Toggle CopilotChat" },
      {
        "<Leader>vn",
        ":CopilotChatReset<CR>:CopilotChatOpen<CR>",
        desc = "Open CopilotChat with a new session",
      },
    },
  },
}
