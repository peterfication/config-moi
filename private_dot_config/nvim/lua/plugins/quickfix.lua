return {
  {
    "quickfix-format",
    virtual = true,
    event = "VeryLazy",
    config = function()
      function _G.qftf(info)
        local items
        local result = {}

        if info.quickfix == 1 then
          items = vim.fn.getqflist({ id = info.id, items = 0 }).items
        else
          items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
        end

        local filename_limit = 31
        local short_filename = "%-" .. filename_limit .. "s"
        local truncated_filename = "…%." .. (filename_limit - 1) .. "s"
        local item_format = "%s │%5d:%-3d│%s %s"

        for i = info.start_idx, info.end_idx do
          local item = items[i]
          local line

          if item.valid == 1 then
            local filename = ""

            if item.bufnr > 0 then
              filename = vim.fn.bufname(item.bufnr)
              if filename == "" then
                filename = "[No Name]"
              else
                filename = filename:gsub("^" .. vim.pesc(vim.env.HOME), "~")
              end

              if #filename <= filename_limit then
                filename = short_filename:format(filename)
              else
                filename = truncated_filename:format(filename:sub(1 - filename_limit))
              end
            end

            local lnum = item.lnum > 99999 and -1 or item.lnum
            local col = item.col > 999 and -1 or item.col
            local item_type = item.type == "" and "" or " " .. item.type:sub(1, 1):upper()
            line = item_format:format(filename, lnum, col, item_type, item.text)
          else
            line = item.text
          end

          table.insert(result, line)
        end

        return result
      end

      vim.o.quickfixtextfunc = "{info -> v:lua._G.qftf(info)}"
    end,
  },

  {
    -- Better quickfix features
    -- - Some styling
    -- - Preview (zp: maximize)
    -- - Filtering with <Tab> and zn/N
    "kevinhwang91/nvim-bqf",
    -- priority = 1001,
    event = "VeryLazy",
    init = function()
      local group = vim.api.nvim_create_augroup("bqf_localleader", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "qf",
        callback = function(event)
          local function alias(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = event.buf,
              remap = true,
              desc = desc,
            })
          end

          -- Add localleader mappings for discoverability
          alias("n", "<localleader>n", "zn", "Filter selected items")
          alias("n", "<localleader>N", "zN", "Filter unselected items")
          alias("n", "<localleader>p", "zp", "Toggle preview mode")
          alias({ "n", "x" }, "<localleader><Tab>", "<Tab>", "Toggle selection")
        end,
      })
    end,
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    opts = {
      filters = {
        enabled = function(item)
          local diagnostic = item.item
          if not item.buf or not diagnostic.namespace then
            return true
          end

          return vim.diagnostic.is_enabled({
            bufnr = item.buf,
            ns_id = diagnostic.namespace,
          })
        end,
      },
      modes = {
        diagnostics = {
          filter = { enabled = true },
        },
      },
      win = {
        wo = {
          wrap = true,
        },
      },
    },

    keys = {
      -- {
      --   "<C-h>",
      --   ":cprevious<CR>",
      --   desc = "Previous quickfix item",
      -- },
      -- {
      --   "<C-l>",
      --   ":cnext<CR>",
      --   desc = "Next quickfix item",
      -- },

      -- <leader>cs is used by aerial
      { "<leader>cz", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },

      { "<Leader>xf", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics (Telescope)" },
      { "<Leader>xF", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Buffer diagnostics (Telescope)" },

      {
        "<Leader>xq",
        function()
          local winid = vim.fn.getqflist({ winid = 0 }).winid

          if winid ~= 0 then
            vim.cmd.cclose()
          else
            vim.cmd.copen()
          end
        end,
        desc = "Quickfix list",
      },

      {
        "<Leader>xsx",
        "<CMD>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<CR>",
        desc = "Toggle diagnostics ERROR",
      },
      {
        "<Leader>xsw",
        "<CMD>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.WARN<CR>",
        desc = "Toggle diagnostics WARN",
      },
      {
        "<Leader>xsi",
        "<CMD>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.INFO<CR>",
        desc = "Toggle diagnostics INFO",
      },

      {
        "<Leader>xSx",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<CR>",
        desc = "Toggle document diagnostics ERROR",
      },
      {
        "<Leader>xSw",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.WARN<CR>",
        desc = "Toggle document diagnostics WARN",
      },
      {
        "<Leader>xSi",
        "<CMD>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.INFO<CR>",
        desc = "Toggle document diagnostics INFO",
      },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false })

      -- This is needed because other plugins that lazy load later might overwrite it.
      Snacks.util.lsp.on(function(_client, _buffer)
        vim.diagnostic.config({ virtual_text = false })
      end)
    end,
  },
}
