return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local action_window_picker = function(_prompt_bufnr)
        local picker = require("window-picker")
        local winid = picker.pick_window()
        if winid then
          local entry = require("telescope.actions.state").get_selected_entry()
          if entry and entry.filename then
            vim.api.nvim_set_current_win(winid)
            vim.cmd("edit " .. entry.filename)
          end
        end
      end
      local open_with_trouble = function(...)
        return require("trouble.sources.telescope").open(...)
      end

      local additional_opts = {
        defaults = {
          cache_picker = {
            num_pickers = 100,
          },
          mappings = {
            i = {
              ["<c-t>"] = actions.select_tab,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-d>"] = actions.delete_buffer,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-w>"] = action_window_picker,
            },
            n = {
              ["d"] = actions.delete_buffer,
              ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["q"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["w"] = action_window_picker,
              ["<a-t>"] = open_with_trouble,
            },
          },
          preview = {
            -- luacheck: ignore 631
            -- From https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#use-terminal-image-viewer-to-preview-images
            mime_hook = function(filepath, bufnr, _preview_opts)
              local is_image = function(img_filepath)
                local image_extensions = { "png", "jpg" } -- Supported image formats
                local split_path = vim.split(img_filepath:lower(), ".", { plain = true })
                local extension = split_path[#split_path]
                return vim.tbl_contains(image_extensions, extension)
              end

              if is_image(filepath) then
                local term = vim.api.nvim_open_term(bufnr, {})
                local function send_output(_, data, _)
                  for _, d in ipairs(data) do
                    vim.api.nvim_chan_send(term, d .. "\r\n")
                  end
                end
                vim.fn.jobstart({
                  "catimg",
                  -- "viu",
                  filepath, -- Terminal image viewer command
                }, { on_stdout = send_output, stdout_buffered = true, pty = true })
              else
                require("telescope.previewers.utils").set_preview_message(
                  bufnr,
                  opts.winid,
                  "Binary cannot be previewed"
                )
              end
            end,
          },
        },
        pickers = {
          git_commits = {
            mappings = {
              n = {
                ["d"] = function()
                  -- Open in diffview
                  local selected_entry = action_state.get_selected_entry()
                  local value = selected_entry.value
                  -- close Telescope window properly prior to switching windows
                  vim.api.nvim_win_close(0, true)
                  vim.cmd("stopinsert")
                  vim.schedule(function()
                    vim.cmd(("DiffviewOpen %s^!"):format(value))
                  end)
                end,
              },
              i = {
                ["<C-d>"] = function()
                  -- Open in diffview
                  local selected_entry = action_state.get_selected_entry()
                  local value = selected_entry.value
                  -- close Telescope window properly prior to switching windows
                  vim.api.nvim_win_close(0, true)
                  vim.cmd("stopinsert")
                  vim.schedule(function()
                    vim.cmd(("DiffviewOpen %s^!"):format(value))
                  end)
                end,
              },
            },
          },
        },
      }

      return vim.tbl_deep_extend("force", opts, additional_opts)
    end,

    keys = function()
      return {
        {
          "<Leader>je",
          function()
            require("telescope.builtin").find_files()
          end,
          desc = "Find files with Telescope",
        },
        {
          "<Leader>jg",
          function()
            require("telescope.builtin").git_files()
          end,
          desc = "Find Git ls-files with Telescope",
        },
        {
          "<Leader>jh",
          function()
            require("telescope.builtin").oldfiles({ cwd_only = true })
          end,
          desc = "Recent files with Telescope",
        },
        {
          "<Leader>ja",
          function()
            require("telescope.builtin").find_files({
              find_command = {
                "rg",
                "--files",
                "--hidden",
                "--no-ignore",
                "--maxdepth",
                2,
                "--glob",
                "!.git/*",
                "--glob",
                "!.venv/*",
                "--glob",
                "!node_modules/*",
              },
            })
          end,
          desc = "Find all files with Telescope",
        },

        {
          "<Leader>jE",
          function()
            require("telescope.builtin").buffers()
          end,
          desc = "Find files of currently open buffers",
        },

        {
          "<Leader>jj",
          function()
            require("telescope.builtin").live_grep()
          end,
          desc = "Telescope live grep search (Use <C-Space> to refine the search)",
        },
        {
          "<Leader>jT",
          function()
            require("telescope.builtin").grep_string({ search = "TODO:" })
          end,
          desc = "List all TODO: comments in Telescope",
        },
        {
          "<Leader>jf",
          function()
            require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ") })
          end,
          desc = "Open input to search for word with Telescope",
        },

        {
          "<Leader>jJ",
          function()
            require("telescope.builtin").grep_string()
          end,
          desc = "Find word under cursor with Telescope",
          mode = { "n", "v" },
        },

        {
          "<Leader>jH",
          function()
            require("telescope.builtin").pickers()
          end,
          desc = "Telescope history",
        },
        {
          "<Leader>j/",
          function()
            require("telescope.builtin").pickers()
          end,
          desc = "Search history with Telescope",
        },

        {
          "<Leader>jl",
          function()
            require("telescope.builtin").current_buffer_fuzzy_find()
          end,
          desc = "Select lines of current buffer with Telescope",
        },

        {
          "<Leader>jd",
          function()
            require("telescope.builtin").diagnostics()
          end,
          desc = "Diagnostics of project with Telescope",
        },
        {
          "<Leader>jD",
          ":Telescope diagnostics bufnr=0<CR>",
          desc = "Diagnostics of current buffer with Telescope",
        },
        {
          "<Leader>xJ",
          function()
            require("telescope.builtin").diagnostics()
          end,
          desc = "Diagnostics of project with Telescope",
        },
        {
          "<Leader>xj",
          ":Telescope diagnostics bufnr=0<CR>",
          desc = "Diagnostics of current buffer with Telescope",
        },

        {
          "<Leader>jm",
          function()
            require("telescope.builtin").marks()
          end,
          desc = "Open marks in Telescope",
        },
        {
          "<Leader>jj",
          function()
            require("telescope.builtin").jumplist()
          end,
          desc = "Open jumplist in Telescope",
        },

        {
          "<Leader>jc",
          function()
            require("telescope.builtin").commands()
          end,
          desc = "Open commands in Telescope",
        },
        {
          "<Leader>jC",
          function()
            require("telescope.builtin").command_history()
          end,
          desc = "Open command history in Telescope",
        },

        {
          "<Leader>jb",
          function()
            require("telescope.builtin").builtin()
          end,
          desc = "Open builtin Telescope actions in Telescope",
        },

        { "<Leader>jqh", ":Telescope quickfixhistory<CR>", desc = "Open quickfix history in Telescope" },
        { "<Leader>jqq", ":Telescope quickfix<CR>", desc = "Open quickfix list in Telescope" },

        {
          "<Leader>jZ",
          function()
            require("telescope.builtin").treesitter()
          end,
          desc = "Open Treesitter in Telescope",
        },
        {
          "<Leader>jT",
          function()
            require("telescope.builtin").current_buffer_tags()
          end,
          desc = "Open current buffer tags in Telescope",
        },

        -- Git Subcommands

        {
          "<Leader>gc",
          function()
            require("telescope.builtin").git_commits()
          end,
          desc = "Open Git commits in Telescope (<C-d> opens DiffView)",
        },

        {
          "<Leader>GC",
          function()
            require("telescope.builtin").git_bcommits()
          end,
          desc = "Open current buffer Git commits in Telescope (<C-d> opens DiffView)",
        },
        {
          "<Leader>GS",
          function()
            require("telescope.builtin").git_status()
          end,
          desc = "Open Git status files in Telescope",
        },

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
      }
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    opts = function()
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("ui-select")
      end)
    end,
  },
}
