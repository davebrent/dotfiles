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
vim.opt.showmode = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.foldenable = false
vim.opt.number = true
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

-- Have a shortcut to disable diagnostics as they are really annoying
function toggleDiagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end
vim.keymap.set('n', '<leader>d', toggleDiagnostics, { silent = true, noremap = true })

-- Automatically create columns for a nice git commit message
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit' },
  callback = function()
    vim.opt.colorcolumn = {50, 72}
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*' },
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end
})

-- Load and configure plugins
require("lazy").setup({
  -- Lazy options
  install = { colorscheme = { 'base16-materia' } },
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
        -- Patched version of materia to match iterm2
        require('base16-colorscheme').setup({
          base00 = '#283137', base01 = '#2c393f', base02 = '#37474f', base03 = '#707880',
          base04 = '#c9ccd3', base05 = '#cdd3de', base06 = '#d5dbe5', base07 = '#ffffff',
          base08 = '#ec5f67', base09 = '#ea9560', base0A = '#ffcc00', base0B = '#8bd649',
          base0C = '#80cbc4', base0D = '#9cdafb', base0E = '#82aaff', base0F = '#ec5f67'
        })
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#707880" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#707880" })
        vim.api.nvim_set_hl(0, "VertSplit", { fg = "#707880" })
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
          '.mypy_cache',
          '.ruff_cache',
          '.pytest_cache',
          'elm-stuff',
          'site.retry',
          'compile_commands.json',
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
      'neovim/nvim-lspconfig',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        vim.lsp.config('rust_analyzer', {
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

        vim.lsp.config('clangd', {
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed'
          },
        })

        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            local bufnr = args.buf
            local opts = { noremap = true, silent = true, buffer = bufnr }

            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format({ async = true })
            end, opts)

            if client and client.name == 'clangd' then
              client.server_capabilities.semanticTokensProvider = nil
              vim.keymap.set('n', '<leader>sh', '<cmd>LspClangdSwitchSourceHeader<CR>', opts)
            end
          end,
        })

        vim.lsp.enable('rust_analyzer')
        vim.lsp.enable('clangd')
      end
    },
  },
})
