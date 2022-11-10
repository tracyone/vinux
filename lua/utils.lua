module = {}

local function get_size(tabl)
    local size = 0
    for _ in pairs(tabl) do size = size + 1 end
    return size
end

function module.is_lsp_running()
    local current_buf = vim.api.nvim_get_current_buf()
    local client_obj = vim.lsp.get_active_clients{ buffer = current_buf }
    return get_size(client_obj)
end

function module.get_client_name()
    local current_buf = vim.api.nvim_get_current_buf()
    local client_obj = vim.lsp.get_active_clients{ buffer = current_buf }

    for _, client in pairs(client_obj) do
        return string.format("%s", client.name)
    end
    return string.format("0")
end

return module
