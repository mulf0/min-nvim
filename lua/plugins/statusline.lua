-- Statusline
return {
	"echasnovski/mini.statusline",
	version = "*",
	config = function()
		require("mini.statusline").setup({
			content = {
				active = function()
					local section_filename = function()
						local name = vim.api.nvim_buf_get_name(0)
						if name == "" then return "File: [No Name]" end
						local short = vim.fn.fnamemodify(name, ":.")
						if short == "" then short = vim.fn.fnamemodify(name, ":~") end
						return "File: " .. short .. "%m%r"
					end

					local mode = MiniStatusline.section_mode({ trunc_width = 0 })
					local git = MiniStatusline.section_git({ trunc_width = 40, icon = "Git:" })
					local filename = section_filename()

					return MiniStatusline.combine_groups({
						{ strings = { mode } },
						"",
						{ hl = "MiniStatuslineDevinfo", strings = { git } },
						"",
						{ strings = { filename } },
						"%=",
					})
				end,
			},
		})
	end,
}
