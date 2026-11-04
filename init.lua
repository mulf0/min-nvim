-- Neovim 0.11.3+; use a Nerd Font in your terminal.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.mouse = 'a'
-- Yank/delete/paste use the system clipboard (`wl-copy` detected as provider).
vim.opt.clipboard = 'unnamedplus'
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
-- Break soft-wrapped lines at word boundaries.
vim.opt.linebreak = true

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  signs = false,
  underline = false,
})

vim.filetype.add({ extension = { sol = 'solidity' } })

-- Spell checking only in markdown.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function() vim.opt_local.spell = true end,
})

-- Flash the yanked region.
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank-highlight', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

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
      -- Neovim notifications (incl. Neogit push/fetch results) render in the
      -- snacks notifier instead of the message line.
      notifier = { enabled = true, timeout = 3000 },
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
        function() vim.diagnostic.setqflist({ open = true }) end,
        desc = 'Diagnostics quickfix list',
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
      {
        '<leader>gs',
        function() require('snacks').picker.git_status() end,
        desc = 'Git status',
      },
      {
        '<leader>gl',
        function() require('snacks').picker.git_log() end,
        desc = 'Git log',
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
  require('plugins.conform'),
  {
    'folke/which-key.nvim',
    commit = '3aab2147e74890957785941f0c1ad87d0a44c15a',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
      spec = {
        { '<leader>s', group = 'Search' },
        { '<leader>g', group = 'Git' },
        { '<leader>w', group = 'Workspace' },
        { '<leader>t', group = 'Toggle' },
        { 'g', group = 'Goto' },
        { 'gr', group = 'LSP' },
      },
    },
  },
  -- Neogit with codediff; commit pins match the shim below (Neogit#2008).
  {
    'NeogitOrg/neogit',
    commit = '832a2db084ac25c2801fd73a3fab58f3c82ed2ec',
    cmd = 'Neogit',
    dependencies = {
      {
        'esmuellert/codediff.nvim',
        commit = '09d9ebef2cc5a5c04db7a349cd6c61bdf84ecc8e',
        cmd = 'CodeDiff',
        opts = {
          diff = { layout = 'side-by-side' },
          explorer = { position = 'bottom' },
        },
        config = function(_, opts)
          require('codediff').setup(opts)

          -- Shim for Neogit's codediff integration, which still passes the
          -- legacy session schema (mode/explorer_data/original_path) instead
          -- of codediff's panel shape. See NeogitOrg/neogit#2008.
          local ok, view = pcall(require, 'codediff.ui.view')
          if not (ok and view.create) then return end

          local original_create = view.create
          local path = require('codediff.core.path')
          view.create = function(session_config, filetype, on_ready)
            if not session_config.panel then
              if session_config.mode == 'explorer' then
                session_config.panel = {
                  name = 'explorer',
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
          { '<leader>gc', '<cmd>CodeDiff<cr>', desc = 'Diff working-tree changes' },
          {
            '<leader>gd',
            function()
              local out = vim.fn.systemlist({
                'git', 'for-each-ref', '--format=%(refname:short)',
                'refs/heads', 'refs/remotes',
              })
              if vim.v.shell_error ~= 0 or #out == 0 then
                vim.notify('No git branches found', vim.log.levels.WARN)
                return
              end
              vim.ui.select(out, { prompt = 'Branch with changes' }, function(head)
                if not head then return end
                vim.ui.select(out, { prompt = 'Compare against' }, function(base)
                  if base then vim.cmd('CodeDiff ' .. base .. ' ' .. head) end
                end)
              end)
            end,
            desc = 'Diff two branches',
          },
        },
      },
    },
    opts = {
      commit_editor = { kind = 'tab' },
      commit_view = { kind = 'tab' },
      graph_style = 'unicode',
      kind = 'tab',
    },
    config = function(_, opts)
      require('neogit').setup(opts)

      -- Open a selected commit in codediff instead of the inline commit view
      local actions = require('neogit.buffers.status.actions')
      local goto_file = actions.n_goto_file
      actions.n_goto_file = function(self)
        return function()
          local item = self.buffer.ui:get_item_under_cursor()
          if item and item.absolute_path then return goto_file(self)() end
          local ref = self.buffer.ui:get_yankable_under_cursor()
          if ref then require('neogit.integrations.codediff').open(nil, ref) end
        end
      end
    end,
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
    },
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      keymap = { preset = 'enter' },
      completion = {
        -- Markdown: no automatic popup, but <C-space> still triggers manually.
        menu = {
          auto_show = function(ctx)
            return ctx.trigger.kind == 'manual' or vim.bo.filetype ~= 'markdown'
          end,
        },
        documentation = { auto_show = true },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lsp = { fallbacks = {} },
          path = { fallbacks = {} },
          buffer = {
            min_keyword_length = 3,
            score_offset = -5,
            max_items = 5,
            opts = {
              get_bufnrs = function() return { vim.api.nvim_get_current_buf() } end,
            },
          },
        },
      },
      fuzzy = { implementation = 'prefer_rust' },
    },
  },
  -- Autopairs. mini.pairs only auto-creates `<CR>`/`<BS>` when unmapped, and
  -- blink.cmp applies its `<CR>` accept buffer-locally, falling back to the
  -- global mapping when there is nothing to accept.
  {
    'nvim-mini/mini.pairs',
    opts = {},
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
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
          'stylua',
          'prettier',
          'biome',
          'oxfmt',
          'ruff',
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

      -- LSP keymaps, restored from the old lua/config/lsp.lua. `g`-prefixed goto
      -- stays as before; picker-based ones replace the 0.12 defaults.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local buf = event.buf
          local map = function(keys, rhs, desc)
            vim.keymap.set('n', keys, rhs, { buffer = buf, desc = desc })
          end
          local pick = function(source)
            return function() require('snacks').picker[source]() end
          end

          map('K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, 'Hover')
          vim.keymap.set('i', '<C-s>', function()
            vim.lsp.buf.signature_help({ border = 'rounded' })
          end, { buffer = buf, desc = 'Signature help' })

          map('gd', pick('lsp_definitions'), 'Goto definition')
          map('gD', vim.lsp.buf.declaration, 'Goto declaration')
          map('grr', pick('lsp_references'), 'References')
          map('gri', pick('lsp_implementations'), 'Implementation')
          map('grt', pick('lsp_type_definitions'), 'Type definition')
          map('gO', pick('lsp_symbols'), 'Document symbols')
          map('<leader>ws', pick('lsp_workspace_symbols'), 'Workspace symbols')

          if client and client:supports_method('textDocument/documentHighlight') then
            local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = buf,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = buf,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })
          end

          if client and client:supports_method('textDocument/inlayHint') then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
            end, 'Toggle inlay hints')
          end
        end,
      })
    end,
  },
}, {
  install = { colorscheme = { 'vague' } },
  ui = { border = 'rounded' },
})
