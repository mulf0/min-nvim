-- Modern Neovim 0.11 Config
-- snacks.nvim for UI, native LSP with lsp/ directory pattern

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.breakindent = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.autoread = true

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Auto-reload files changed outside neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = vim.api.nvim_create_augroup("auto-reload", { clear = true }),
	command = "silent! checktime",
})

-- Basic keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus up" })
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("i", "<C-s>", "<cmd>w<cr>")
vim.keymap.set("n", "<C-q>", "<cmd>q<cr>")

-- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Diagnostics config
vim.diagnostic.config({
	virtual_text = { current_line = true },
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
})

-- ============================================================
-- LSP attach — extend 0.11 defaults with Snacks pickers
-- ============================================================
-- Neovim 0.11 ships these globally: grn (rename), gra (code action),
-- Ctrl-S (sig help in insert). We override K, grr, gri, grt, gO
-- with bordered/picker versions and add gd/gD/<leader>ws.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		local buf = event.buf

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = buf, desc = desc })
		end

		-- Hover and signature help with borders
		map("K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, "Hover")
		vim.keymap.set("i", "<C-s>", function()
			vim.lsp.buf.signature_help({ border = "rounded" })
		end, { buffer = buf, desc = "Signature help" })

		-- Definition
		map("gd", function()
			Snacks.picker.lsp_definitions()
		end, "Goto definition")
		map("gD", vim.lsp.buf.declaration, "Goto declaration")

		-- Override 0.11 defaults with Snacks picker versions
		map("grr", function()
			Snacks.picker.lsp_references()
		end, "References")
		map("gri", function()
			Snacks.picker.lsp_implementations()
		end, "Implementation")
		map("grt", function()
			Snacks.picker.lsp_type_definitions()
		end, "Type definition")
		map("gO", function()
			Snacks.picker.lsp_symbols()
		end, "Document symbols")

		-- Workspace symbols
		map("<leader>ws", function()
			Snacks.picker.lsp_workspace_symbols()
		end, "Workspace symbols")

		-- Document highlight on cursor hold
		if client and client:supports_method("textDocument/documentHighlight") then
			local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = buf,
				group = hl_group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = buf,
				group = hl_group,
				callback = vim.lsp.buf.clear_references,
			})
		end

		-- Inlay hints toggle
		if client and client:supports_method("textDocument/inlayHint") then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
			end, "Toggle inlay hints")
		end
	end,
})

-- Simple statusline
vim.o.cmdheight = 0

-- ============================================================
-- LSP servers — enable via lsp/ directory pattern
-- ============================================================
vim.lsp.enable({ "lua_ls", "ts_ls", "pyright", "clangd" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- Plugins
require("lazy").setup({
	-- Treesitter
	{
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
	},

	-- Mason (server + tool installer)
	{ "mason-org/mason.nvim", opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = { "lua_ls", "ts_ls", "pyright", "clangd" },
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"ruff",
				"prettier",
				"biome",
			},
		},
	},

	-- nvim-lspconfig (data-only: provides default lsp/ configs)
	{ "neovim/nvim-lspconfig" },

	-- Completion
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "enter" },
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				menu = { border = "rounded", scrollbar = false },
			},
			signature = {
				enabled = true,
				window = { border = "rounded" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	-- Which-key
	{
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
	},

	-- Snacks.nvim — UI (picker, explorer, input, notifier, lazygit)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			explorer = { enabled = true, replace_netrw = true },
			indent = { enabled = false },
			input = { enabled = true },
			lazygit = {
				enabled = true,
				win = { border = "rounded" },
			},
			notifier = { enabled = true, timeout = 3000 },
			picker = {
				enabled = true,
				sources = {
					explorer = {
						auto_close = true,
					},
				},
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			words = { enabled = true },
		},
		keys = {
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
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
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
				"<C-e>",
				function()
					Snacks.explorer()
				end,
				desc = "File explorer",
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
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
	},

	-- Gitsigns
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(buf)
				local gs = require("gitsigns")
				vim.keymap.set("n", "]c", gs.next_hunk, { buffer = buf, desc = "Next hunk" })
				vim.keymap.set("n", "[c", gs.prev_hunk, { buffer = buf, desc = "Prev hunk" })
				vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = buf, desc = "Stage hunk" })
				vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = buf, desc = "Reset hunk" })
				vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = buf, desc = "Preview hunk" })
				vim.keymap.set("n", "<leader>hb", gs.blame_line, { buffer = buf, desc = "Blame line" })
			end,
		},
	},
	{
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
	},

	-- Autopairs
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

	-- Conform (formatting)
	{
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
				if has_prettier_config() then
					return { "prettier" }
				end
				return { "biome" }
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
	},

	-- Colorscheme
	{
		"vague-theme/vague.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vague").setup({
				on_highlights = function(hl, colors)
					hl.FloatBorder = { fg = colors.floatBorder }
					hl.MiniStatuslineFilename = { fg = colors.fg, bg = colors.line }
					hl.MiniStatuslineDevinfo = { fg = colors.fg, bg = colors.line }
					hl.MiniStatuslineInactive = { fg = colors.comment, bg = colors.line }
				end,
			})
			vim.cmd("colorscheme vague")
		end,
	},
}, {
	ui = {
		border = "rounded",
	},
})
