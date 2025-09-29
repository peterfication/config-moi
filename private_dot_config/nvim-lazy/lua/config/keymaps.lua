-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

map("n", "<Leader><ESC>", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })
map("n", "<Leader>w", ":w<CR>", { silent = true, desc = "Save current buffer" })

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
