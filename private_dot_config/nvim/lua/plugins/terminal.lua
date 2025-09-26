return {
  {
    "akinsho/toggleterm.nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      local toggleterm = require("toggleterm")
      local toggleterm_terminal = require("toggleterm.terminal")

      toggleterm.setup({
        auto_scroll = false,
        open_mapping = [[<c-t>]],
        direction = "float",
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      local function open_new_terminal()
        local terms = toggleterm_terminal.get_all(true)
        local next_index = #terms + 1
        toggleterm.toggle(next_index)
      end

      require("which-key").add({
        { "<Leader>gd", ':8TermExec cmd="lazydocker; exit" direction=float<CR>', desc = "Open lazydocker" },
        { "<Leader>t1", "<CMD>ToggleTerm 1<CR>", desc = "Open terminal 1" },
        { "<Leader>t2", "<CMD>ToggleTerm 2<CR>", desc = "Open terminal 2" },
        { "<Leader>t3", "<CMD>ToggleTerm 3<CR>", desc = "Open terminal 3" },
        { "<Leader>t4", "<CMD>ToggleTerm 4<CR>", desc = "Open terminal 4" },
        { "<Leader>t5", "<CMD>ToggleTerm 5<CR>", desc = "Open terminal 5" },
        { "<Leader>t6", "<CMD>ToggleTerm 6<CR>", desc = "Open terminal 6" },
        { "<Leader>t7", "<CMD>ToggleTerm 7<CR>", desc = "Open terminal 7" },
        { "<Leader>t8", "<CMD>ToggleTerm 8<CR>", desc = "Open terminal 8" },
        { "<Leader>t9", "<CMD>ToggleTerm 9<CR>", desc = "Open terminal 9" },
        { "<Leader>te", "<CMD>TermSelect<CR>", desc = "Select terminal to show" },
        { "<Leader>tn", open_new_terminal, desc = "Open a new terminal" },
      })

      require("which-key").add({
        -- NOTE: <Leader><ESC> would be a nice mapping but this will mess with spaces that
        -- that you want to enter.
        { "<C-Space>", [[<C-\><C-n>]], desc = "In terminal, go from INSERT to NORMAL mode", mode = "t" },
      })

      -- The prev/next functionality is taken from https://github.com/akinsho/toggleterm.nvim/issues/522
      local function get_term_index(current_id)
        vim.print("get term index current_id: " .. current_id)
        local terms = toggleterm_terminal.get_all(true)
        local idx

        for i, v in ipairs(terms) do
          if v.id == current_id then
            idx = i
          end
        end

        vim.print("get term index current_id: " .. current_id .. " term index: " .. idx)
        return idx
      end

      -- local function go_prev_term()
      --   local current_id = vim.b.toggle_number
      --   if current_id == nil then
      --     return
      --   end

      --   local terms = require("toggleterm.terminal").get_all(true)
      --   local prev_index

      --   local index = get_term_index(current_id, terms)
      --   if index > 1 then
      --     prev_index = index - 1
      --   else
      --     prev_index = #terms
      --   end
      --   require("toggleterm").toggle(index)
      --   require("toggleterm").toggle(prev_index)
      -- end

      local function go_next_term()
        local current_id = vim.b.toggle_number
        if current_id == nil then
          return
        end

        local terms = toggleterm_terminal.get_all(true)
        local next_index

        local index = get_term_index(current_id)
        if index == #terms then
          next_index = 1
        else
          next_index = index + 1
        end
        vim.print("length: " .. #terms .. " current index: " .. index .. " next index: " .. next_index)
        -- Only toggle if index and next_index are different
        if index ~= next_index then
          toggleterm.toggle(index)
          toggleterm.toggle(next_index)
        end
      end

      -- vim.keymap.set({ "n", "i", "t" }, "<C-5>", function()
      --   go_prev_term()
      -- end, { desc = "Toggle term previous" })
      vim.keymap.set({ "n", "i", "t" }, "<C-k>", function()
        go_next_term()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "x!", true)
      end, { desc = "Toggle term next" })

      -- From https://github.com/akinsho/toggleterm.nvim/issues/116#issuecomment-1163129278
      -- In a floating terminal, go to a file under the cursor with gF
      -- but don't open the file in the floating terminal window, instead close the floating terminal
      -- and open the file in the previous window.
      vim.api.nvim_create_augroup("ToggleTerm", {})
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = function()
          vim.keymap.set("n", "gf", function()
            vim.cmd("tabedit " .. vim.fn.expand("<cfile>"))
          end, { buffer = true })
        end,
        group = "ToggleTerm",
      })
    end,
  },
  -- {
  --   "stevearc/overseer.nvim",
  --   opts = {},
  --   config = function()
  --     require("overseer").setup()
  --     require("which-key").add({
  --       { "<Leader>r", group = "Run" },
  --       { "<Leader>rr", ":OverseerRun<CR>", desc = "Run a task" },
  --       { "<Leader>rt", ":OverseerToggle<CR>", desc = "Toggle the overseer window" },
  --       { "<Leader>rc", ":OverseerClose<CR>", desc = "Close the overseer window" },
  --       { "<Leader>ro", ":OverseerOpen<CR>", desc = "Open the overseer window" },
  --       { "<Leader>rl", ":OverseerLoadBundle!<CR>", desc = "Load a task bundle" },
  --       { "<Leader>ru", ":OverseerUpdateBundle<CR>", desc = "Update a task bundle" },
  --     })
  --   end,
  -- },
  {
    "samharju/yeet.nvim",
    cmd = "Yeet",
    opts = {},
  },
  {
    -- Intro by the author: https://www.youtube.com/watch?v=Qnos8aApa9g
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "samharju/yeet.nvim",
      "folke/which-key.nvim",
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
        yeet = {
          select = function(list_item, _, _)
            require("yeet").execute(list_item.value)
          end,
        },
      })

      -- Telescope setup
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
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

      require("which-key").add({ { "<Leader>h", group = "Harpoon" } })
      vim.keymap.set("n", "<Leader>he", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon in Telescope" })
      vim.keymap.set("n", "<Leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Toggle harpoon quick menu" })
      vim.keymap.set("n", "<Leader>ha", function()
        harpoon:list():add()
      end, { desc = "Add current file to harpoon" })
      vim.keymap.set("n", "<Leader>h1", function()
        harpoon:list():select(1)
      end, { desc = "Go to harpoon file 1" })
      vim.keymap.set("n", "<Leader>h2", function()
        harpoon:list():select(2)
      end, { desc = "Go to harpoon file 2" })
      vim.keymap.set("n", "<Leader>h3", function()
        harpoon:list():select(3)
      end, { desc = "Go to harpoon file 3" })
      vim.keymap.set("n", "<Leader>h4", function()
        harpoon:list():select(4)
      end, { desc = "Go to harpoon file 4" })
      vim.keymap.set("n", "<Leader>hk", function()
        harpoon:list():prev()
      end, { desc = "Go to previous harpoon file" })
      vim.keymap.set("n", "<Leader>hj", function()
        harpoon:list():next()
      end, { desc = "Go to next harpoon file" })

      local function toggle_telescope_yeet(harpoon_lines)
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
              local function submit(prompt_bufnr)
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

      require("which-key").add({ { "<Leader><BS>", group = "Yeet" } })
      vim.keymap.set("n", "<Leader><BS><BS>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list("yeet"), { height_in_lines = 40 })
      end, { desc = "Toggle yeet harpoon quick menu" })
      vim.keymap.set("n", "<Leader><BS>e", function()
        toggle_telescope_yeet(harpoon:list("yeet"))
      end, { desc = "Open yeet harpoon in Telescope" })
      vim.keymap.set("n", "<Leader><BS>r", "<CMD>Yeet execute<CR>", { desc = "Repeat last yeet" })
    end,
  },
}
