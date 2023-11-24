require('mason-nvim-dap').setup({
    ensure_installed = {'python', 'cppdbg', 'bash'},
    automatic_installation = true,
    automatic_setup = true,
    handlers = {},
})

local dap, dapui = require("dap"), require("dapui")

dapui.setup({})

require("nvim-dap-virtual-text").setup({
    enabled = true,
    enable_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    filter_references_pattern = '<module',
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set('n', '<leader>dt', function() dapui.toggle() end)

vim.keymap.set('n', '<leader>dc', function() 
vim.cmd([[language en_US.UTF-8]])
dap.continue()
end)

vim.keymap.set('n', '<leader>dl', function() dap.run_last() end)
vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>dr', function() dap.step_over() end)
vim.keymap.set('n', '<leader>do', function() dap.step_out() end)
vim.keymap.set('n', '<leader>di', function() dap.step_into() end)

vim.fn.sign_define("DapStopped", { text = vim.g.vinux_diagnostics_signs_warning, texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapBreakpoint", { text = vim.g.vinux_diagnostics_signs_info, texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapBreakpointRejected", { text = vim.g.vinux_diagnostics_signs_error, texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo" })

-- Catppuccin
local sign = vim.fn.sign_define

sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })


