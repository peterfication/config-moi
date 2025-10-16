return {
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    keys = {
      -- Only set it for normal mode, so that when changing a word, it doesn't
      -- interfere with the normal mode keybindings. Alternatively, it could be set to
      -- { "n", "o", "x" } but then changing some.thing to other.thing wouldn't be possible
      -- with cw anymore.
      {
        "w",
        function()
          require("spider").motion("w")
        end,
        desc = "Spider-w",
      },
      {
        "e",
        function()
          require("spider").motion("e")
        end,
        desc = "Spider-e",
      },
      {
        "b",
        function()
          require("spider").motion("b")
        end,
        desc = "Spider-b",
      },
    },
  },
}
