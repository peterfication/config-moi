local filename_win
local filename_buf

local function close_filename()
  if filename_win and vim.api.nvim_win_is_valid(filename_win) then
    vim.api.nvim_win_close(filename_win, true)
  end
  filename_win = nil
  filename_buf = nil
end

local function update_filename()
  if vim.bo.filetype ~= "neo-tree" then
    close_filename()
    return
  end

  local state = require("neo-tree.sources.manager").get_state_for_window()
  local node = state and state.tree and state.tree:get_node()
  if not node or node.type == "message" then
    close_filename()
    return
  end

  local width = math.max(1, vim.o.columns - 2)
  local bottom = math.max(1, vim.o.lines - vim.o.cmdheight - (vim.o.laststatus > 0 and 1 or 0))
  local lines = vim.split(node.name, "\n", { plain = true })
  local height = 0
  for _, line in ipairs(lines) do
    height = height + math.max(1, math.ceil(vim.fn.strdisplaywidth(line) / width))
  end
  local config = {
    relative = "editor",
    anchor = "SW",
    row = bottom,
    col = 1,
    width = width,
    height = math.min(height, bottom),
    border = "none",
    focusable = false,
    style = "minimal",
    zindex = 60,
  }

  if not filename_buf or not vim.api.nvim_buf_is_valid(filename_buf) then
    filename_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[filename_buf].bufhidden = "wipe"
  end
  vim.api.nvim_buf_set_lines(filename_buf, 0, -1, false, lines)

  if filename_win and vim.api.nvim_win_is_valid(filename_win) then
    vim.api.nvim_win_set_config(filename_win, config)
  else
    filename_win = vim.api.nvim_open_win(filename_buf, false, vim.tbl_extend("force", config, { noautocmd = true }))
    vim.wo[filename_win].wrap = true
    vim.wo[filename_win].linebreak = false
    vim.wo[filename_win].breakindent = false
    vim.wo[filename_win].showbreak = ""
  end
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    init = function()
      local group = vim.api.nvim_create_augroup("NeoTreeFilenameDisplay", { clear = true })
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter", "WinEnter", "VimResized" }, {
        group = group,
        callback = update_filename,
      })
      vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "TabLeave" }, {
        group = group,
        callback = close_filename,
      })
    end,
    opts = {
      use_popups_for_input = true,

      filesystem = {
        window = {
          mappings = {
            ["o"] = "system_open",
            ["YY"] = "copy_file_name",
            ["YP"] = "copy_file_path",
            ["YR"] = "copy_relative_file_path",
          },
        },
        commands = {
          system_open = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            path = vim.fn.shellescape(path)
            -- macOs: open file in default application in the background.
            vim.api.nvim_command("silent !open " .. path)
            -- Linux: open file in default application
            -- vim.api.nvim_command("silent !xdg-open " .. path)
          end,
          copy_file_name = function(state)
            local node = state.tree:get_node()
            local content = node.name
            vim.fn.setreg('"', content)
            vim.fn.setreg("1", content)
            vim.fn.setreg("+", content)
            vim.notify("Copied file name: " .. content)
          end,
          copy_file_path = function(state)
            local node = state.tree:get_node()
            local content = node.path
            vim.fn.setreg('"', content)
            vim.fn.setreg("1", content)
            vim.fn.setreg("+", content)
            vim.notify("Copied absolute file path: " .. content)
          end,
          copy_relative_file_path = function(state)
            local node = state.tree:get_node()
            local content = vim.fs.relpath(state.path, node.path) or node.path
            vim.fn.setreg('"', content)
            vim.fn.setreg("1", content)
            vim.fn.setreg("+", content)
            vim.notify("Copied relative file path: " .. content)
          end,
        },
      },
      event_handlers = {
        {
          event = "neo_tree_popup_input_ready",
          handler = function()
            -- enter input popup with normal mode by default.
            vim.cmd("stopinsert")
          end,
        },
        {
          event = "neo_tree_popup_input_ready",
          ---@param args { bufnr: integer, winid: integer }
          handler = function(args)
            -- map <esc> to enter normal mode (by default closes prompt)
            -- don't forget `opts.buffer` to specify the buffer of the popup.
            vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
          end,
        },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    version = "*",
    event = "VeryLazy",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { "<leader>fo", "<CMD>Oil --float .<CR>", desc = "Open Oil for the project" },
      { "<leader>fO", "<CMD>Oil --float<CR>", desc = "Open Oil for the current file path" },
    },
  },

  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "g?",
      },
    },
    keys = {
      {
        "<leader>fzZ",
        mode = { "n", "v" },
        "<CMD>Yazi<CR>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>fzz",
        "<CMD>Yazi cwd<CR>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>fzt",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
  },
}
