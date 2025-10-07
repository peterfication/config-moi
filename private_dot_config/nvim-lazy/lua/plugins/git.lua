return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
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
    "sindrets/diffview.nvim",
    opts = {
      keymaps = {
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
    keys = {
      {
        "<Leader>GG",
        ":DiffviewFileHistory %<CR>",
        desc = "Open DiffView with the Git history of the current file",
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      numhl = true,
      current_line_blame_opts = {
        delay = 100,
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "ghn", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "ghp", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        -- map({'n', 'v'}, '<Leader>hs', ':Gitsigns stage_hunk<CR>')
        -- map({'n', 'v'}, '<Leader>hr', ':Gitsigns reset_hunk<CR>')
        -- map('n', '<Leader>hS', gs.stage_buffer)
        -- map('n', '<Leader>hu', gs.undo_stage_hunk)
        -- map('n', '<Leader>hR', gs.reset_buffer)
        map("n", "<Leader>ghs", gs.preview_hunk)
        map("n", "<Leader>ghr", gs.reset_hunk)
        -- map('n', '<Leader>hb', function() gs.blame_line{full=true} end)
        map("n", "<Leader>gb", gs.toggle_current_line_blame)
        map("n", "<Leader>ghd", gs.diffthis)
        map("n", "<Leader>ghD", function()
          gs.diffthis("~")
        end)
        -- map('n', '<Leader>td', gs.toggle_deleted)
      end,
    },
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
        { "<Leader>gb", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toogle Git blame current line" },
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
}
