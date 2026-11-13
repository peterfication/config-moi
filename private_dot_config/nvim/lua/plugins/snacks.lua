return {
  {
    "snacks.nvim",
    opts = {
      input = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true,
      },
      scroll = {
        animate = {
          duration = { step = 10, total = 100 },
          easing = "linear",
        },
      },
      notifier = { enabled = false },
      dashboard = {
        preset = {
          header = [[
                                               |\__/,|   (`\
                                             _.|o o  |_   ) )
                                           -(((---(((--------
]],
          keys = {
            { icon = " ", key = "g", desc = "Lazygit", action = ":lua Snacks.lazygit.open()" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "s", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            -- {
            --   icon = " ",
            --   key = "c",
            --   desc = "Config",
            --   action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            -- },
            -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            -- { icon = "󰒲 ", key = "x", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            -- { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
      lazygit = {
        config = {
          os = {
            -- Close the terminal synchronously before opening in the current tab.
            -- A queued "q" can run after --remote and send the line jump to the wrong window.
            edit = [[[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-expr "execute('stopinsert | close')" && nvim --server "$NVIM" --remote {{filename}})]],
            editAtLine = [[[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-expr "execute('stopinsert | close')" && nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")]],
            editAtLineAndWait = "nvim +{{line}} {{filename}}",
            openDirInEditor = [[[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-expr "execute('stopinsert | close')" && nvim --server "$NVIM" --remote {{dir}})]],
          },
        },
      },
    },
  },

  {
    "stevearc/dressing.nvim",
    enabled = false,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPre",
    branch = "v1",
    opts = {
      set_highlights = true,
      handlers = {
        gitsigns = true,
      },
      marks = {
        GitAdd = { text = "┃" },
        GitChange = { text = "┃" },
        GitDelete = { text = "_" },
      },
    },
  },
}
