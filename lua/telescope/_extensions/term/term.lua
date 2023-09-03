local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_set = require "telescope.actions.set"
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

local term = {}


local function term_select(prompt_buffer, cmd)
  local selection = action_state.get_selected_entry()
  local shell_option=0x0
  if not selection then
    return
  end
    if cmd == "default" then
        shell_option = 0x0
    elseif cmd == "horizontal" then
        shell_option = 0x1
    elseif cmd == "vertical"  then
        shell_option = 0x2
    elseif cmd == "tab"  then
        shell_option = 0x4
    else
        shell_option = 0x0
    end

  actions.close(prompt_buffer)
  vim.fn['te#terminal#open_term']({opener=shell_option, bufnr=selection.value})
  --vim.api.nvim_eval("timer_start(100, {->execute('doautocmd BufEnter')})")
end


local search_displayer = entry_display.create {
  separator = " ",
  items = {
    { width = 11 },
    { remaining = true },
  },
}

local make_term_display = function(entry)
  return search_displayer {
    { entry.bufnr or "", "TelescopeTermBufNumber" },
    { (entry.name or ""), "TelescopeTermBufName" },
  }
end

term.search = function(opts)
  opts = opts or {}
  local bufnrs = vim.fn['te#terminal#get_buf_list']()

  table.sort(bufnrs, function(a, b)
    return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
  end)

  for i, v in ipairs(bufnrs) do
    local bufnr = v
    local name = vim.fn['te#terminal#get_title'](bufnr)
    bufnrs[i] = { bufnr = bufnr, name = name }
  end
  pickers.new(opts, {
    prompt_title = "Select Terminal",
    finder = finders.new_table {
      results = bufnrs,
      entry_maker = function(entry)
        entry.value = entry.bufnr
        entry.ordinal = entry.name
        entry.display = make_term_display
        return entry
      end
    },
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      action_set.select:replace(term_select)
      return true
    end,
  }):find()
end

return term
