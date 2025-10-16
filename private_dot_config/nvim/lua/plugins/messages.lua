return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = "20%",
          },
        },
        -- notify = {
        --   win_options = {
        --     winblend = 80
        --   },
        -- },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      top_down = false,
      on_open = function(win)
        -- vim.api.nvim_win_set_option(win, "winblend", 80)
      end,
    },
    config = function()
      -- require("lualine").setup({
      --   sections = {
      --     lualine_x = {
      --       "encoding",
      --       "fileformat",
      --       "filetype",
      --       {
      --         require("noice").api.statusline.mode.get,
      --         cond = require("noice").api.statusline.mode.has,
      --         color = { fg = "#ff9e64" },
      --       },
      --     },
      --   },
      -- })
    end,
    keys = {
      { "<Leader>M", group = "Noice" },
      { "<Leader>MC", ":lua require('notify').dismiss()<CR>", desc = "Close all Noice messages" },
      { "<Leader>MF", ":Noice telescope<CR>", desc = "Open Noice messages in Telescope" },
      { "<Leader>MM", ":Noice<CR>", desc = "Open Noice messages" },
      { "<Leader>Mf", ":Noice telescope<CR>", desc = "Open Noice messages in Telescope" },
    },
  },
}
