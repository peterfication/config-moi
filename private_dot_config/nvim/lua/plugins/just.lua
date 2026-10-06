local JUSTFILE_NAMES = { "justfile", "Justfile", ".justfile" }
local TASK_TERMINAL_ID = 9

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Just" })
end

local function find_justfile()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  local start_path = buffer_path ~= "" and vim.fs.dirname(buffer_path) or vim.fn.getcwd()

  return vim.fs.find(JUSTFILE_NAMES, {
    path = start_path,
    upward = true,
    type = "file",
  })[1]
end

local function parameter_is_required(parameter)
  return (parameter.default == nil or parameter.default == vim.NIL) and parameter.kind ~= "star"
end

local function format_parameter(parameter)
  local prefix = ({ plus = "+", star = "*" })[parameter.kind] or ""
  local formatted = prefix .. parameter.name

  if parameter.default ~= nil and parameter.default ~= vim.NIL then
    formatted = formatted .. "=" .. tostring(parameter.default)
  end

  return formatted
end

local function recipe_group(recipe)
  for _, attribute in ipairs(recipe.attributes or {}) do
    if type(attribute.group) == "string" then
      return attribute.group
    end
  end
end

local function collect_recipes(module, recipes)
  for name, recipe in pairs(module.recipes or {}) do
    if not recipe.private then
      local parameters = recipe.parameters or {}
      local signature = recipe.namepath or name

      if #parameters > 0 then
        signature = signature .. " " .. table.concat(vim.tbl_map(format_parameter, parameters), " ")
      end

      recipes[#recipes + 1] = {
        name = recipe.namepath or name,
        signature = signature,
        doc = type(recipe.doc) == "string" and recipe.doc or nil,
        group = recipe_group(recipe),
        needs_arguments = vim.iter(parameters):any(parameter_is_required),
      }
    end
  end

  for _, child_module in pairs(module.modules or {}) do
    collect_recipes(child_module, recipes)
  end
end

local function get_task_terminal()
  local toggleterm_terminal = require("toggleterm.terminal")
  return toggleterm_terminal.get(TASK_TERMINAL_ID, true)
    or toggleterm_terminal.Terminal:new({
      count = TASK_TERMINAL_ID,
      direction = "float",
      display_name = "just tasks",
    })
end

local function show_terminal(terminal)
  if terminal:is_open() then
    terminal:focus()
  else
    terminal:open()
  end
end

local function terminal_is_busy(terminal, callback)
  if not terminal.job_id then
    callback(false)
    return
  end

  local shell_pid = vim.fn.jobpid(terminal.job_id)
  if not shell_pid or shell_pid <= 0 then
    callback(false)
    return
  end

  vim.system(
    { "ps", "-o", "pgid=,tpgid=", "-p", tostring(shell_pid) },
    { text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        callback(nil)
        return
      end

      local process_group, foreground_process_group = (result.stdout or ""):match("^%s*(%-?%d+)%s+(%-?%d+)")
      if not process_group or not foreground_process_group then
        callback(nil)
        return
      end

      callback(tonumber(process_group) ~= tonumber(foreground_process_group))
    end)
  )
end

local function run_recipe(recipe, project_root)
  local terminal = get_task_terminal()

  terminal_is_busy(terminal, function(is_busy)
    show_terminal(terminal)

    if is_busy == nil then
      notify("Could not determine whether task terminal 9 is busy; command was not sent", vim.log.levels.WARN)
      return
    end

    if is_busy then
      notify("Task terminal 9 already has a running foreground process", vim.log.levels.WARN)
      return
    end

    local command = ("cd %s && just %s"):format(vim.fn.shellescape(project_root), vim.fn.shellescape(recipe.name))
    -- Clear any unsubmitted command without interrupting the idle shell.
    local input = "\021" .. command

    if recipe.needs_arguments then
      input = input .. " "
    else
      input = input .. terminal.newline_chr
    end

    vim.fn.chansend(terminal.job_id, input)
    terminal:scroll_bottom()

    if recipe.needs_arguments then
      notify("Enter arguments and press Return to run " .. recipe.name)
    end
  end)
end

local function format_recipe(recipe)
  local group = type(recipe.group) == "string" and ("[%s] "):format(recipe.group) or ""
  local doc = type(recipe.doc) == "string" and (" — " .. recipe.doc) or ""
  return group .. recipe.signature .. doc
end

local function select_recipe()
  local justfile = find_justfile()
  if not justfile then
    notify("No Justfile found for the current buffer", vim.log.levels.WARN)
    return
  end

  local project_root = vim.fs.dirname(justfile)
  vim.system(
    { "just", "--dump", "--dump-format", "json" },
    { cwd = project_root, text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        local error_message = vim.trim(result.stderr or "")
        notify(error_message ~= "" and error_message or "Could not read Justfile", vim.log.levels.ERROR)
        return
      end

      local ok, justfile_data = pcall(vim.json.decode, result.stdout)
      if not ok then
        notify("Could not decode Justfile metadata", vim.log.levels.ERROR)
        return
      end

      local recipes = {}
      collect_recipes(justfile_data, recipes)
      table.sort(recipes, function(left, right)
        return left.name < right.name
      end)

      if #recipes == 0 then
        notify("The Justfile has no public recipes", vim.log.levels.WARN)
        return
      end

      vim.ui.select(recipes, {
        prompt = "Just recipe",
        kind = "just_recipe",
        format_item = format_recipe,
      }, function(recipe)
        if recipe then
          run_recipe(recipe, project_root)
        end
      end)
    end)
  )
end

return {
  {
    "just-recipes",
    virtual = true,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "akinsho/toggleterm.nvim",
    },
    keys = {
      {
        "<Leader>jr",
        select_recipe,
        desc = "Run Just recipe",
      },
    },
  },
}
