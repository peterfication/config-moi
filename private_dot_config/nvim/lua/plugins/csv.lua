return {
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      -- parser = { comments = { "#", "//" } },
      -- keymaps = {
      --   -- Text objects for selecting fields
      --   textobject_field_inner = { "if", mode = { "o", "x" } },
      --   textobject_field_outer = { "af", mode = { "o", "x" } },
      --   -- Excel-like navigation:
      --   -- Use <Tab> and <S-Tab> to move horizontally between fields.
      --   -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
      --   -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      --   jump_next_row = { "<Enter>", mode = { "n", "v" } },
      --   jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      -- },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    keys = {
      { "<leader>c,", "<cmd>CsvViewToggle delimiter=,<cr>", ft = "csv", desc = "Toggle CSV view (comma)" },
      { "<leader>c;", "<cmd>CsvViewToggle delimiter=;<cr>", ft = "csv", desc = "Toggle CSV view (semicolon)" },
    },
  },

  {
    "csvlens",
    virtual = true,
    dependencies = { "akinsho/toggleterm.nvim" },
    keys = function()
      local csvlens_term_open = function()
        local file = vim.api.nvim_buf_get_name(0)
        if file == "" then
          vim.notify("Cannot open unnamed buffer in csvlens", vim.log.levels.WARN)
          return
        end

        local csvlens_term = require("toggleterm.terminal").Terminal:new({
          display_name = "csvlens",
          cmd = "csvlens -d auto " .. vim.fn.shellescape(file),
          direction = "float",
          close_on_exit = true,
          hidden = true,
        })
        csvlens_term:toggle()
      end

      return {
        { "<leader>c.", csvlens_term_open, ft = "csv", desc = "Open current file in csvlens" },
      }
    end,
  },
}
