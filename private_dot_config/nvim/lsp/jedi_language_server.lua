return {
  before_init = function(_, config)
    local match = vim.fn.glob(path.join(config.root_dir, "poetry.lock"))
    if match ~= "" then
      local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
      vim.env.VIRTUAL_ENV = venv

      python_path = path.join(venv, "bin", "python")
      config.cmd = { python_path, "-m", "jedi_language_server" }
      config.init_options = {
        extra_paths = {
          path.join(venv, "lib", "python3.12", "site-packages"),
        },
      }
    end
  end,
}
