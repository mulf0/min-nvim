return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		search = {
			multi_window = false, -- single buffer only
			wrap = true, -- search wraps around file
		},
		jump = {
			autojump = false, -- always require label selection
		},
		label = {
			uppercase = false, -- lowercase labels only, easier to type
			current = false, -- don't label current position
		},
		modes = {
			char = { enabled = false }, -- disable f/t enhancement, keep native
		},
	},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
	},
}
