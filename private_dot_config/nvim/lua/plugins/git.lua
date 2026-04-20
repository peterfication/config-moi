return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit" },
    -- keys = {
    --   { "<Leader>GV", ":Git blame<CR>", desc = "Open Git blame with fugitive" },
    -- },
  },

  {
    "FabijanZulj/blame.nvim",
    config = true,
    cmd = "BlameToggle",
    keys = {
      { "<Leader>GV", "<CMD>BlameToggle<CR>", desc = "Open Git blame" },
    },
  },

  {
    -- "sindrets/diffview.nvim",
    -- The original repo seems to be unmaintained
    -- See https://github.com/sindrets/diffview.nvim/issues/605
    "dlyongemallo/diffview.nvim",
    tag = "v0.23",
    opts = {
      keymaps = {
        view = {
          {
            "n",
            "ghc",
            function()
              require("diffview.actions").next_conflict()
            end,
            { nowait = true, desc = "Go to the next conflict" },
          },
        },
        file_history_panel = {
          {
            "n",
            "s",
            function()
              require("diffview.actions").open_in_diffview()
            end,
            { nowait = true, desc = "Open the entry under the cursor in a diffview" },
          },
        },
      },
    },
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
    keys = function()
      local tig_blame_term_open = function()
        local file = vim.fn.expand("%")
        local tig_term = require("toggleterm.terminal").Terminal:new({
          cmd = "tig blame " .. file,
          direction = "float",
          close_on_exit = true,
          count = 9,
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          end,
        })
        tig_term:toggle()
      end

      return {
        {
          "<Leader>GG",
          desc = "DiffView",
        },
        {
          "<Leader>GGF",
          ":DiffviewFileHistory %<CR>",
          desc = "Open DiffView with the Git history of the current file",
        },
        {
          "<Leader>GGM",
          ":DiffviewOpen<CR>",
          desc = "Open DiffView (e.g. for merge conflicts)",
        },
        {
          "<Leader>GGR",
          ":DiffviewOpen origin/main...HEAD<CR>",
          desc = "Open DiffView for current branch against main (like a PR)",
        },
        { "<Leader>GB", tig_blame_term_open, desc = "Open tig for current file" },
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
  },
}
