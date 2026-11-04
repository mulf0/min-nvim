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
		local oxfmt_files = {
			".oxfmtrc.json",
			".oxfmtrc.jsonc",
			"oxfmt.config.ts",
			"oxfmt.config.mts",
		}
		local biome_files = {
			"biome.json",
			"biome.jsonc",
			".biome.json",
			".biome.jsonc",
		}

		local function has_file(dir, file)
			return vim.uv.fs_stat(vim.fs.joinpath(dir, file)) ~= nil
		end

		local function has_any(dir, files)
			for _, file in ipairs(files) do
				if has_file(dir, file) then
					return true
				end
			end
			return false
		end

		local function has_prettier_config(dir)
			if has_any(dir, prettier_files) then
				return true
			end
			local pkg_path = vim.fs.joinpath(dir, "package.json")
			if vim.uv.fs_stat(pkg_path) then
				local content = vim.fn.readfile(pkg_path)
				return table.concat(content, "\n"):match('"prettier"') ~= nil
			end
			return false
		end

		local function javascript_formatter(bufnr)
			local file = vim.api.nvim_buf_get_name(bufnr)
			local start = file ~= "" and vim.fn.fnamemodify(file, ":p") or vim.fn.getcwd() .. "/"
			for dir in vim.fs.parents(start) do
				if has_any(dir, oxfmt_files) then
					return { "oxfmt" }
				end
				if has_prettier_config(dir) then
					return { "prettier" }
				end
				if has_any(dir, biome_files) then
					return { "biome" }
				end
			end
			return { "biome" }
		end

		require("conform").setup({
			formatters_by_ft = {
				javascript = javascript_formatter,
				javascriptreact = javascript_formatter,
				typescript = javascript_formatter,
				typescriptreact = javascript_formatter,
				json = javascript_formatter,
				jsonc = javascript_formatter,
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
