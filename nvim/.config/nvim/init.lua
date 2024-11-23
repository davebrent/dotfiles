-- Install lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath})
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Generic key mappings
vim.g.mapleader = '`'
vim.api.nvim_set_keymap('', ';', ':', { noremap = true, silent = false })
vim.api.nvim_set_keymap('', '<C-j>', ':bprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<C-k>', ':bnext<CR>', { noremap = true, silent = true })

-- Generic options
vim.opt.mouse = 'a'
vim.opt.termguicolors = true
vim.opt.laststatus = 0
vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.pastetoggle = '<F2>'
vim.opt.showmode = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.foldenable = false
vim.opt.wildignore:append({
  '*.o',
  '*.a',
  '*.obj',
  '*.pyc',
  '*.png',
  '*.gif',
  '*.jpeg',
  '*.jpg',
  '*.so',
  '*.woff',
  '*.ttf',
  '*.eot',
  '*.svg',
  '*/node_modules/*',
  '*/.git/*'
})

-- Load and configure plugins
require("lazy").setup({
  -- Lazy options
  install = { colorscheme = { 'base16-harmonic-light' } },
  checker = {
    enabled = true,
    notify = false,
  },

  -- Plugins
  spec = {
    {
      'RRethy/nvim-base16',
      lazy = false,
      config = function()
        vim.cmd.colorscheme('base16-harmonic-light')
      end,
    },

    {
      'preservim/nerdtree',
      cmd = { 'NERDTreeToggle', 'NERDTreeFind' },
      keys = {
        {'<leader>nt', ':NERDTreeToggle<CR>', desc = 'Toggle NERDTree'},
      },
      opts = {
        NERDTreeWinSize = 25,
        NERDTreeMinimalUI = 1,
        NERDTreeShowHidden = 1,
        NERDTreeIgnore = {
          '.DS_Store',
          '.pyc$',
          '.spv$',
          '.eggs',
          '.egg-info',
          '.tox',
          '__pycache__',
          'elm-stuff',
          'site.retry',
        }
      },
      config = function(_, opts)
        for k, v in pairs(opts) do
          vim.g[k] = v
        end
      end,
    },

    {
      'junegunn/fzf',
      build = './install --bin',
      keys = {
        {'<C-P>', ':FZF<CR>', desc = 'Fuzzy search'},
      },
      event = 'VimEnter',
      config = function (_, _)
        vim.opt.rtp:prepend('/opt/homebrew/bin/fzf')
      end
    },

    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = {'rust', 'python', 'cpp'},
          sync_install = true,
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = { 'cpp' }, -- Currently broken/buggy
          },
        })
      end
    },

    {
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local lspconfig = require('lspconfig')

        lspconfig.rust_analyzer.setup({
          on_attach = function(_, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format({ async = true })
            end, opts)
          end,
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
                command = 'clippy',
              },
              cargo = {
                allFeatures = true,
              },
            },
          },
        })

        lspconfig.clangd.setup({
          cmd = {'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed'},
          on_attach = function(_, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', '<leader>sh', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format({ async = true })
            end, opts)
          end,
        })
      end
    },
  },
})
