return {
  {
    "s1n7ax/nvim-window-picker",
    event = "VeryLazy",
    version = "2.*",
    opts = {
      hint = "floating-big-letter",
      show_prompt = false,

      filter_func = function(window_ids, _filters)
        -- Filter out floating windows (e.g. Telescope preview)
        -- The Telescope preview can't be targeted by a certain filetype because it's
        -- just a normal buffer.
        local filtered_window_ids = {}
        for _, window_id in ipairs(window_ids) do
          local is_floating = vim.api.nvim_win_get_config(window_id).relative ~= ""
          if not is_floating then
            table.insert(filtered_window_ids, window_id)
          end
        end

        return filtered_window_ids
      end,

      filter_rules = {
        bo = {
          filetype = {
            "TelescopePrompt",
            "TelescopeResults",
            "NvimTree",
            "neo-tree",
            "notify",
            "snacks_notif",
          },
        },
      },
    },
  },
}
