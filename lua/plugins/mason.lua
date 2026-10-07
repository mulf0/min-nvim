-- Mason — server + tool installation
return {
	{ "mason-org/mason.nvim", opts = {} },
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP servers (mason package names)
				"lua-language-server",
				"typescript-language-server",
				"ty",
				"astro-language-server",
				"clangd",
				"rust-analyzer",
				-- Formatters / linters
				"stylua",
				"ruff",
				"prettier",
				"biome",
			},
		},
	},
}
