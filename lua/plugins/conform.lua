-- Conform (formatting)
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format buffer",
		},
	},
	config = function()
		local function has_prettier_config()
			local prettier_files = {
				".prettierrc",
				".prettierrc.json",
				".prettierrc.yml",
				".prettierrc.yaml",
				".prettierrc.json5",
				".prettierrc.js",
				".prettierrc.cjs",
				".prettierrc.mjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"prettier.config.mjs",
			}
			local root = vim.fn.getcwd()
			for _, file in ipairs(prettier_files) do
				if vim.uv.fs_stat(root .. "/" .. file) then
					return true
				end
			end
			local pkg_path = root .. "/package.json"
			if vim.uv.fs_stat(pkg_path) then
				local content = vim.fn.readfile(pkg_path)
				if table.concat(content, "\n"):match('"prettier"') then
					return true
				end
			end
			return false
		end

		local function biome_or_prettier()
			return has_prettier_config() and { "prettier" } or { "biome" }
		end

		require("conform").setup({
			formatters_by_ft = {
				javascript = biome_or_prettier,
				javascriptreact = biome_or_prettier,
				typescript = biome_or_prettier,
				typescriptreact = biome_or_prettier,
				json = biome_or_prettier,
				jsonc = biome_or_prettier,
				css = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
				lua = { "stylua", lsp_format = "fallback" },
				go = { "gofmt" },
				solidity = { "forge_fmt", lsp_format = "never" },
				rust = { lsp_format = "fallback" },
				python = { "ruff_format", "ruff_organize_imports" },
				c = { lsp_format = "fallback" },
				cpp = { lsp_format = "fallback" },
				["_"] = { lsp_format = "fallback" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
