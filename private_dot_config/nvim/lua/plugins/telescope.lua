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

    keys = {
      { "<leader><space>", false },
      { "<Leader>fT", ":Telescope pickers<CR>", desc = "Picker history" },
      { "<Leader>ft", ":Telescope builtin<CR>", desc = "Telescope builtins" },
      { "<Leader>fq", ":Telescope quickfixhistory<CR>", desc = "Quickfix history" },
      { "<Leader>sz", ":Telescope treesitter<CR>", desc = "Treesitter buffer symbols" },
      { "<Leader>gC", ":Telescope git_bcommits<CR>", desc = "Commits (Buffer)" },

      {
        "<Leader>fa",
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
        desc = "Find all files",
      },
    },
  },
}
