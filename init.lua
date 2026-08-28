-- Neovim 0.12 Config
-- snacks.nvim for UI, native LSP with lsp/ directory pattern

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Options
vim.o.number = true
vim.o.relativenumber = false
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
vim.o.cmdheight = 0

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

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
	virtual_text = false,
	severity_sort = true,
	float = false,
	underline = false,
	signs = false,
})

-- ============================================================
-- LSP attach — extend 0.12 defaults with Snacks pickers
-- ============================================================
-- 0.11+ defaults: grn (rename), gra (code action), grr (references),
-- gri (implementation), gO (document symbols), K (hover), <C-S> (sig help)
-- 0.12 adds: grt (type definition), grx (codelens run)
-- We override gd/gD/grr/gri/grt/gO with Snacks picker versions.
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

		-- Override 0.11/0.12 defaults with Snacks picker versions
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

-- ============================================================
-- LSP servers — enabled via lsp/ directory pattern
-- ============================================================
vim.lsp.enable({ "lua_ls", "ts_ls", "ty", "astro", "clangd", "rust_analyzer", "gopls", "goimports" })

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
-- Use a single responsive picker layout. Wide screens show results and previews
-- side-by-side; narrower screens stack the preview below the results.
local snacks_picker_layout = {
	layout = function(source)
		if vim.o.columns >= 120 and source ~= "diagnostics" then
			return {
				preview = true,
				layout = {
					backdrop = false,
					width = 0.9,
					min_width = 120,
					height = 0.8,
					min_height = 20,
					box = "horizontal",
					{
						box = "vertical",
						border = true,
						title = "{title} {live} {flags}",
						title_pos = "center",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
					},
					{ win = "preview", title = "{preview}", border = true, width = 0.5 },
				},
			}
		end

		return {
			preview = true,
			layout = {
				backdrop = false,
				width = 0.6,
				min_width = 80,
				height = 0.9,
				min_height = 30,
				box = "vertical",
				border = true,
				title = "{title} {live} {flags}",
				title_pos = "center",
				{ win = "input", height = 1, border = "bottom" },
				{ win = "list", height = source == "diagnostics" and 0.25 or nil, border = "none" },
				{
					win = "preview",
					title = "{preview}",
					height = source ~= "diagnostics" and 0.4 or nil,
					border = "top",
				},
			},
		}
	end,
}

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

	-- Mason — server + tool installation
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

	-- nvim-lspconfig (data-only: provides lsp/ directory configs)
	{ "neovim/nvim-lspconfig" },

	-- Completion
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				menu = { border = "rounded", scrollbar = false, auto_show = false },
				trigger = {
					show_on_keyword = false,
					show_on_trigger_character = false,
				},
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
			lazygit = { enabled = true, win = { border = "rounded" } },
			notifier = { enabled = true, timeout = 3000 },
			picker = {
				enabled = true,
				layout = snacks_picker_layout.layout,
				sources = { explorer = {
					auto_close = true,
					layout = snacks_picker_layout.layout,
				} },
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			{
				"<leader>sf",
				function()
					Snacks.picker.files(snacks_picker_layout)
				end,
				desc = "Search files",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep(snacks_picker_layout)
				end,
				desc = "Search grep",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.buffers(snacks_picker_layout)
				end,
				desc = "Search buffers",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help(snacks_picker_layout)
				end,
				desc = "Search help",
			},
			{
				"<leader>sr",
				function()
					Snacks.picker.resume(snacks_picker_layout)
				end,
				desc = "Search resume",
			},
			{
				"<leader>/",
				function()
					Snacks.picker.lines(snacks_picker_layout)
				end,
				desc = "Search in buffer",
			},
			{
				"<leader><leader>",
				function()
					Snacks.picker.buffers(snacks_picker_layout)
				end,
				desc = "Buffers",
			},
			{
				"<leader>q",
				function()
					Snacks.picker.diagnostics(snacks_picker_layout)
				end,
				desc = "Search diagnostics",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps(snacks_picker_layout)
				end,
				desc = "Search keymaps",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history(snacks_picker_layout)
				end,
				desc = "Command history",
			},
			{
				"<leader>sn",
				function()
					Snacks.picker.notifications(snacks_picker_layout)
				end,
				desc = "Notification history",
			},
			{
				"<C-e>",
				function()
					Snacks.explorer(snacks_picker_layout)
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
					Snacks.picker.git_status(snacks_picker_layout)
				end,
				desc = "Git status",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log(snacks_picker_layout)
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
		},
	},

	-- Statusline
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
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				theme = "dragon",
				colors = {
					palette = {
						dragonRed = require("kanagawa.lib.color")("#c4746e"):saturate(-0.35):to_hex(),
					},
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
				overrides = function(colors)
					local theme = colors.theme
					return {
						NormalFloat = { bg = theme.ui.bg_m1 },
						FloatBorder = { bg = theme.ui.bg_m1 },
						FloatTitle = { bg = theme.ui.bg_m1 },
						Pmenu = { fg = theme.ui.fg, bg = theme.ui.bg_m1 },
						PmenuSel = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
						PmenuSbar = { bg = theme.ui.bg_m1 },
						PmenuThumb = { bg = theme.ui.bg_p1 },
						MiniStatuslineFilename = { fg = theme.ui.fg_dim, bg = theme.ui.bg_p1 },
						NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
						LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
						MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					}
				end,
			})
			vim.cmd("colorscheme kanagawa-dragon")
		end,
	},
	{
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
	},
}, {
	ui = { border = "rounded" },
})
