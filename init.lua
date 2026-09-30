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

-- Jump to tab N.
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, i .. "gt", { desc = "Go to tab " .. i })
end

-- Hide the tab bar entirely.
vim.o.tabline = ""
vim.o.showtabline = 0

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
				"<leader>ra",
				function()
					local buf = vim.api.nvim_get_current_buf()
					Snacks.input({ prompt = "Find (literal, case-insensitive)" }, function(find)
						if not find or find == "" then
							return
						end
						Snacks.input({ prompt = "Replace with" }, function(replacement)
							if replacement == nil or not vim.api.nvim_buf_is_valid(buf) then
								return
							end
							local pattern = "\\V\\c" .. vim.fn.escape(find, "\\/")
							local text = vim.fn.escape(replacement, "\\/&~")
							local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
								vim.cmd("%smagic/" .. pattern .. "/" .. text .. "/g")
								end)
							if not ok then
								vim.notify(tostring(err), vim.log.levels.WARN)
								end
						end)
					end)
				end,
				desc = "Replace all in buffer",
			},
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

	-- Neogit — git interface (Magit-style); uses Snacks picker, codediff for diffs
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			{
				"esmuellert/codediff.nvim",
				cmd = "CodeDiff",
				opts = {
					diff = { layout = "side-by-side" },
					explorer = { position = "bottom" },
				},
				config = function(_, opts)
					require("codediff").setup(opts)

					-- Shim for Neogit's codediff integration, which still passes the
					-- legacy session schema (mode/explorer_data/original_path) instead
					-- of codediff's panel shape. See NeogitOrg/neogit#2008.
					local ok, view = pcall(require, "codediff.ui.view")
					if not (ok and view.create) then
						return
					end

					local original_create = view.create
					local path = require("codediff.core.path")
					view.create = function(session_config, filetype, on_ready)
						if not session_config.panel then
							if session_config.mode == "explorer" then
								session_config.panel = {
									name = "explorer",
									data = session_config.explorer_data or {},
								}
								session_config.original = session_config.original or path.empty()
								session_config.modified = session_config.modified or path.empty()
							else
								session_config.original = session_config.original
									or path.make_ref(session_config.original_path, session_config.git_root)
								session_config.modified = session_config.modified
									or path.make_ref(session_config.modified_path, session_config.git_root)
							end
						end
						return original_create(session_config, filetype, on_ready)
					end
				end,
				keys = {
					{ "<leader>gc", "<cmd>CodeDiff<cr>", desc = "Diff working-tree changes" },
					{
						"<leader>gd",
						function()
							local out = vim.fn.systemlist({
								"git",
								"for-each-ref",
								"--format=%(refname:short)",
								"refs/heads",
								"refs/remotes",
							})
							if vim.v.shell_error ~= 0 or #out == 0 then
								vim.notify("No git branches found", vim.log.levels.WARN)
								return
							end
							vim.ui.select(out, { prompt = "Branch with changes" }, function(head)
								if not head then
									return
								end
								vim.ui.select(out, { prompt = "Compare against" }, function(base)
									if base then
										vim.cmd("CodeDiff " .. base .. " " .. head)
									end
								end)
							end)
						end,
						desc = "Diff two branches",
					},
				},
			},
		},
		opts = {
			commit_editor = { kind = "tab" },
			commit_view = { kind = "tab" },
			graph_style = "unicode",
			kind = "tab",
		},
		config = function(_, opts)
			require("neogit").setup(opts)

			-- Open a selected commit in codediff instead of the inline commit view
			local actions = require("neogit.buffers.status.actions")
			local goto_file = actions.n_goto_file
			actions.n_goto_file = function(self)
				return function()
					local item = self.buffer.ui:get_item_under_cursor()
					if item and item.absolute_path then
						return goto_file(self)()
					end
					local ref = self.buffer.ui:get_yankable_under_cursor()
					if ref then
						require("neogit.integrations.codediff").open(nil, ref)
					end
				end
			end
		end,
		keys = {
			{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
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
		"vague-theme/vague.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vague").setup({
				on_highlights = function(hl, colors)
					hl.NormalFloat = { fg = colors.fg, bg = colors.bg }
					hl.FloatBorder = { fg = colors.floatBorder }
					hl.Pmenu = { fg = colors.fg, bg = colors.bg }
					hl.PmenuSel = { fg = colors.fg, bg = colors.visual }
					hl.MiniStatuslineFilename = { fg = colors.fg, bg = colors.line }
					hl.MiniStatuslineDevinfo = { fg = colors.fg, bg = colors.line }
					hl.MiniStatuslineInactive = { fg = colors.comment, bg = colors.line }

					local function set_syntax_fg(groups, color)
						for _, group in ipairs(groups) do
							if hl[group] then
								hl[group].fg = color
							end
						end
					end

					-- Keep syntax to a small palette without changing backgrounds.
					set_syntax_fg({
						"Constant",
						"Identifier",
						"StorageClass",
						"Structure",
						"Tag",
						"Title",
						"Type",
						"Typedef",
						"@constructor",
						"@constructor.lua",
						"@markup",
						"@markup.raw",
						"@property",
						"@type.declaration",
						"@type.definition",
						"@variable",
						"@variable.parameter",
					}, colors.type)
					set_syntax_fg({ "Special", "@type.builtin", "@variable.member" }, colors.builtin)
					set_syntax_fg({
						"Conditional",
						"Exception",
						"Include",
						"Keyword",
						"Label",
						"PreProc",
						"Repeat",
						"SpecialChar",
						"SpecialComment",
						"Statement",
						"@keyword.return",
						"@markup.heading",
						"@markup.list",
					}, colors.keyword)
					set_syntax_fg({ "Operator" }, colors.operator)
					set_syntax_fg({
						"Function",
						"@function.builtin",
						"@function.call",
						"@function.method.call",
						"@markup.link.url",
						"@string.special.url",
					}, colors.type)
					hl["@function.macro"] = { fg = colors.type }
					set_syntax_fg({
						"Boolean",
						"Character",
						"Float",
						"Number",
						"String",
						"@constant.builtin",
					}, colors.plus)
					set_syntax_fg({
						"@markup.link.label",
						"@markup.math",
					}, colors.operator)
				end,
			})
			vim.cmd("colorscheme vague")
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
