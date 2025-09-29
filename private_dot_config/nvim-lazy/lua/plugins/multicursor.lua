return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<C-n>", function()
          mc.matchAddCursor(1)
        end)
        layerSet({ "n", "x" }, "<C-p>", mc.deleteCursor)
        layerSet({ "n", "x" }, "<C-j>", function()
          mc.lineAddCursor(1)
        end)
        layerSet({ "n", "x" }, "<C-k>", mc.deleteCursor)
        layerSet({ "n", "x" }, "<C-h>", mc.prevCursor)
        layerSet({ "n", "x" }, "<C-l>", mc.nextCursor)
        layerSet({ "n", "x" }, "<C-d>", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
    keys = {
      {
        "<Leader>kn",
        function()
          require("multicursor-nvim").matchAddCursor(1)
        end,
        mode = { "n", "x" },
        desc = "Go into visual mode and select the current word under the cursor and go to the next",
      },
      {
        "<Leader>kp",
        function()
          require("multicursor-nvim").matchAddCursor(-1)
        end,
        mode = { "n", "x" },
        desc = "Go into visual mode and select the current word under the cursor and go to the previous",
      },
      {
        "<Leader>kj",
        function()
          require("multicursor-nvim").lineAddCursor(1)
        end,
        mode = { "n", "x" },
        desc = "Go into visual mode and select the current line/cursor position and go down",
      },
      {
        "<Leader>kk",
        function()
          require("multicursor-nvim").lineAddCursor(1)
        end,
        mode = { "n", "x" },
        desc = "Go into visual mode and select the current line/cursor position and go up",
      },
    },
  },
}
