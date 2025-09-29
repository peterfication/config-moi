return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- NOTE: This is implementing the same functionality as neoconf.nvim but
      -- but neoconf.nvim is not updated yet to the new vim.lsp.config
      -- See https://github.com/folke/neoconf.nvim/issues/116

      -- Check for a project specific file
      local project_root = vim.fn.getcwd()
      local file_path = project_root .. "/.neoconf.json"
      local file = io.open(file_path, "r")
      if not file then
        return opts
      end

      local content = file:read("*all")
      file:close()
      local json = vim.fn.json_decode(content)

      -- merge json into opts.servers
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, json.lspconfig.servers or {})

      return opts
    end,
  },
}
