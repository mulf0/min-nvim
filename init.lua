-- Neovim 0.12 Config
-- snacks.nvim for UI, native LSP with lsp/ directory pattern

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")
require("config.plugins")
