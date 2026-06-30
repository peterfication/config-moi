std = "lua54"
max_line_length = 120

exclude_files = {
  "private_dot_config/hammerspoon/Spoons/**",
}

globals = {
  "vim",
  "hs",
  "spoon",
  "Snacks",
  "LazyVim",
  "ya",
}

files["private_dot_config/hammerspoon/hyper_space.lua"] = {
  ignore = { "212/self" },
}
