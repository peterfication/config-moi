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
            -- These values differ from the preset in that they don't open a new tab
            -- https://github.com/jesseduffield/lazygit/blob/d1d2bb23b6b9d862fbd16aac20b029eec01ddc8d/pkg/config/editor_presets.go#L64
            edit = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})',
            editAtLine = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" &&  nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
            editAtLineAndWait = "nvim +{{line}} {{filename}}",
            openDirInEditor = '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
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
