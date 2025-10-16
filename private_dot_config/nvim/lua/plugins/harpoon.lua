return {
  {
    -- Intro by the author: https://www.youtube.com/watch?v=Qnos8aApa9g
    "theprimeagen/harpoon",
    opts = {
      yeet = {
        select = function(list_item, _, _)
          require("yeet").execute(list_item.value)
        end,
      },
    },
    init = function()
      local harpoon = require("harpoon")

      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-x>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })
    end,
    keys = function()
      -- Telescope setup for harpoon picker
      local function toggle_telescope(harpoon_files)
        local conf = require("telescope.config").values
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      return {
        { "<Leader>h", group = "Harpoon" },
        {
          "<Leader>he",
          function()
            toggle_telescope(require("harpoon"):list())
          end,
          desc = "Open harpoon in Telescope",
        },
        {
          "<Leader>hh",
          function()
            require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
          end,
          desc = "Toggle harpoon quick menu",
        },
        {
          "<Leader>ha",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Add current file to harpoon",
        },
        {
          "<Leader>h1",
          function()
            require("harpoon"):list():select(1)
          end,
          desc = "Go to harpoon file 1",
        },
        {
          "<Leader>h2",
          function()
            require("harpoon"):list():select(2)
          end,
          desc = "Go to harpoon file 2",
        },
        {
          "<Leader>h3",
          function()
            require("harpoon"):list():select(3)
          end,
          desc = "Go to harpoon file 3",
        },
        {
          "<Leader>h4",
          function()
            require("harpoon"):list():select(4)
          end,
          desc = "Go to harpoon file 4",
        },
        {
          "<Leader>hk",
          function()
            require("harpoon"):list():prev()
          end,
          desc = "Go to previous harpoon file",
        },
        {
          "<Leader>hj",
          function()
            require("harpoon"):list():next()
          end,
          desc = "Go to next harpoon file",
        },
      }
    end,
  },

  {
    "samharju/yeet.nvim",
    cmd = "Yeet",
    keys = function()
      -- Telescope setup for yeet picker
      local function toggle_telescope_yeet(harpoon_lines)
        local conf = require("telescope.config").values
        local commands = {}
        for _, item in ipairs(harpoon_lines.items) do
          vim.print(vim.inspect(item))
          table.insert(commands, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Yeet",
            finder = require("telescope.finders").new_table({
              results = commands,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(_, map)
              local function submit(_prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                vim.print(vim.inspect(selection[1]))
                require("yeet").execute(selection[1])
              end
              map("i", "<CR>", submit)
              map("n", "<CR>", submit)
              return true
            end,
          })
          :find()
      end

      return {
        { "<Leader><BS>", group = "Yeet" },
        {
          "<Leader><BS><BS>",
          function()
            require("harpoon").ui:toggle_quick_menu(require("harpoon"):list("yeet"), { height_in_lines = 40 })
          end,
          desc = "Toggle yeet harpoon quick menu",
        },
        {
          "<Leader><BS>e",
          function()
            toggle_telescope_yeet(require("harpoon"):list("yeet"))
          end,
          desc = "Open yeet harpoon in Telescope",
        },
        { "<Leader><BS>r", "<CMD>Yeet execute<CR>", desc = "Repeat last yeet" },
      }
    end,
  },
}
