return {
	{
		"mfussenegger/nvim-dap",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- ─────────────────────────────────────────────
			-- DAP UI
			-- ─────────────────────────────────────────────

			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.30 },
							{ id = "breakpoints", size = 0.20 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			-- ─────────────────────────────────────────────
			-- GDB
			-- Requires GDB 14+
			-- ─────────────────────────────────────────────

			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = {
					"--interpreter=dap",
					"--eval-command",
					"set print pretty on",
				},
			}

			dap.configurations.c = {
				{
					name = "Launch executable",
					type = "gdb",
					request = "launch",

					program = function()
						return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
					end,

					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
			}

			-- Optional: same debugger configuration for C++
			dap.configurations.cpp = dap.configurations.c

			-- ─────────────────────────────────────────────
			-- Automatically open/close debugger UI
			-- ─────────────────────────────────────────────

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- ─────────────────────────────────────────────
			-- Keymaps
			-- ─────────────────────────────────────────────

			vim.keymap.set("n", "<leader>dc", dap.continue, {
				desc = "Debug: Start / Continue",
			})

			vim.keymap.set("n", "<leader>dn", dap.step_over, {
				desc = "Debug: Step Over",
			})

			vim.keymap.set("n", "<leader>di", dap.step_into, {
				desc = "Debug: Step Into",
			})

			vim.keymap.set("n", "<leader>do", dap.step_out, {
				desc = "Debug: Step Out",
			})

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {
				desc = "Debug: Toggle Breakpoint",
			})

			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, {
				desc = "Debug: Conditional Breakpoint",
			})

			vim.keymap.set("n", "<leader>dr", dap.repl.open, {
				desc = "Debug: Open REPL",
			})

			vim.keymap.set("n", "<leader>du", dapui.toggle, {
				desc = "Debug: Toggle UI",
			})

			vim.keymap.set("n", "<leader>dt", dap.terminate, {
				desc = "Debug: Terminate",
			})

			-- Evaluate variable/expression under cursor
			vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, {
				desc = "Debug: Evaluate",
			})
		end,
	},
}
