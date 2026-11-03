-- Use a single responsive picker layout. Wide screens show results and previews
-- side-by-side; narrower screens stack the preview below the results.
local snacks_picker_layout = {
	layout = function(source)
		if vim.o.columns >= 120 and source ~= "diagnostics" then
			return {
				preview = true,
				layout = {
					backdrop = false,
					width = 0.9,
					min_width = 120,
					height = 0.8,
					min_height = 20,
					box = "horizontal",
					{
						box = "vertical",
						border = true,
						title = "{title} {live} {flags}",
						title_pos = "center",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
					},
					{ win = "preview", title = "{preview}", border = true, width = 0.5 },
				},
			}
		end

		return {
			preview = true,
			layout = {
				backdrop = false,
				width = 0.6,
				min_width = 80,
				height = 0.9,
				min_height = 30,
				box = "vertical",
				border = true,
				title = "{title} {live} {flags}",
				title_pos = "center",
				{ win = "input", height = 1, border = "bottom" },
				{ win = "list", height = source == "diagnostics" and 0.25 or nil, border = "none" },
				{
					win = "preview",
					title = "{preview}",
					height = source ~= "diagnostics" and 0.4 or nil,
					border = "top",
				},
			},
		}
	end,
}

-- Snacks.nvim — UI (picker, explorer, input, notifier, lazygit)
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = true },
		lazygit = { enabled = true, win = { border = "rounded" } },
		notifier = { enabled = true, timeout = 3000 },
		picker = {
			enabled = true,
			layout = snacks_picker_layout.layout,
			sources = {
				files = { hidden = false, ignored = false },
				grep = { hidden = false, ignored = false },
			},
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		{
			"<leader>ra",
			function()
				local buf = vim.api.nvim_get_current_buf()
				Snacks.input({ prompt = "Find (literal, case-insensitive)" }, function(find)
					if not find or find == "" then
						return
					end
					Snacks.input({ prompt = "Replace with" }, function(replacement)
						if replacement == nil or not vim.api.nvim_buf_is_valid(buf) then
							return
						end
						local pattern = "\\V\\c" .. vim.fn.escape(find, "\\/")
						local text = vim.fn.escape(replacement, "\\/&~")
						local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
							vim.cmd("%smagic/" .. pattern .. "/" .. text .. "/g")
						end)
						if not ok then
							vim.notify(tostring(err), vim.log.levels.WARN)
						end
					end)
				end)
			end,
			desc = "Replace all in buffer",
		},
		{
			"<leader>sf",
			function()
				Snacks.picker.files()
			end,
			desc = "Search files",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Search grep",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Search buffers",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Search help",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.resume()
			end,
			desc = "Search resume",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.lines()
			end,
			desc = "Search in buffer",
		},
		{
			"<leader><leader>",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>q",
			function()
				vim.diagnostic.setqflist({ open = true })
			end,
			desc = "Diagnostics (quickfix)",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Search keymaps",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command history",
		},
		{
			"<leader>sn",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification history",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git status",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git log",
		},
	},
}
