-- Neogit — git interface (Magit-style); uses Snacks picker, codediff for diffs
return {
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
}
