return {
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = true,
    opts = function()
      -- Calculate the width and height based on the current window size
      width = math.floor(vim.o.columns * 0.9)
      height = math.floor(vim.o.lines * 0.9)

      return {
        width = width,
        height = height,
      }
    end,
    keys = {
      { "gp",  group = "Goto Preview" },
      { "gpd", "<CMD>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview Definition" },
      { "gP",  "<CMD>lua require('goto-preview').close_all_win()<CR>",           desc = "Close preview windows" },
    },
  },
}
