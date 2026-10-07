-- Treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		require("nvim-treesitter")
			.install({
				"bash",
				"c",
				"cpp",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
				"go",
				"rust",
				"typescript",
				"javascript",
				"python",
				"solidity",
			})
			:wait(300000)
	end,
	config = function()
		require("nvim-treesitter").setup({})
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				if pcall(vim.treesitter.start) then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
