-- black_metal_nile.lua
-- Neovim colorscheme using ONLY Ghostty Black Metal (Nile) palette

local M = {}

-- ONLY the 16 colors from your Ghostty palette
local colors = {
    -- palette 0-7
    black = '#000000',      -- 0
    cyan = '#5f8787',       -- 1
    sand = '#aa9988',       -- 2
    olive = '#777755',      -- 3
    gray1 = '#888888',      -- 4
    gray2 = '#999999',      -- 5
    gray3 = '#aaaaaa',      -- 6
    white = '#c1c1c1',      -- 7
    -- palette 8-15 (bright variants)
    bright_black = '#3f3f3f', -- 8
    bright_cyan = '#5f8787', -- 9
    bright_sand = '#aa9988', -- 10
    bright_olive = '#777755', -- 11
    bright_gray1 = '#888888', -- 12
    bright_gray2 = '#999999', -- 13
    bright_gray3 = '#aaaaaa', -- 14
    bright_white = '#c1c1c1', -- 15
    -- bg/fg from config
    bg = '#000000',
    fg = '#c1c1c1',
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

function M.setup()
    vim.cmd 'hi clear'
    if vim.fn.exists 'syntax_on' then
        vim.cmd 'syntax reset'
    end
    vim.o.termguicolors = true
    vim.g.colors_name = 'black_metal_nile'

    -- Editor
    hi('Normal', { fg = colors.fg, bg = colors.bg })
    hi('NormalFloat', { fg = colors.white, bg = colors.bg })
    hi('FloatBorder', { fg = colors.bright_black, bg = colors.bg })
    hi('Cursor', { fg = colors.bg, bg = colors.fg })
    hi('CursorLine', { bg = '#151515' })
    hi('CursorColumn', { bg = colors.bright_black })
    hi('ColorColumn', { bg = colors.bright_black })
    hi('LineNr', { fg = colors.bright_black })
    hi('CursorLineNr', { fg = colors.gray1 })
    hi('SignColumn', { fg = colors.gray1, bg = colors.bg })
    hi('VertSplit', { fg = colors.bright_black })
    hi('WinSeparator', { fg = colors.bright_black })
    hi('StatusLine', { fg = colors.fg, bg = colors.bg })
    hi('StatusLineNC', { fg = colors.bright_black, bg = colors.bg })
    hi('TabLine', { fg = colors.gray1, bg = colors.bg })
    hi('TabLineFill', { bg = colors.bg })
    hi('TabLineSel', { fg = colors.fg, bg = colors.bg })
    hi('Pmenu', { fg = colors.fg, bg = colors.bg })
    hi('PmenuSel', { fg = colors.bg, bg = colors.gray1 })
    hi('PmenuSbar', { bg = colors.bright_black })
    hi('PmenuThumb', { bg = colors.gray1 })
    hi('Visual', { bg = colors.bright_black })
    hi('VisualNOS', { bg = colors.bright_black })
    hi('Search', { fg = colors.bg, bg = colors.sand })
    hi('IncSearch', { fg = colors.bg, bg = colors.gray3 })
    hi('CurSearch', { fg = colors.bg, bg = colors.gray3 })
    hi('Folded', { fg = colors.gray1, bg = colors.bg })
    hi('FoldColumn', { fg = colors.bright_black, bg = colors.bg })
    hi('MatchParen', { fg = colors.sand, bg = colors.bright_black })
    hi('NonText', { fg = colors.bright_black })
    hi('SpecialKey', { fg = colors.bright_black })
    hi('Whitespace', { fg = colors.bright_black })
    hi('EndOfBuffer', { fg = colors.bright_black })
    hi('Directory', { fg = colors.gray3 })
    hi('Conceal', { fg = colors.gray1 })
    hi('ModeMsg', { fg = colors.fg })
    hi('MoreMsg', { fg = colors.gray3 })
    hi('Question', { fg = colors.gray3 })
    hi('ErrorMsg', { fg = colors.sand })
    hi('WarningMsg', { fg = colors.sand })
    hi('WildMenu', { fg = colors.bg, bg = colors.gray3 })
    hi('Title', { fg = colors.sand })
    hi('Underlined', { fg = colors.gray3, underline = true })

    -- Syntax
    hi('Comment', { fg = colors.bright_black, italic = true })
    hi('Constant', { fg = colors.gray3 })
    hi('String', { fg = colors.gray3 })
    hi('Character', { fg = colors.gray3 })
    hi('Number', { fg = colors.gray3 })
    hi('Boolean', { fg = colors.gray3 })
    hi('Float', { fg = colors.gray3 })
    hi('Identifier', { fg = colors.fg })
    hi('Function', { fg = colors.fg })
    hi('Statement', { fg = colors.gray1 })
    hi('Conditional', { fg = colors.gray1 })
    hi('Repeat', { fg = colors.gray1 })
    hi('Label', { fg = colors.gray1 })
    hi('Operator', { fg = colors.gray1 })
    hi('Keyword', { fg = colors.gray1 })
    hi('Exception', { fg = colors.gray1 })
    hi('PreProc', { fg = colors.gray1 })
    hi('Include', { fg = colors.gray1 })
    hi('Define', { fg = colors.gray1 })
    hi('Macro', { fg = colors.sand })
    hi('PreCondit', { fg = colors.gray1 })
    hi('Type', { fg = colors.sand })
    hi('StorageClass', { fg = colors.gray1 })
    hi('Structure', { fg = colors.sand })
    hi('Typedef', { fg = colors.sand })
    hi('Special', { fg = colors.gray3 })
    hi('SpecialChar', { fg = colors.gray3 })
    hi('Tag', { fg = colors.sand })
    hi('Delimiter', { fg = colors.gray1 })
    hi('SpecialComment', { fg = colors.gray1, italic = true })
    hi('Debug', { fg = colors.sand })
    hi('Error', { fg = colors.sand, undercurl = true })
    hi('Todo', { fg = colors.bg, bg = colors.olive })

    -- Diff
    hi('DiffAdd', { fg = colors.olive })
    hi('DiffChange', { fg = colors.sand })
    hi('DiffDelete', { fg = colors.sand })
    hi('DiffText', { fg = colors.fg, bg = colors.bright_black })
    hi('Added', { fg = colors.olive })
    hi('Changed', { fg = colors.sand })
    hi('Removed', { fg = colors.sand })

    -- Diagnostics
    hi('DiagnosticError', { fg = colors.sand })
    hi('DiagnosticWarn', { fg = colors.sand })
    hi('DiagnosticInfo', { fg = colors.gray3 })
    hi('DiagnosticHint', { fg = colors.gray3 })
    hi('DiagnosticOk', { fg = colors.olive })
    hi('DiagnosticUnderlineError', { sp = colors.sand, undercurl = true })
    hi('DiagnosticUnderlineWarn', { sp = colors.sand, undercurl = true })
    hi('DiagnosticUnderlineInfo', { sp = colors.gray3, undercurl = true })
    hi('DiagnosticUnderlineHint', { sp = colors.gray1, undercurl = true })

    -- Git signs
    hi('GitSignsAdd', { fg = colors.olive })
    hi('GitSignsChange', { fg = colors.sand })
    hi('GitSignsDelete', { fg = colors.sand })

    -- Treesitter
    hi('@variable', { fg = colors.fg })
    hi('@variable.builtin', { fg = colors.gray3 })
    hi('@variable.parameter', { fg = colors.fg, italic = true })
    hi('@variable.member', { fg = colors.fg })
    hi('@constant', { fg = colors.gray3 })
    hi('@constant.builtin', { fg = colors.gray3 })
    hi('@constant.macro', { fg = colors.sand })
    hi('@module', { fg = colors.fg })
    hi('@label', { fg = colors.gray1 })
    hi('@string', { fg = colors.gray3 })
    hi('@string.documentation', { fg = colors.gray3 })
    hi('@string.regexp', { fg = colors.gray3 })
    hi('@string.escape', { fg = colors.sand })
    hi('@string.special', { fg = colors.sand })
    hi('@character', { fg = colors.gray3 })
    hi('@character.special', { fg = colors.sand })
    hi('@boolean', { fg = colors.gray3 })
    hi('@number', { fg = colors.gray3 })
    hi('@number.float', { fg = colors.gray3 })
    hi('@type', { fg = colors.sand })
    hi('@type.builtin', { fg = colors.sand })
    hi('@type.definition', { fg = colors.sand })
    hi('@type.qualifier', { fg = colors.gray1 })
    hi('@attribute', { fg = colors.sand })
    hi('@property', { fg = colors.fg })
    hi('@function', { fg = colors.fg })
    hi('@function.builtin', { fg = colors.fg })
    hi('@function.call', { fg = colors.fg })
    hi('@function.macro', { fg = colors.sand })
    hi('@function.method', { fg = colors.fg })
    hi('@function.method.call', { fg = colors.fg })
    hi('@constructor', { fg = colors.sand })
    hi('@operator', { fg = colors.gray1 })
    hi('@keyword', { fg = colors.gray1 })
    hi('@keyword.coroutine', { fg = colors.gray1 })
    hi('@keyword.function', { fg = colors.gray1 })
    hi('@keyword.operator', { fg = colors.gray1 })
    hi('@keyword.import', { fg = colors.gray1 })
    hi('@keyword.storage', { fg = colors.gray1 })
    hi('@keyword.repeat', { fg = colors.gray1 })
    hi('@keyword.return', { fg = colors.gray1 })
    hi('@keyword.debug', { fg = colors.gray1 })
    hi('@keyword.exception', { fg = colors.gray1 })
    hi('@keyword.conditional', { fg = colors.gray1 })
    hi('@keyword.conditional.ternary', { fg = colors.gray1 })
    hi('@keyword.directive', { fg = colors.gray1 })
    hi('@keyword.directive.define', { fg = colors.gray1 })
    hi('@punctuation.delimiter', { fg = colors.gray1 })
    hi('@punctuation.bracket', { fg = colors.gray1 })
    hi('@punctuation.special', { fg = colors.gray1 })
    hi('@comment', { fg = colors.bright_black, italic = true })
    hi('@comment.documentation', { fg = colors.gray1, italic = true })
    hi('@comment.error', { fg = colors.sand })
    hi('@comment.warning', { fg = colors.sand })
    hi('@comment.todo', { fg = colors.bg, bg = colors.olive })
    hi('@comment.note', { fg = colors.gray3 })
    hi('@markup.strong', { bold = true })
    hi('@markup.italic', { italic = true })
    hi('@markup.strikethrough', { strikethrough = true })
    hi('@markup.underline', { underline = true })
    hi('@markup.heading', { fg = colors.sand })
    hi('@markup.quote', { fg = colors.gray1, italic = true })
    hi('@markup.math', { fg = colors.sand })
    hi('@markup.link', { fg = colors.gray3 })
    hi('@markup.link.label', { fg = colors.gray3 })
    hi('@markup.link.url', { fg = colors.gray1, underline = true })
    hi('@markup.raw', { fg = colors.olive })
    hi('@markup.raw.block', { fg = colors.fg })
    hi('@markup.list', { fg = colors.gray3 })
    hi('@markup.list.checked', { fg = colors.olive })
    hi('@markup.list.unchecked', { fg = colors.gray1 })
    hi('@diff.plus', { fg = colors.olive })
    hi('@diff.minus', { fg = colors.sand })
    hi('@diff.delta', { fg = colors.sand })
    hi('@tag', { fg = colors.gray3 })
    hi('@tag.attribute', { fg = colors.sand })
    hi('@tag.delimiter', { fg = colors.gray3 })

    -- LSP semantic tokens
    hi('@lsp.type.class', { link = '@type' })
    hi('@lsp.type.decorator', { link = '@attribute' })
    hi('@lsp.type.enum', { link = '@type' })
    hi('@lsp.type.enumMember', { link = '@constant' })
    hi('@lsp.type.function', { link = '@function' })
    hi('@lsp.type.interface', { link = '@type' })
    hi('@lsp.type.macro', { link = '@function.macro' })
    hi('@lsp.type.method', { link = '@function.method' })
    hi('@lsp.type.namespace', { link = '@module' })
    hi('@lsp.type.parameter', { link = '@variable.parameter' })
    hi('@lsp.type.property', { link = '@property' })
    hi('@lsp.type.struct', { link = '@type' })
    hi('@lsp.type.type', { link = '@type' })
    hi('@lsp.type.typeParameter', { link = '@type' })
    hi('@lsp.type.variable', { link = '@variable' })

    -- Telescope
    hi('TelescopeNormal', { fg = colors.fg, bg = colors.bg })
    hi('TelescopeBorder', { fg = colors.bright_black, bg = colors.bg })
    hi('TelescopePromptNormal', { fg = colors.fg, bg = colors.bg })
    hi('TelescopePromptBorder', { fg = colors.bright_black, bg = colors.bg })
    hi('TelescopePromptTitle', { fg = colors.gray3 })
    hi('TelescopePreviewTitle', { fg = colors.olive })
    hi('TelescopeResultsTitle', { fg = colors.sand })
    hi('TelescopeSelection', { bg = colors.bright_black })
    hi('TelescopeSelectionCaret', { fg = colors.gray3 })
    hi('TelescopeMatching', { fg = colors.sand })

    -- nvim-cmp / blink.cmp
    hi('CmpItemAbbr', { fg = colors.fg })
    hi('CmpItemAbbrDeprecated', { fg = colors.bright_black, strikethrough = true })
    hi('CmpItemAbbrMatch', { fg = colors.gray3 })
    hi('CmpItemAbbrMatchFuzzy', { fg = colors.gray3 })
    hi('CmpItemKind', { fg = colors.gray1 })
    hi('CmpItemMenu', { fg = colors.gray1 })
    hi('BlinkCmpMenu', { fg = colors.fg, bg = colors.bg })
    hi('BlinkCmpMenuBorder', { fg = colors.bright_black, bg = colors.bg })
    hi('BlinkCmpMenuSelection', { bg = colors.bright_black })
    hi('BlinkCmpLabel', { fg = colors.fg })
    hi('BlinkCmpLabelMatch', { fg = colors.gray3 })
    hi('BlinkCmpKind', { fg = colors.gray1 })
    hi('BlinkCmpSource', { fg = colors.gray1 })
    hi('BlinkCmpGhostText', { fg = colors.bright_black })

    -- indent-blankline
    hi('IblIndent', { fg = colors.bright_black })
    hi('IblScope', { fg = colors.gray1 })

    -- treesitter-context
    hi('TreesitterContext', { bg = '#151515' })
    hi('TreesitterContextLineNumber', { fg = colors.gray1, bg = '#151515' })

    -- Neo-tree
    hi('NeoTreeNormal', { fg = colors.fg, bg = colors.bg })
    hi('NeoTreeNormalNC', { fg = colors.fg, bg = colors.bg })
    hi('NeoTreeDirectoryName', { fg = colors.gray3 })
    hi('NeoTreeDirectoryIcon', { fg = colors.gray3 })
    hi('NeoTreeRootName', { fg = colors.sand })
    hi('NeoTreeFileName', { fg = colors.fg })
    hi('NeoTreeFileIcon', { fg = colors.gray1 })
    hi('NeoTreeGitAdded', { fg = colors.olive })
    hi('NeoTreeGitModified', { fg = colors.sand })
    hi('NeoTreeGitDeleted', { fg = colors.sand })
    hi('NeoTreeGitConflict', { fg = colors.sand })
    hi('NeoTreeGitUntracked', { fg = colors.gray1 })
    hi('NeoTreeIndentMarker', { fg = colors.bright_black })
    hi('NeoTreeTitleBar', { fg = colors.fg, bg = colors.bg })

    -- Which-key
    hi('WhichKey', { fg = colors.gray3 })
    hi('WhichKeyGroup', { fg = colors.sand })
    hi('WhichKeyDesc', { fg = colors.fg })
    hi('WhichKeySeparator', { fg = colors.bright_black })
    hi('WhichKeySeperator', { fg = colors.bright_black })
    hi('WhichKeyFloat', { bg = colors.bg })
    hi('WhichKeyBorder', { fg = colors.bright_black, bg = colors.bg })
    hi('WhichKeyValue', { fg = colors.gray1 })
    hi('WhichKeyNormal', { fg = colors.fg, bg = colors.bg })
    hi('WhichKeyTitle', { fg = colors.gray1, bg = colors.bg })

    -- Noice
    hi('NoiceCmdline', { fg = colors.fg, bg = colors.bg })
    hi('NoiceCmdlinePopup', { fg = colors.fg, bg = colors.bg })
    hi('NoiceCmdlinePopupBorder', { fg = colors.bright_black, bg = colors.bg })
    hi('NoiceCmdlineIcon', { fg = colors.gray3 })
    hi('NoicePopup', { fg = colors.fg, bg = colors.bg })
    hi('NoicePopupBorder', { fg = colors.bright_black, bg = colors.bg })
    hi('NoicePopupmenu', { fg = colors.fg, bg = colors.bg })
    hi('NoicePopupmenuBorder', { fg = colors.bright_black, bg = colors.bg })
    hi('NoicePopupmenuSelected', { bg = colors.bright_black })
    hi('NoiceConfirm', { fg = colors.fg, bg = colors.bg })
    hi('NoiceConfirmBorder', { fg = colors.bright_black, bg = colors.bg })

    -- Lazy
    hi('LazyH1', { fg = colors.gray3 })
    hi('LazyButton', { fg = colors.fg, bg = colors.bg })
    hi('LazyButtonActive', { fg = colors.bg, bg = colors.gray1 })
    hi('LazySpecial', { fg = colors.gray3 })
    hi('LazyNormal', { fg = colors.fg, bg = colors.bg })

    -- Mason
    hi('MasonHeader', { fg = colors.gray3 })
    hi('MasonHighlight', { fg = colors.gray3 })
    hi('MasonHighlightBlock', { fg = colors.bg, bg = colors.gray3 })
    hi('MasonMuted', { fg = colors.gray1 })
    hi('MasonMutedBlock', { fg = colors.fg, bg = colors.bright_black })
    hi('MasonNormal', { fg = colors.fg, bg = colors.bg })

    -- Notify
    hi('NotifyERRORBorder', { fg = colors.bright_black })
    hi('NotifyWARNBorder', { fg = colors.bright_black })
    hi('NotifyINFOBorder', { fg = colors.bright_black })
    hi('NotifyDEBUGBorder', { fg = colors.bright_black })
    hi('NotifyTRACEBorder', { fg = colors.bright_black })
    hi('NotifyERRORIcon', { fg = colors.sand })
    hi('NotifyWARNIcon', { fg = colors.sand })
    hi('NotifyINFOIcon', { fg = colors.gray3 })
    hi('NotifyDEBUGIcon', { fg = colors.gray1 })
    hi('NotifyTRACEIcon', { fg = colors.gray1 })
    hi('NotifyERRORTitle', { fg = colors.sand })
    hi('NotifyWARNTitle', { fg = colors.sand })
    hi('NotifyINFOTitle', { fg = colors.gray3 })
    hi('NotifyDEBUGTitle', { fg = colors.gray1 })
    hi('NotifyTRACETitle', { fg = colors.gray1 })
    hi('NotifyBackground', { bg = colors.bg })

    -- Fidget
    hi('FidgetTitle', { fg = colors.gray3 })
    hi('FidgetTask', { fg = colors.gray1 })

    -- Quickfix / Location list
    hi('qfFileName', { fg = colors.gray3 })
    hi('qfLineNr', { fg = colors.gray1 })
    hi('QuickFixLine', {})

    -- Diagnostic floating window text
    hi('DiagnosticFloatingError', { fg = colors.white })
    hi('DiagnosticFloatingWarn', { fg = colors.white })
    hi('DiagnosticFloatingInfo', { fg = colors.white })
    hi('DiagnosticFloatingHint', { fg = colors.white })

    -- Lualine
    vim.g.black_metal_nile_lualine = {
        normal = {
            a = { fg = colors.fg, bg = 'NONE' },
            b = { fg = colors.fg, bg = 'NONE' },
            c = { fg = colors.gray1, bg = 'NONE' },
        },
        insert = { a = { fg = colors.fg, bg = 'NONE' } },
        visual = { a = { fg = colors.fg, bg = 'NONE' } },
        replace = { a = { fg = colors.fg, bg = 'NONE' } },
        command = { a = { fg = colors.fg, bg = 'NONE' } },
        inactive = {
            a = { fg = colors.gray1, bg = 'NONE' },
            b = { fg = colors.gray1, bg = 'NONE' },
            c = { fg = colors.gray1, bg = 'NONE' },
        },
    }
end

M.colors = colors
M.setup()

return M
