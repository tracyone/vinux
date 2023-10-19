
local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- mark operation
	local mark_move_j = function()
		api.marks.toggle()
		vim.cmd("norm j")
	end
	local mark_move_k = function()
		api.marks.toggle()
		vim.cmd("norm k")
	end

	-- marked files operation
	local mark_trash = function()
		local marks = api.marks.list()
		if #marks == 0 then
			table.insert(marks, api.tree.get_node_under_cursor())
		end
		vim.ui.input({ prompt = string.format("Trash %s files? [y/n] ", #marks) }, function(input)
			if input == "y" then
				for _, node in ipairs(marks) do
					api.fs.trash(node)
				end
				api.marks.clear()
				api.tree.reload()
			end
		end)
	end
	local mark_remove = function()
		local marks = api.marks.list()
		if #marks == 0 then
			table.insert(marks, api.tree.get_node_under_cursor())
		end
		vim.ui.input({ prompt = string.format("Remove/Delete %s files? [y/n] ", #marks) }, function(input)
			if input == "y" then
				for _, node in ipairs(marks) do
					api.fs.remove(node)
				end
				api.marks.clear()
				api.tree.reload()
			end
		end)
	end

	local mark_copy = function()
		local marks = api.marks.list()
		if #marks == 0 then
			table.insert(marks, api.tree.get_node_under_cursor())
		end
		for _, node in pairs(marks) do
			api.fs.copy.node(node)
		end
		api.marks.clear()
		api.tree.reload()
	end
	local mark_cut = function()
		local marks = api.marks.list()
		if #marks == 0 then
			table.insert(marks, api.tree.get_node_under_cursor())
		end
		for _, node in pairs(marks) do
			api.fs.cut(node)
		end
		api.marks.clear()
		api.tree.reload()
	end
	local mark_tab = function()
		local marks = api.marks.list()
		if #marks == 0 then
			table.insert(marks, api.tree.get_node_under_cursor())
		end
		for _, node in pairs(marks) do
            api.node.open.tab(node)
		end
		api.marks.clear()
		api.tree.reload()
	end
    -- open tab silently
	local function open_tab_silent(node)
		local api = require("nvim-tree.api")

		api.node.open.tab(node)
		vim.cmd.tabprev()
	end
	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
    vim.keymap.set("n", "l", api.node.open.edit, opts("Edit Or Open"))
    vim.keymap.set("n", "J", mark_move_j, opts("Toggle Bookmark Down"))
    vim.keymap.set("n", "K", mark_move_k, opts("Toggle Bookmark Up"))
	vim.keymap.set("n", "m", mark_cut, opts("Cut File(s)"))
	vim.keymap.set("n", "df", mark_trash, opts("Trash File(s)"))
	vim.keymap.set("n", "dd", mark_remove, opts("Remove File(s)"))
	vim.keymap.set("n", "yy", mark_copy, opts("Copy File(s)"))
    vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
	vim.keymap.set("n", "t", mark_tab, opts("Open: New Tab"))
	vim.keymap.set("n", "<c-t>", mark_tab, opts("Open: New Tab"))
    vim.keymap.set('n', 'T', open_tab_silent, opts('Open Tab Silent'))

	vim.keymap.set("n", "mv", api.marks.bulk.move, opts("Move Bookmarked"))
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "N", api.fs.create, opts("Create"))
	vim.keymap.set("n", "B", api.marks.toggle, opts("Toggle Bookmark"))
end

-- pass to setup along with your other options
require("nvim-tree").setup {
    disable_netrw = false,
    on_attach = my_on_attach,
}
return module
