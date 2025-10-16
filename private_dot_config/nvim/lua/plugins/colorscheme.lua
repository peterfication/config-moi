return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {},
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = "dark"

      require("solarized").setup(opts)

      vim.cmd.colorscheme("solarized")

      -- Commands to change background between dark to light
      vim.api.nvim_create_user_command("ColorschemeDark", function()
        vim.o.background = "dark"
      end, {})
      vim.api.nvim_create_user_command("ColorschemeLight", function()
        vim.o.background = "light"
      end, {})
      vim.api.nvim_create_user_command("ColorschemeToggle", function()
        if vim.o.background == "dark" then
          vim.o.background = "light"
        else
          vim.o.background = "dark"
        end
      end, {})
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized",
    },
  },
}
