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

-- Use Neovim's built-in OSC 52 clipboard (no wl-copy/xsel dependency).
vim.g.clipboard = "osc52"
vim.o.clipboard = "unnamedplus"

-- Hide the tab bar entirely.
vim.o.tabline = ""
vim.o.showtabline = 0
