local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local feat = {}


local function feat_select(prompt_buffer)
    local selection = action_state.get_selected_entry()
    if not selection then
        return
    end

    actions.close(prompt_buffer)
    vim.fn['te#feat#feature_enable'](1, selection.value)
end

feat.search = function(opts)
    opts = opts or {}
    local src_list = vim.fn['keys'](vim.fn['te#feat#get_feature_dict']())
    src_list[#src_list+1] = 'all'

    pickers.new(opts, {
        prompt_title = "Select Feature",
        finder = finders.new_table {
            results = src_list,
            entry_maker = function(entry)
                return {
                    value = entry,
                    ordinal = entry,
                    display = entry,
                }
            end
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(feat_select)
            return true
        end,
    }):find()
end

return feat
