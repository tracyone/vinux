local builtin = require('telescope.builtin')

if vim.call('te#env#Executable', 'rg') == 1 then
    vim.keymap.set('n', '<leader><leader>', function()
        builtin.find_files({find_command={ "rg", "--files", "--hidden", "-g", "!.git" }})
    end, {})
    vim.keymap.set('n', '<leader>pf', builtin.live_grep, {})
else
    vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
end

vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<c-j>', builtin.buffers, {})
vim.keymap.set('n', '<leader>hv', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pm', builtin.oldfiles, {})
vim.keymap.set('n', '<c-l>', builtin.oldfiles, {})
vim.keymap.set('n', '<c-k>', builtin.treesitter, {})
vim.keymap.set('n', '<leader>qc', builtin.command_history, {})
vim.keymap.set('n', '<leader>q/', builtin.search_history, {})
vim.keymap.set('n', '<leader>pc', builtin.colorscheme, {})
vim.keymap.set('n', '<leader>pr', builtin.registers, {})
vim.keymap.set('n', '<leader>ff', ":Telescope file_browser<CR>", {})

local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
--local trouble = require("trouble.providers.telescope")
--
local actions = require("telescope.actions")
local transform_mod = require("telescope.actions.mt").transform_mod
local action_state = require('telescope.actions.state')

local function multiopen(prompt_bufnr, method)
    local cmd_map = {
        vertical = "vsplit",
        horizontal = "split",
        tab = "tabe",
        default = "edit"
    }
    local picker = action_state.get_current_picker(prompt_bufnr)
    local multi_selection = picker:get_multi_selection()

    if #multi_selection > 1 then
        require("telescope.pickers").on_close_prompt(prompt_bufnr)
        pcall(vim.api.nvim_set_current_win, picker.original_win_id)

        for i, entry in ipairs(multi_selection) do
            -- opinionated use-case
            local cmd = i == 1 and "edit" or cmd_map[method]
            vim.cmd(string.format("%s %s", cmd, entry.value))
        end
    else
        actions["select_" .. method](prompt_bufnr)
    end
end

local custom_actions = transform_mod({
    multi_selection_open_vertical = function(prompt_bufnr)
        multiopen(prompt_bufnr, "vertical")
    end,
    multi_selection_open_horizontal = function(prompt_bufnr)
        multiopen(prompt_bufnr, "horizontal")
    end,
    multi_selection_open_tab = function(prompt_bufnr)
        multiopen(prompt_bufnr, "tab")
    end,
    multi_selection_open = function(prompt_bufnr)
        multiopen(prompt_bufnr, "default")
    end,
})

local function stopinsert(callback)
    return function(prompt_bufnr)
        vim.cmd("stopinsert")
        vim.schedule(function()
            callback(prompt_bufnr)
        end)
    end
end

local mappings = {
  -- Insert mode
  i = {
    -- No normal mode
    ["<C-c>"] = actions.close,

    -- Clear prompt instead of scroll up
    ["<C-u>"] = false,

    -- Preview
    ["?"] = actions_layout.toggle_preview,
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-p>"] = actions.preview_scrolling_up,
    ["<C-n>"] = actions.preview_scrolling_down,

    -- Scrolling
    ["<C-b>"] = actions.results_scrolling_up,
    ["<C-f>"] = actions.results_scrolling_down,

    -- Split open
    -- By convention <C-s> are used for horizontal splitting
    ["<C-v>"] = stopinsert(custom_actions.multi_selection_open_vertical),
    ["<C-x>"] = stopinsert(custom_actions.multi_selection_open_horizontal),
    ["<C-t>"] = stopinsert(custom_actions.multi_selection_open_tab),
    ["<cr>"]  = stopinsert(custom_actions.multi_selection_open)

    --["<C-x>"] = trouble.open_with_trouble,
    --["<C-q>"] = trouble.smart_send_to_qflist,
  },

  -- Normal mode
  n = {
    ["q"] = actions.close,
  },
}

-- 〉

-- Setup 〈
local defaults = {
    -- UI
    selection_caret = "❯ ",
    -- prompt_prefix = " ",
    --selection_caret = " ",
    --prompt_prefix = " ",
    multi_icon = "│",

    -- Layout
    --sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
        prompt_position = "bottom",
    },

    file_ignore_patterns = { ".git/", ".cache", "build/", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip", "tags", "cscope.*", "GTAGS" },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

    mappings = mappings,

    vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- trim indentations
    },
}

require("telescope").setup {
  defaults = defaults,
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
    fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
    },
    file_browser = {
        dir_icon = "+",
        theme = "ivy",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = {
            ["i"] = {
                -- your custom insert mode mappings
            },
            ["n"] = {
                -- your custom normal mode mappings
            },
        },
    },
    },

  pickers = { hidden = true },
}

require('telescope').load_extension('fzf')
require("telescope").load_extension("file_browser")
