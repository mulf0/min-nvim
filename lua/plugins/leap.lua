return {
	"andyg/leap.nvim",
	url = "https://codeberg.org/andyg/leap.nvim",
	event = "VeryLazy",
	config = function()
		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
		vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

		vim.api.nvim_create_autocmd("CmdlineLeave", {
			group = vim.api.nvim_create_augroup("LeapOnSearch", {}),
			callback = function()
				local ev = vim.v.event
				local is_search = (ev.cmdtype == "/") or (ev.cmdtype == "?")
				vim.schedule(function()
					local cnt = vim.fn.searchcount().total
					if is_search and not ev.abort and (cnt > 1) then
						local labels = require("leap").opts.safe_labels:gsub("[nN]", "")
						require("leap").leap({
							pattern = vim.fn.getreg("/"),
							windows = { vim.fn.win_getid() },
							opts = { safe_labels = "", labels = labels },
						})
					end
				end)
			end,
		})
	end,
}
