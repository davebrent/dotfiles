set nocompatible

if isdirectory(expand('~/.vim/bundle'))
  filetype off
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()

  Plugin 'VundleVim/Vundle.vim'
  Plugin 'kana/vim-operator-user'
  Plugin 'rhysd/vim-clang-format'
  Plugin 'scrooloose/nerdtree'
  Plugin 'bronson/vim-trailing-whitespace'
  Plugin 'bufkill.vim'
  Plugin 'pangloss/vim-javascript'
  Plugin 'cakebaker/scss-syntax.vim'
  Plugin 'hail2u/vim-css3-syntax'
  Plugin 'tikhomirov/vim-glsl'
  Plugin 'groenewege/vim-less'
  Plugin 'plasticboy/vim-markdown'
  Plugin 'kien/ctrlp.vim'
  Plugin 'mileszs/ack.vim'
  Plugin 'Glench/Vim-Jinja2-Syntax'
  Plugin 'sjl/tslime.vim'
  Plugin 'ekalinin/Dockerfile.vim'
  Plugin 'cespare/vim-toml'
  Plugin 'chriskempson/base16-vim'
  Plugin 'rust-lang/rust.vim'
  Plugin 'posva/vim-vue'
  Plugin 'mxw/vim-jsx'
  Plugin 'tpope/vim-fugitive'
  Plugin 'arcticicestudio/nord-vim'

  call vundle#end()
  filetype plugin indent on
endif

syntax enable
set mouse=a
set laststatus=0
set cursorline
set colorcolumn+=80
set ruler
set nonumber
set smartindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set showcmd
set backspace=indent,eol,start
set autoindent
set showmatch
set ignorecase
set hlsearch
set incsearch
set nobackup
set noswapfile
set guifont=Source_Code_Pro:h12
set wildignore=*.pyc
set noerrorbells
set novisualbell
set autoread
set pastetoggle=<F2>
set showmode
set clipboard=unnamed
set clipboard+=unnamedplus
set hidden
set noruler
set noshowcmd
set nofoldenable
set termguicolors

set background=dark
colorscheme nord
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

set wildignore+=*.png,*.gif,*.jpeg,*.jpg,*.pyc,*.o,*.so,*.woff,*.ttf,*.eot

" Disable the annoying pause when pressing C-c in a SQL file
let g:ftplugin_sql_omni_key = '<Plug>DisableSqlOmni'

" nerdtree
" --------
nmap <Leader>nt :NERDTreeToggle<CR>
let g:NERDTreeWinSize=20
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=[
  \'\.DS_Store',
  \'\.pyc$',
  \'\.o$',
  \'\.so$',
  \'\.git',
  \'\.eggs',
  \'\.egg-info',
  \'\.tox',
  \'env',
  \'__pycache__',
\]

" ctrl-p
" ------
let g:ctrlp_custom_ignore = 'dist\|eggs\|\.egg-info\|target\|node_modules\|DS_Store\|git\|env\|build\|__pycache__'

" tslime
" ------
let g:tslime_ensure_trailing_newlines=1
let g:tslime_normal_mapping='<localleader>t'
let g:tslime_visual_mapping='<localleader>t'
let g:tslime_vars_mapping='<localleader>T'

" Fix highlighting certain keywords
augroup VimCSS3Syntax
  autocmd!
  autocmd FileType css setlocal iskeyword+=-
augroup END

autocmd FileType gitcommit set colorcolumn=50
autocmd FileType gitcommit set colorcolumn+=72
autocmd FileType rust set colorcolumn+=100
autocmd FileType markdown set colorcolumn=

nnoremap ; :

" Navigate between tabs
map <C-j> :bprev<CR>
map <C-k> :bnext<CR>
map <C-l> :tabn<CR>

" Exiting out of block insert mode doesn't cancel the insert
vnoremap <C-c> <Esc>

" No ex-mode
nnoremap Q <nop>

" Copy & paste
nnoremap <F2> :set invpaste paste?<CR>
nnoremap <Leader>vv <F2>"+p<F2>

command! PrettifyJSON execute ":%!python -m json.tool"

set fillchars+=vert:\|
