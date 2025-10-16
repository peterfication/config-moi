-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.g.lazyvim_picker = "telescope"

vim.opt.listchars = {
  trail = "¤",
  nbsp = "·",
  extends = ">",
  precedes = "<",
  space = "·",
  eol = "↵",
  tab = "│─",
}

vim.wo.relativenumber = false

-- LazyVim auto format
vim.g.autoformat = false
