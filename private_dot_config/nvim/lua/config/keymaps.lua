-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

map("n", "<Leader><ESC>", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

map("n", "<Leader>!", ":w<CR>", { silent = true, desc = "Save current buffer" })

map("n", "<Leader>!", ":tabclose<CR>", { desc = "Close current tab" })
map("n", "<Leader>1", "1gt", { desc = "Go to tab 1" })
map("n", "<Leader>2", "2gt", { desc = "Go to tab 2" })
map("n", "<Leader>3", "3gt", { desc = "Go to tab 3" })
map("n", "<Leader>4", "4gt", { desc = "Go to tab 4" })
map("n", "<Leader>5", "5gt", { desc = "Go to tab 5" })
map("n", "<Leader>6", "6gt", { desc = "Go to tab 6" })
map("n", "<Leader>7", "7gt", { desc = "Go to tab 7" })
map("n", "<Leader>8", "8gt", { desc = "Go to tab 8" })
map("n", "<Leader>9", "9gt", { desc = "Go to tab 9" })

map("n", "<Leader>bw", ":w<CR>", { silent = true, desc = "Safe/write current buffer" })
map("n", "<Leader>baw", ":noautocmd w<CR>", { silent = true, desc = "Write current buffer without autocmds" })
map("n", "<Leader>bW", ":wa<CR>", { silent = true, desc = "Safe/write all buffers" })
map("n", "<Leader>br", ":e<CR>", { silent = true, desc = "Refresh current buffer" })
map("n", "<Leader>bc", ":bufdo bd<CR>", { silent = true, desc = "Delete/clear all buffers" })
map("n", "<Leader>qA", ":qa!<CR>", { silent = true, desc = "Quit all without saving" })

-- File copying keymaps

-- File name of the current buffer
local function current_file_name()
  return vim.api.nvim_buf_get_name(0)
end

local function git_relative_path()
  local file = current_file_name()
  local root = LazyVim.root.git()
  return vim.fs.relpath(root, file) or file
end

local function copy(value, label)
  vim.fn.setreg("+", value)
  vim.notify("Copied " .. label)
end

map("n", "<Leader>fyy", function()
  local path = git_relative_path()
  copy(path, "Git-relative file path: " .. path)
end, { desc = "Yank Git-relative file path" })

map("n", "<Leader>fyn", function()
  local file_name = vim.fs.basename(current_file_name())
  copy(file_name, "file name: " .. file_name)
end, { desc = "Yank file name" })

map("n", "<Leader>fya", function()
  local agent_file_path = "@" .. git_relative_path()
  copy(agent_file_path, "agent file reference: " .. agent_file_path)
end, { desc = "Yank agent file reference" })

map("n", "<Leader>fyc", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local file_path = git_relative_path()
  copy(table.concat(lines, "\n"), "file contents of " .. file_path)
end, { desc = "Yank file contents" })
