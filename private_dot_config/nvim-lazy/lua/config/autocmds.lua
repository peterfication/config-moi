-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Trim whitespace on save using mini.trailspace because I don't want to fully format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  pattern = "*",
  callback = function()
    vim.cmd('silent! lua require("mini.trailspace").trim()')
    vim.cmd('silent! lua require("mini.trailspace").trim_last_lines()')
  end,
})
