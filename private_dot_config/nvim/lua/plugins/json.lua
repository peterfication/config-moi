return {
  {
    "fx",
    virtual = true,
    dependencies = { "akinsho/toggleterm.nvim" },
    keys = function()
      local fx_term_open = function()
        local file = vim.api.nvim_buf_get_name(0)
        if file == "" then
          vim.notify("Cannot open unnamed buffer in fx", vim.log.levels.WARN)
          return
        end

        local fx_term = require("toggleterm.terminal").Terminal:new({
          display_name = "fx",
          cmd = "fx " .. vim.fn.shellescape(file),
          direction = "float",
          close_on_exit = true,
          hidden = true,
        })
        fx_term:toggle()
      end

      return {
        { "<leader>c.", fx_term_open, ft = "json", desc = "Open current file in fx" },
      }
    end,
  },
}
