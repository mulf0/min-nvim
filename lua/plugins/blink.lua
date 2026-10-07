-- Completion
return {
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
}
