-- ============================================================
-- Bootstrap lazy.nvim
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- Plugins
-- ============================================================
require("lazy").setup({
	require("plugins.treesitter"),
	require("plugins.mason"),
	require("plugins.lspconfig"),
	require("plugins.blink"),
	require("plugins.which-key"),
	require("plugins.snacks"),
	require("plugins.neotree"),
	require("plugins.neogit"),
	require("plugins.gitsigns"),
	require("plugins.statusline"),
	require("plugins.autopairs"),
	require("plugins.conform"),
	require("plugins.colorscheme"),
	require("plugins.flash"),
	require("plugins.cdbg"),
}, {
	ui = { border = "rounded" },
})
