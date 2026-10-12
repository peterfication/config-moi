return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit" },
    -- keys = {
    --   { "<Leader>GV", ":Git blame<CR>", desc = "Open Git blame with fugitive" },
    -- },
  },

  {
    -- "sindrets/diffview.nvim",
    -- The original repo seems to be unmaintained
    -- See https://github.com/sindrets/diffview.nvim/issues/605
    "dlyongemallo/diffview-plus.nvim",
    opts = function(_, opts)
      local actions = require("diffview.actions")
      local conflict_keymaps = {
        { "n", "<leader>co", false },
        { "n", "<leader>ct", false },
        { "n", "<leader>cb", false },
        { "n", "<leader>ca", false },
        { "n", "<leader>cO", false },
        { "n", "<leader>cT", false },
        { "n", "<leader>cB", false },
        { "n", "<leader>cA", false },
        { "n", "<leader>cso", false },
        { "n", "<leader>cst", false },
        { "n", "<leader>csb", false },
        { "n", "<localleader>o", actions.conflict_choose("ours"), { desc = "Choose the OURS version of a conflict" } },
        {
          "n",
          "<localleader>t",
          actions.conflict_choose("theirs"),
          { desc = "Choose the THEIRS version of a conflict" },
        },
        { "n", "<localleader>b", actions.conflict_choose("base"), { desc = "Choose the BASE version of a conflict" } },
        { "n", "<localleader>a", actions.conflict_choose("all"), { desc = "Choose all versions of a conflict" } },
        { "n", "<localleader>d", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
        {
          "n",
          "<localleader>O",
          actions.conflict_choose_all("ours"),
          { desc = "Choose the OURS version for the whole file" },
        },
        {
          "n",
          "<localleader>T",
          actions.conflict_choose_all("theirs"),
          { desc = "Choose the THEIRS version for the whole file" },
        },
        {
          "n",
          "<localleader>B",
          actions.conflict_choose_all("base"),
          { desc = "Choose the BASE version for the whole file" },
        },
        {
          "n",
          "<localleader>A",
          actions.conflict_choose_all("all"),
          { desc = "Choose all versions for the whole file" },
        },
        {
          "n",
          "<localleader>so",
          actions.conflict_choose_side("ours"),
          { desc = "Replace the MERGED buffer with the entire OURS side" },
        },
        {
          "n",
          "<localleader>st",
          actions.conflict_choose_side("theirs"),
          { desc = "Replace the MERGED buffer with the entire THEIRS side" },
        },
        {
          "n",
          "<localleader>sb",
          actions.conflict_choose_side("base"),
          { desc = "Replace the MERGED buffer with the entire BASE side" },
        },
      }

      opts.keymaps = opts.keymaps or {}
      opts.keymaps.view = vim.list_extend(opts.keymaps.view or {}, {
        { "n", "<leader>e", false },
        { "n", "<leader>b", false },
        { "n", "<localleader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
        { "n", "<localleader>f", actions.toggle_files, { desc = "Toggle the file panel" } },
      })

      for _, layout in ipairs({ "diff1", "diff3", "diff4" }) do
        opts.keymaps[layout] = vim.list_extend(opts.keymaps[layout] or {}, conflict_keymaps)
      end

      opts.keymaps.file_panel = vim.list_extend(opts.keymaps.file_panel or {}, {
        { "n", "<cr>", actions.focus_entry, { desc = "Open the selected file and focus its diff" } },
        { "n", "<leader>e", false },
        { "n", "<leader>b", false },
        { "n", "<localleader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
        { "n", "<localleader>f", actions.toggle_files, { desc = "Toggle the file panel" } },
        { "n", "<leader>cO", false },
        { "n", "<leader>cT", false },
        { "n", "<leader>cB", false },
        { "n", "<leader>cA", false },
        {
          "n",
          "<localleader>O",
          actions.conflict_choose_all("ours"),
          { desc = "Choose the OURS version for the whole file" },
        },
        {
          "n",
          "<localleader>T",
          actions.conflict_choose_all("theirs"),
          { desc = "Choose the THEIRS version for the whole file" },
        },
        {
          "n",
          "<localleader>B",
          actions.conflict_choose_all("base"),
          { desc = "Choose the BASE version for the whole file" },
        },
        {
          "n",
          "<localleader>A",
          actions.conflict_choose_all("all"),
          { desc = "Choose all versions for the whole file" },
        },
        {
          "n",
          "<localleader>D",
          actions.conflict_choose_all("none"),
          { desc = "Delete the conflict region for the whole file" },
        },
      })

      opts.keymaps.file_history_panel = vim.list_extend(opts.keymaps.file_history_panel or {}, {
        { "n", "<leader>e", false },
        { "n", "<leader>b", false },
        { "n", "<localleader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
        { "n", "<localleader>f", actions.toggle_files, { desc = "Toggle the file panel" } },
        {
          "n",
          "s",
          function()
            require("diffview.actions").open_in_diffview()
          end,
          { nowait = true, desc = "Open the entry under the cursor in a diffview" },
        },
      })
    end,
    init = function()
      -- Close the commit_log view when pressing 'q'
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "git",
        callback = function()
          vim.keymap.set("n", "q", "<CMD>close<CR>", { buffer = true, silent = true })
        end,
      })
    end,
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      {
        "<Leader>GDF",
        ":DiffviewFileHistory %<CR>",
        desc = "Open DiffView with the Git history of the current file",
      },
      {
        "<Leader>GDM",
        ":DiffviewOpen<CR>",
        desc = "Open DiffView (e.g. for merge conflicts)",
      },
      {
        "<Leader>GDR",
        ":DiffviewOpen origin/main...HEAD<CR>",
        desc = "Open DiffView for current branch against main (like a PR)",
      },
    },
  },

  {
    "tig",
    virtual = true,
    keys = function()
      local tig_blame_term_open = function()
        local file = vim.fn.expand("%")
        local tig_term = require("toggleterm.terminal").Terminal:new({
          cmd = "tig blame " .. file,
          direction = "float",
          close_on_exit = true,
          count = 10,
          hidden = true,
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          end,
        })
        tig_term:toggle()
      end

      return {
        { "<Leader>GBT", tig_blame_term_open, desc = "Open tig for current file" },
      }
    end,
  },

  -- Get links to the current line on GitHub, GitLab, Bitbucket, etc.
  {
    "ruifm/gitlinker.nvim",
    opts = {
      mappings = nil,
    },
    keys = {
      {
        "<Leader>gy",
        '<CMD>lua require"gitlinker".get_buf_range_url("n")<CR>',
        desc = "Copy the link for current line on Github",
        mode = "n",
      },
      {
        "<Leader>gy",
        '<CMD>lua require"gitlinker".get_buf_range_url("v")<CR>',
        desc = "Copy the link for current line on Github",
        mode = "v",
      },
    },
  },

  {
    "pwntester/octo.nvim",
    opts = function(_, opts)
      opts.default_merge_method = "merge"

      local group = vim.api.nvim_create_augroup("octo_review_diff_localleader_dash", { clear = true })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = "octo://*",
        callback = function(ev)
          local ok = pcall(vim.api.nvim_buf_get_var, ev.buf, "octo_diff_props")
          if not ok then
            return
          end

          vim.keymap.set("n", "<localleader><Space>", function()
            local reviews = require("octo.reviews")
            local layout = reviews.get_current_layout()
            if not layout then
              return
            end

            local current = layout.files[layout.selected_file_idx]
            if not current or current.viewed_state == "VIEWED" then
              return
            end

            local has_next_unviewed = false
            for i, file in ipairs(layout.files) do
              if i ~= layout.selected_file_idx and file.viewed_state ~= "VIEWED" then
                has_next_unviewed = true
                break
              end
            end

            current:toggle_viewed()

            if has_next_unviewed then
              vim.defer_fn(function()
                local fresh_layout = reviews.get_current_layout()
                if fresh_layout then
                  fresh_layout:select_next_unviewed_file()
                end
              end, 150)
            end
          end, {
            buffer = ev.buf,
            silent = true,
            desc = "mark viewed and jump to next unviewed file",
          })
        end,
      })
    end,
    keys = {
      {
        "<Leader>Goi",
        ":Telescope gh issues<CR>",
        desc = "Open Github issues in Telescope ([o]cto [i]ssues)",
      },
      {
        "<Leader>Gop",
        ":Telescope gh pull_request<CR>",
        desc = "Open Github pull requests in Telescope ([o]cto [p]ull requests)",
      },
    },
  },
}
