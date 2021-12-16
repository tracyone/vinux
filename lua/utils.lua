module = {}

local function get_size(tabl)
    local size = 0
    for _ in pairs(tabl) do size = size + 1 end
    return size
end

function module.is_lsp_running()
    local client_obj = vim.lsp.buf_get_clients()
    return get_size(client_obj)
end

return module
