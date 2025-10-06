return {
  {
    {
      "saghen/blink.cmp",
      opts = {
        completion = {
          menu = {
            auto_show = true,
          },
          ghost_text = {
            show_with_menu = false,
          },
        },
        keymap = {
          ["<Esc>"] = { "hide", "fallback" },
        },
        cmdline = {
          keymap = {
            ["<ESC>"] = {
              function(cmp)
                if cmp.is_visible() then
                  cmp.cancel()
                else
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
                end
              end,
            },
          },
        },
      },
    },
  },
}
