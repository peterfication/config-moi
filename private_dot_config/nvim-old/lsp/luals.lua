return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT", -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      },
      diagnostics = {
        globals = {
          "vim",
          "describe",
          "it",
        },
      },
      workspace = {
        checkThirdParty = false,
        -- library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          "${3rd}/plenary.nvim/lua",
          "${3rd}/luassert/library",
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
      format = {
        enable = false,
        -- Put format options here
        -- NOTE: the value should be STRING!!
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
    },
  },
}
