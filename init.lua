-- Minimal Modern Neovim Config
-- Uses built-in LSP, completion, and modern features

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.breakindent = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.swapfile = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Basic keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus up' })
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>')
vim.keymap.set('i', '<C-s>', '<cmd>w<cr>')
vim.keymap.set('n', '<C-q>', '<cmd>q<cr>')

-- Yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank-highlight', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Diagnostics config (no virtual text clutter)
vim.diagnostic.config {
  virtual_text = false,
  severity_sort = true,
  float = { border = 'single', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
}

-- Override LSP floating preview to use bottom split instead
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
  opts = opts or {}
  
  -- Create buffer with contents
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)
  vim.bo[buf].filetype = syntax or 'markdown'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].modifiable = false
  
  -- Open in bottom split
  local height = math.min(12, #contents)
  local win = vim.api.nvim_open_win(buf, true, {
    split = 'below',
    height = height,
  })
  
  -- q to close
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
  
  return buf, win
end

-- LSP attach config
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local buf = event.buf

    -- Enable built-in completion (Neovim 0.11+)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end

    -- Keymaps
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = buf, desc = desc })
    end

    map('gd', vim.lsp.buf.definition, 'Goto definition')
    map('gD', vim.lsp.buf.declaration, 'Goto declaration')
    map('gr', vim.lsp.buf.references, 'Goto references')
    map('gi', vim.lsp.buf.implementation, 'Goto implementation')
    map('gy', vim.lsp.buf.type_definition, 'Goto type definition')
    map('K', vim.lsp.buf.hover, 'Hover')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature help')
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = buf, desc = 'Signature help' })
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code action')

    -- Document highlight on cursor hold
    if client and client:supports_method('textDocument/documentHighlight') then
      local hl_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Inlay hints toggle
    if client and client:supports_method('textDocument/inlayHint') then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf })
      end, 'Toggle inlay hints')
    end
  end,
})

-- Completion keymaps (for built-in completion)
vim.keymap.set('i', '<C-n>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  else
    return '<C-x><C-o>'
  end
end, { expr = true })
vim.keymap.set('i', '<C-p>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'
  else
    return '<C-x><C-o>'
  end
end, { expr = true })
vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  else
    return '<CR>'
  end
end, { expr = true })
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  else
    return '<Tab>'
  end
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'
  else
    return '<S-Tab>'
  end
end, { expr = true })

-- Simple statusline
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.statusline = ' %f %m'

-- File explorer (netrw)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.keymap.set('n', '<leader>e', ':Explore<CR>', { desc = 'File explorer' })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins (minimal set)
require('lazy').setup({
  -- Treesitter (essential for modern syntax)
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      -- Install parsers on plugin install/update only
      require('nvim-treesitter').install({ 'bash', 'c', 'cpp', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc', 'go', 'rust', 'typescript', 'javascript', 'python' }):wait(300000)
    end,
    config = function()
      require('nvim-treesitter').setup({})
      
      -- Enable highlighting and indentation for all filetypes with parsers
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Mason (LSP installer) - only for installing servers
  { 'mason-org/mason.nvim', opts = {} },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      -- Add/remove servers as needed. gopls needs Go, clangd needs C toolchain, rust_analyzer needs Rust
      ensure_installed = { 'lua_ls', 'ts_ls', 'pyright' },
    },
  },

  -- nvim-lspconfig provides configs, then we enable with native API
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Enable LSP servers (native 0.11+ API)
      -- Only enable servers you have installed
      vim.lsp.enable({ 'lua_ls', 'ts_ls', 'pyright' })
    end,
  },

  -- Telescope (fuzzy finder - bottom pane, no float)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = 'bottom_pane',
          layout_config = {
            bottom_pane = {
              height = 0.4,
              prompt_position = 'bottom',
            },
          },
          border = true,
          sorting_strategy = 'descending',
        },
      }
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search files' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search grep' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Search buffers' })
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Search resume' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Search in buffer' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })
    end,
  },

  -- Gitsigns
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(buf)
        local gs = require 'gitsigns'
        vim.keymap.set('n', ']c', gs.next_hunk, { buffer = buf, desc = 'Next hunk' })
        vim.keymap.set('n', '[c', gs.prev_hunk, { buffer = buf, desc = 'Prev hunk' })
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = buf, desc = 'Stage hunk' })
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = buf, desc = 'Reset hunk' })
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = buf, desc = 'Preview hunk' })
        vim.keymap.set('n', '<leader>hb', gs.blame_line, { buffer = buf, desc = 'Blame line' })
      end,
    },
  },

  -- Autopairs (minimal)
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  -- Flash (search jumping)
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      modes = {
        search = { enabled = true },
      },
    },
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
  },

  -- Conform (formatting with prettier/biome support)
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      { '<leader>f', function() require('conform').format({ async = true }) end, desc = 'Format buffer' },
    },
    opts = {
      formatters_by_ft = {
        javascript = { 'biome', 'prettier', stop_after_first = true },
        javascriptreact = { 'biome', 'prettier', stop_after_first = true },
        typescript = { 'biome', 'prettier', stop_after_first = true },
        typescriptreact = { 'biome', 'prettier', stop_after_first = true },
        json = { 'biome', 'prettier', stop_after_first = true },
        jsonc = { 'biome', 'prettier', stop_after_first = true },
        css = { 'prettier' },
        html = { 'prettier' },
        markdown = { 'prettier' },
        yaml = { 'prettier' },
        lua = { 'stylua', lsp_format = 'fallback' },
        go = { 'gofmt' },
        rust = { lsp_format = 'fallback' },
        python = { 'black', 'isort' },
        c = { lsp_format = 'fallback' },
        cpp = { lsp_format = 'fallback' },
        -- Use LSP for anything not specified
        ['_'] = { lsp_format = 'fallback' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    },
  },

}, {
  ui = {
    border = 'single',
  },
})

-- Load colorscheme
vim.cmd 'colorscheme black_metal_nile'
