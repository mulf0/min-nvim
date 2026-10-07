-- Which-key
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		spec = {
			{ "<leader>s", group = "Search" },
			{ "<leader>h", group = "Hunk" },
			{ "<leader>g", group = "Git" },
			{ "<leader>w", group = "Workspace" },
			{ "<leader>t", group = "Toggle" },
			{ "g", group = "Goto" },
			{ "gr", group = "LSP" },
		},
	},
}
