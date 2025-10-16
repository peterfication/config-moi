return {
  root_dir = function(fname)
    return nvim_lsp.util.root_pattern(".git")(fname) or util.path.dirname(fname)
  end,
  before_init = function(_, config)
    local match = vim.fn.glob(path.join(config.root_dir, "poetry.lock"))
    if match ~= "" then
      local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
      vim.env.VIRTUAL_ENV = venv
      config.cmd = { path.join(venv, "bin", "pylsp") }
      config.init_options = {
        extra_paths = {
          path.join(venv, "lib", "python3.12", "site-packages"),
        },
      }
    end
  end,
}
