-- Neovim 0.11.3+; use a Nerd Font in your terminal.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.signcolumn = 'yes'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.laststatus = 3
vim.opt.cmdheight = 0

vim.opt.scrolloff = 8
vim.opt.winborder = 'rounded'

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  signs = false,
  underline = false,
})

vim.filetype.add({ extension = { sol = 'solidity' } })

-- Bootstrap the plugin manager.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error('Failed to install lazy.nvim:\n' .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'vague-theme/vague.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('vague')
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = false,
    opts = {},
  },
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 900,
    opts = {
      picker = {
        enabled = true,
        -- Include hidden files while respecting ignore rules.
        -- Exclude Git's internal database.
        sources = {
          files = {
            hidden = true, ignored = false, exclude = { '.git' },
            icons = { files = { enabled = false } },
          },
          grep = {
            hidden = true, ignored = false, exclude = { '.git' },
            icons = { files = { enabled = false } },
          },
        },
      },
    },
    keys = {
      {
        '<leader>q',
        function() require('snacks').picker.diagnostics({ layout = { preview = false } }) end,
        desc = 'View diagnostics',
      },
      {
        '<leader>sg',
        function() require('snacks').picker.grep({ cwd = vim.fn.getcwd() }) end,
        desc = 'Search file contents (cwd)',
      },
      {
        '<leader>sf',
        function() require('snacks').picker.files({ cwd = vim.fn.getcwd() }) end,
        desc = 'Search filenames (cwd)',
      },
    },
  },
  {
    'folke/flash.nvim',
    opts = {
      search = { multi_window = false },
      modes = {
        search = { enabled = false },
        char = { enabled = false },
      },
      prompt = { win_config = { border = 'none' } },
    },
    keys = {
      {
        's',
        mode = 'n',
        function() require('flash').jump() end,
        desc = 'Flash in current buffer',
      },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    lazy = false,
    cmd = 'Neotree',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<C-e>', '<Cmd>Neotree toggle<CR>', desc = 'Toggle file tree' },
    },
    opts = function()
      local file_renderer = vim.tbl_filter(function(component)
        return component[1] ~= 'icon'
      end, vim.deepcopy(require('neo-tree.defaults').renderers.file))
      return {
        popup_border_style = 'rounded',
        filesystem = {
          follow_current_file = { enabled = true },
          filtered_items = { visible = true, hide_dotfiles = false },
          renderers = { file = file_renderer },
        },
        event_handlers = {
          {
            event = 'file_opened',
            handler = function()
              require('neo-tree.command').execute({ action = 'close' })
            end,
          },
        },
      }
    end,
  },
  {
    'echasnovski/mini.statusline',
    dependencies = {
      { 'nvim-mini/mini-git', main = 'mini.git', opts = {} },
    },
    opts = {
      use_icons = true,
      content = {
        active = function()
          local statusline = require('mini.statusline')
          local mode = statusline.section_mode({ trunc_width = 120 })
          return statusline.combine_groups({
            { hl = 'StatusLine', strings = { mode } },
            {
              hl = 'MiniStatuslineDevinfo',
              strings = {
                statusline.section_git({ trunc_width = 40 }),
                statusline.section_diff({ trunc_width = 75 }),
              },
            },
            '%<',
            { hl = 'MiniStatuslineFilename', strings = { '%f%m%r' } },
            '%=',
          })
        end,
        inactive = function() return '%#MiniStatuslineInactive#%f%m%r%=' end,
      },
    },
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      keymap = { preset = 'enter' },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        trigger = { show_on_keyword = true, show_on_trigger_character = true },
        menu = { auto_show = true },
        documentation = { auto_show = true },
      },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      fuzzy = { implementation = 'prefer_rust' },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
      { 'mason-org/mason.nvim', opts = {} },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'rust-analyzer',
          'gopls',
          'typescript-language-server',
          'lua-language-server',
          'nomicfoundation-solidity-language-server',
        },
      })

      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              library = { vim.env.VIMRUNTIME },
              checkThirdParty = false,
            },
          },
        },
      })
      vim.lsp.enable({ 'rust_analyzer', 'gopls', 'ts_ls', 'lua_ls', 'solidity_ls_nomicfoundation' })
    end,
  },
}, {
  install = { colorscheme = { 'vague' } },
  ui = { border = 'rounded' },
})
