-- Statusline
return {
	"echasnovski/mini.statusline",
	version = "*",
	config = function()
		require("mini.statusline").setup({
			content = {
				active = function()
					local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
					local git = MiniStatusline.section_git({ trunc_width = 40 })
					local filename = MiniStatusline.section_filename({ trunc_width = 140 })

					return MiniStatusline.combine_groups({
						{ hl = mode_hl, strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { git } },
						{ hl = "MiniStatuslineFilename", strings = { filename } },
						"%=",
					})
				end,
			},
		})
	end,
}
