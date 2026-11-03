-- Basic keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "vv", "v$", { desc = "Select to end of line" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus up" })
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("i", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("n", "<C-q>", "<cmd>q<cr>")

-- Copy file name and selected line range from visual mode.
vim.keymap.set("x", "<leader>y", function()
	local file = vim.fn.expand("%:~:.")
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")
	local range = start_line == end_line and tostring(start_line)
		or (start_line .. "-" .. end_line)
	vim.fn.setreg("+", file .. ":" .. range)

	-- Set the yank marks and fire TextYankPost so it flashes like a normal yank.
	vim.fn.setpos("'[", vim.fn.getpos("'<"))
	vim.fn.setpos("']", vim.fn.getpos("'>"))
	vim.api.nvim_exec_autocmds("TextYankPost", {
		data = { operator = "y", regtype = vim.fn.visualmode(), visual = true },
	})
end, { desc = "Copy file name and line range" })

-- Jump to tab N.
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, i .. "gt", { desc = "Go to tab " .. i })
end
