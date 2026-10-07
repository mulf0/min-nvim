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
vim.lsp.enable({ "lua_ls", "ts_ls", "ty", "astro", "clangd", "rust_analyzer", "gopls", "goimports", "solidity_ls_nomicfoundation" })
