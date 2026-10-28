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
