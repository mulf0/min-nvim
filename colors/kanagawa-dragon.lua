-- Kanagawa Dragon colorscheme for Neovim
-- Save to: ~/.config/nvim/colors/kanagawa-dragon.lua
-- Usage: vim.cmd.colorscheme("kanagawa-dragon")

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.g.colors_name = "kanagawa-dragon"

local c = {
    bg = "#181616",
    bg_dark = "#0d0c0c",
    bg_light = "#223249",
    fg = "#c8c093",
    fg_dim = "#a6a69c",
    fg_bright = "#c5c9c5",
    black = "#0d0c0c",
    red = "#c4746e",
    green = "#8a9a7b",
    yellow = "#b1a17c",
    blue = "#8ba4b0",
    magenta = "#a292a3",
    cyan = "#8ea4a2",
    white = "#c8c093",
    bright_black = "#a6a69c",
    bright_red = "#e46876",
    bright_green = "#87a987",
    bright_yellow = "#d0b077",
    bright_blue = "#7fb4ca",
    bright_magenta = "#938aa9",
    bright_cyan = "#7aa89f",
    bright_white = "#c5c9c5",
    selection = "#223249",
    cursor = "#c5c9c5",
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = "#1f1d1d" })
hi("FloatBorder", { fg = c.bg_light, bg = "#1f1d1d" })
hi("NormalNC", { fg = c.fg, bg = c.bg })
hi("Cursor", { fg = c.bg, bg = c.cursor })
hi("CursorLine", { bg = "#1f1d1d" })
hi("CursorColumn", { bg = "#1f1d1d" })
hi("ColorColumn", { bg = "#1f1d1d" })
hi("LineNr", { fg = c.bright_black })
hi("CursorLineNr", { fg = c.bright_yellow, bold = true })
hi("SignColumn", { fg = c.fg_dim, bg = c.bg })
hi("VertSplit", { fg = c.bg_light, bg = c.bg })
hi("WinSeparator", { fg = c.bg_light, bg = c.bg })
hi("Folded", { fg = c.bright_black, bg = c.bg_dark })
hi("FoldColumn", { fg = c.bright_black, bg = c.bg })
hi("StatusLine", { fg = c.fg, bg = "NONE", bold = true })
hi("StatusLineNC", { fg = c.fg_dim, bg = "NONE" })
hi("TabLine", { fg = c.fg_dim, bg = c.bg_dark })
hi("TabLineFill", { bg = c.bg_dark })
hi("TabLineSel", { fg = c.fg, bg = c.bg })
hi("WinBar", { fg = c.fg, bg = c.bg })
hi("WinBarNC", { fg = c.fg_dim, bg = c.bg })

-- Search & Selection
hi("Visual", { bg = c.selection })
hi("VisualNOS", { bg = c.selection })
hi("Search", { fg = c.bg, bg = c.bright_yellow })
hi("IncSearch", { fg = c.bg, bg = c.bright_red })
hi("CurSearch", { fg = c.bg, bg = c.bright_yellow })
hi("Substitute", { fg = c.bg, bg = c.bright_red })

-- Popup menu
hi("Pmenu", { fg = c.fg, bg = "#1f1d1d" })
hi("PmenuSel", { fg = c.fg_bright, bg = c.bg_light, bold = true })
hi("PmenuSbar", { bg = "#1f1d1d" })
hi("PmenuThumb", { bg = c.fg_dim })

-- Messages
hi("ErrorMsg", { fg = c.bright_red })
hi("WarningMsg", { fg = c.bright_yellow })
hi("ModeMsg", { fg = c.fg, bold = true })
hi("MoreMsg", { fg = c.bright_blue })
hi("Question", { fg = c.bright_blue })

-- Diff
hi("DiffAdd", { fg = c.bright_green, bg = "#1a2320" })
hi("DiffChange", { fg = c.bright_yellow, bg = "#1f1d1a" })
hi("DiffDelete", { fg = c.bright_red, bg = "#201a1a" })
hi("DiffText", { fg = c.bright_yellow, bg = "#2d2920", bold = true })

-- Spelling
hi("SpellBad", { sp = c.bright_red, undercurl = true })
hi("SpellCap", { sp = c.bright_yellow, undercurl = true })
hi("SpellLocal", { sp = c.bright_blue, undercurl = true })
hi("SpellRare", { sp = c.bright_magenta, undercurl = true })

-- Misc UI
hi("NonText", { fg = c.bg_light })
hi("SpecialKey", { fg = c.bg_light })
hi("Whitespace", { fg = c.bg_light })
hi("EndOfBuffer", { fg = c.bg })
hi("Directory", { fg = c.bright_blue })
hi("Conceal", { fg = c.bright_black })
hi("MatchParen", { fg = c.bright_yellow, bold = true })
hi("Title", { fg = c.bright_blue, bold = true })

-- Diagnostics
hi("DiagnosticError", { fg = c.bright_red })
hi("DiagnosticWarn", { fg = c.bright_yellow })
hi("DiagnosticInfo", { fg = c.bright_blue })
hi("DiagnosticHint", { fg = c.bright_cyan })
hi("DiagnosticOk", { fg = c.bright_green })
hi("DiagnosticUnderlineError", { sp = c.bright_red, undercurl = true })
hi("DiagnosticUnderlineWarn", { sp = c.bright_yellow, undercurl = true })
hi("DiagnosticUnderlineInfo", { sp = c.bright_blue, undercurl = true })
hi("DiagnosticUnderlineHint", { sp = c.bright_cyan, undercurl = true })

-- Syntax (minimal palette: green, purple, yellow, blue)
hi("Comment", { fg = c.bright_black, italic = true })
hi("Constant", { fg = c.bright_yellow })
hi("String", { fg = c.bright_green })
hi("Character", { fg = c.bright_green })
hi("Number", { fg = c.bright_yellow })
hi("Boolean", { fg = c.bright_yellow })
hi("Float", { fg = c.bright_yellow })
hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.bright_blue })
hi("Statement", { fg = c.magenta })
hi("Conditional", { fg = c.magenta })
hi("Repeat", { fg = c.magenta })
hi("Label", { fg = c.magenta })
hi("Operator", { fg = c.fg })
hi("Keyword", { fg = c.magenta })
hi("Exception", { fg = c.magenta })
hi("PreProc", { fg = c.magenta })
hi("Include", { fg = c.magenta })
hi("Define", { fg = c.magenta })
hi("Macro", { fg = c.magenta })
hi("PreCondit", { fg = c.magenta })
hi("Type", { fg = c.yellow })
hi("StorageClass", { fg = c.magenta })
hi("Structure", { fg = c.yellow })
hi("Typedef", { fg = c.yellow })
hi("Special", { fg = c.fg })
hi("SpecialChar", { fg = c.bright_green })
hi("Tag", { fg = c.magenta })
hi("Delimiter", { fg = c.fg_dim })
hi("SpecialComment", { fg = c.bright_black })
hi("Debug", { fg = c.bright_red })
hi("Underlined", { fg = c.bright_blue, underline = true })
hi("Ignore", { fg = c.bg })
hi("Error", { fg = c.bright_red })
hi("Todo", { fg = c.bright_yellow, bg = c.bg_dark, bold = true })

-- Treesitter (minimal: green, purple, yellow, blue)
hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.fg })
hi("@variable.parameter", { fg = c.fg })
hi("@variable.member", { fg = c.fg })
hi("@constant", { fg = c.bright_yellow })
hi("@constant.builtin", { fg = c.bright_yellow })
hi("@constant.macro", { fg = c.bright_yellow })
hi("@module", { fg = c.fg })
hi("@module.builtin", { fg = c.fg })
hi("@label", { fg = c.magenta })
hi("@string", { fg = c.bright_green })
hi("@string.documentation", { fg = c.bright_green })
hi("@string.regexp", { fg = c.bright_green })
hi("@string.escape", { fg = c.bright_green })
hi("@string.special", { fg = c.bright_green })
hi("@string.special.symbol", { fg = c.bright_yellow })
hi("@string.special.url", { fg = c.bright_blue, underline = true })
hi("@character", { fg = c.bright_green })
hi("@character.special", { fg = c.bright_green })
hi("@boolean", { fg = c.bright_yellow })
hi("@number", { fg = c.bright_yellow })
hi("@number.float", { fg = c.bright_yellow })
hi("@type", { fg = c.yellow })
hi("@type.builtin", { fg = c.yellow })
hi("@type.definition", { fg = c.yellow })
hi("@type.qualifier", { fg = c.magenta })
hi("@attribute", { fg = c.magenta })
hi("@attribute.builtin", { fg = c.magenta })
hi("@property", { fg = c.fg })
hi("@function", { fg = c.bright_blue })
hi("@function.builtin", { fg = c.bright_blue })
hi("@function.call", { fg = c.bright_blue })
hi("@function.macro", { fg = c.magenta })
hi("@function.method", { fg = c.bright_blue })
hi("@function.method.call", { fg = c.bright_blue })
hi("@constructor", { fg = c.bright_blue })
hi("@operator", { fg = c.fg })
hi("@keyword", { fg = c.magenta })
hi("@keyword.coroutine", { fg = c.magenta })
hi("@keyword.function", { fg = c.magenta })
hi("@keyword.operator", { fg = c.magenta })
hi("@keyword.import", { fg = c.magenta })
hi("@keyword.type", { fg = c.magenta })
hi("@keyword.modifier", { fg = c.magenta })
hi("@keyword.repeat", { fg = c.magenta })
hi("@keyword.return", { fg = c.magenta })
hi("@keyword.debug", { fg = c.magenta })
hi("@keyword.exception", { fg = c.magenta })
hi("@keyword.conditional", { fg = c.magenta })
hi("@keyword.conditional.ternary", { fg = c.magenta })
hi("@keyword.directive", { fg = c.magenta })
hi("@keyword.directive.define", { fg = c.magenta })
hi("@punctuation.delimiter", { fg = c.fg_dim })
hi("@punctuation.bracket", { fg = c.fg_dim })
hi("@punctuation.special", { fg = c.fg_dim })
hi("@comment", { fg = c.bright_black, italic = true })
hi("@comment.documentation", { fg = c.bright_black })
hi("@comment.error", { fg = c.bright_red })
hi("@comment.warning", { fg = c.bright_yellow })
hi("@comment.todo", { fg = c.bright_yellow, bold = true })
hi("@comment.note", { fg = c.bright_blue })
hi("@markup.strong", { bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strikethrough", { strikethrough = true })
hi("@markup.underline", { underline = true })
hi("@markup.heading", { fg = c.bright_blue, bold = true })
hi("@markup.quote", { fg = c.bright_black, italic = true })
hi("@markup.math", { fg = c.bright_cyan })
hi("@markup.link", { fg = c.bright_blue })
hi("@markup.link.label", { fg = c.bright_cyan })
hi("@markup.link.url", { fg = c.bright_blue, underline = true })
hi("@markup.raw", { fg = c.bright_green })
hi("@markup.raw.block", { fg = c.fg })
hi("@markup.list", { fg = c.magenta })
hi("@markup.list.checked", { fg = c.bright_green })
hi("@markup.list.unchecked", { fg = c.fg_dim })
hi("@diff.plus", { fg = c.bright_green })
hi("@diff.minus", { fg = c.bright_red })
hi("@diff.delta", { fg = c.bright_yellow })
hi("@tag", { fg = c.magenta })
hi("@tag.attribute", { fg = c.fg })
hi("@tag.delimiter", { fg = c.fg_dim })

-- LSP semantic tokens
hi("@lsp.type.class", { link = "@type" })
hi("@lsp.type.decorator", { link = "@attribute" })
hi("@lsp.type.enum", { link = "@type" })
hi("@lsp.type.enumMember", { link = "@constant" })
hi("@lsp.type.function", { link = "@function" })
hi("@lsp.type.interface", { link = "@type" })
hi("@lsp.type.macro", { link = "@function.macro" })
hi("@lsp.type.method", { link = "@function.method" })
hi("@lsp.type.namespace", { link = "@module" })
hi("@lsp.type.parameter", { link = "@variable.parameter" })
hi("@lsp.type.property", { link = "@property" })
hi("@lsp.type.struct", { link = "@type" })
hi("@lsp.type.type", { link = "@type" })
hi("@lsp.type.typeParameter", { link = "@type" })
hi("@lsp.type.variable", { link = "@variable" })

-- Git signs
hi("GitSignsAdd", { fg = c.bright_green })
hi("GitSignsChange", { fg = c.bright_yellow })
hi("GitSignsDelete", { fg = c.bright_red })

-- Telescope
hi("TelescopeNormal", { fg = c.fg, bg = "NONE" })
hi("TelescopeBorder", { fg = c.bg_light, bg = "NONE" })
hi("TelescopePromptNormal", { fg = c.fg, bg = "NONE" })
hi("TelescopePromptBorder", { fg = c.bg_light, bg = "NONE" })
hi("TelescopePromptTitle", { fg = c.bg, bg = c.bright_blue })
hi("TelescopePreviewTitle", { fg = c.bg, bg = c.bright_green })
hi("TelescopeResultsTitle", { fg = c.bg, bg = c.bright_magenta })
hi("TelescopeSelection", { fg = c.fg_bright, bg = c.bg_light })
hi("TelescopeMatching", { fg = c.bright_yellow, bold = true })

-- Neo-tree
hi("NeoTreeNormal", { fg = c.fg, bg = c.bg_dark })
hi("NeoTreeNormalNC", { fg = c.fg, bg = c.bg_dark })
hi("NeoTreeDirectoryIcon", { fg = c.bright_blue })
hi("NeoTreeDirectoryName", { fg = c.bright_blue })
hi("NeoTreeRootName", { fg = c.bright_blue, bold = true })
hi("NeoTreeFileName", { fg = c.fg })
hi("NeoTreeFileIcon", { fg = c.fg })
hi("NeoTreeGitAdded", { fg = c.bright_green })
hi("NeoTreeGitModified", { fg = c.bright_yellow })
hi("NeoTreeGitDeleted", { fg = c.bright_red })

-- nvim-cmp
hi("CmpItemAbbrDeprecated", { fg = c.bright_black, strikethrough = true })
hi("CmpItemAbbrMatch", { fg = c.bright_yellow, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.bright_yellow, bold = true })
hi("CmpItemKindVariable", { fg = c.fg })
hi("CmpItemKindInterface", { fg = c.yellow })
hi("CmpItemKindText", { fg = c.fg })
hi("CmpItemKindFunction", { fg = c.bright_blue })
hi("CmpItemKindMethod", { fg = c.bright_blue })
hi("CmpItemKindKeyword", { fg = c.magenta })
hi("CmpItemKindProperty", { fg = c.fg })
hi("CmpItemKindUnit", { fg = c.bright_yellow })
hi("CmpItemKindSnippet", { fg = c.magenta })
hi("CmpItemKindClass", { fg = c.yellow })
hi("CmpItemKindModule", { fg = c.fg })
hi("CmpItemMenu", { fg = c.bright_black })

-- blink.cmp
hi("BlinkCmpMenu", { fg = c.fg, bg = "#1f1d1d" })
hi("BlinkCmpMenuBorder", { fg = c.bg_light, bg = "#1f1d1d" })
hi("BlinkCmpMenuSelection", { fg = c.fg_bright, bg = c.bg_light, bold = true })
hi("BlinkCmpLabel", { fg = c.fg })
hi("BlinkCmpLabelMatch", { fg = c.bright_yellow, bold = true })
hi("BlinkCmpKind", { fg = c.magenta })
hi("BlinkCmpKindFunction", { fg = c.bright_blue })
hi("BlinkCmpKindMethod", { fg = c.bright_blue })
hi("BlinkCmpKindVariable", { fg = c.fg })
hi("BlinkCmpKindKeyword", { fg = c.magenta })
hi("BlinkCmpKindText", { fg = c.fg })
hi("BlinkCmpKindClass", { fg = c.yellow })
hi("BlinkCmpKindSnippet", { fg = c.magenta })

-- Indent blankline
hi("IblIndent", { fg = "#252323" })
hi("IblScope", { fg = c.bg_light })

-- Which-key
hi("WhichKey", { fg = c.bright_blue })
hi("WhichKeyGroup", { fg = c.magenta })
hi("WhichKeyDesc", { fg = c.fg })
hi("WhichKeySeparator", { fg = c.bright_black })
hi("WhichKeyFloat", { bg = c.bg_dark })

-- Lazy.nvim
hi("LazyH1", { fg = c.bg, bg = c.bright_blue, bold = true })
hi("LazyButton", { fg = c.fg, bg = c.bg_dark })
hi("LazyButtonActive", { fg = c.bg, bg = c.bright_green })
hi("LazySpecial", { fg = c.bright_cyan })

-- Mason
hi("MasonHeader", { fg = c.bg, bg = c.bright_blue, bold = true })
hi("MasonHighlight", { fg = c.bright_blue })
hi("MasonHighlightBlock", { fg = c.bg, bg = c.bright_green })
hi("MasonHighlightBlockBold", { fg = c.bg, bg = c.bright_green, bold = true })

-- Notify
hi("NotifyERRORBorder", { fg = c.bright_red })
hi("NotifyWARNBorder", { fg = c.bright_yellow })
hi("NotifyINFOBorder", { fg = c.bright_blue })
hi("NotifyDEBUGBorder", { fg = c.bright_black })
hi("NotifyTRACEBorder", { fg = c.bright_magenta })
hi("NotifyERRORIcon", { fg = c.bright_red })
hi("NotifyWARNIcon", { fg = c.bright_yellow })
hi("NotifyINFOIcon", { fg = c.bright_blue })
hi("NotifyDEBUGIcon", { fg = c.bright_black })
hi("NotifyTRACEIcon", { fg = c.bright_magenta })
hi("NotifyERRORTitle", { fg = c.bright_red })
hi("NotifyWARNTitle", { fg = c.bright_yellow })
hi("NotifyINFOTitle", { fg = c.bright_blue })
hi("NotifyDEBUGTitle", { fg = c.bright_black })
hi("NotifyTRACETitle", { fg = c.bright_magenta })

-- Noice
hi("NoiceCmdlinePopupBorder", { fg = c.bg_light })
hi("NoiceCmdlineIcon", { fg = c.bright_blue })

-- Flash.nvim
hi("FlashLabel", { fg = c.bg, bg = c.bright_red, bold = true })
hi("FlashMatch", { fg = c.bright_yellow })
hi("FlashCurrent", { fg = c.bright_green })

-- Mini
hi("MiniStatuslineFilename", { fg = c.fg, bg = c.bg_dark })
hi("MiniStatuslineDevinfo", { fg = c.fg_dim, bg = c.bg_dark })
hi("MiniStatuslineFileinfo", { fg = c.fg_dim, bg = c.bg_dark })
hi("MiniStatuslineInactive", { fg = c.fg_dim, bg = c.bg_dark })
hi("MiniStatuslineModeNormal", { fg = c.bg, bg = c.bright_blue, bold = true })
hi("MiniStatuslineModeInsert", { fg = c.bg, bg = c.bright_green, bold = true })
hi("MiniStatuslineModeVisual", { fg = c.bg, bg = c.bright_magenta, bold = true })
hi("MiniStatuslineModeReplace", { fg = c.bg, bg = c.bright_red, bold = true })
hi("MiniStatuslineModeCommand", { fg = c.bg, bg = c.bright_yellow, bold = true })

-- Terminal colors
vim.g.terminal_color_0 = c.black
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.magenta
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.white
vim.g.terminal_color_8 = c.bright_black
vim.g.terminal_color_9 = c.bright_red
vim.g.terminal_color_10 = c.bright_green
vim.g.terminal_color_11 = c.bright_yellow
vim.g.terminal_color_12 = c.bright_blue
vim.g.terminal_color_13 = c.bright_magenta
vim.g.terminal_color_14 = c.bright_cyan
vim.g.terminal_color_15 = c.bright_white
