set nocompatible

if isdirectory(expand('~/.vim/bundle'))
  filetype off
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()

  Plugin 'VundleVim/Vundle.vim'
  Plugin 'sjl/tslime.vim'
  Plugin 'scrooloose/nerdtree'
  Plugin 'pangloss/vim-javascript'
  Plugin 'elzr/vim-json'
  Plugin 'cakebaker/scss-syntax.vim'
  Plugin 'hail2u/vim-css3-syntax'
  Plugin 'tikhomirov/vim-glsl'
  Plugin 'groenewege/vim-less'
  Plugin 'plasticboy/vim-markdown'
  Plugin 'Glench/Vim-Jinja2-Syntax'
  Plugin 'ekalinin/Dockerfile.vim'
  Plugin 'cespare/vim-toml'
  Plugin 'rust-lang/rust.vim'
  Plugin 'posva/vim-vue'
  Plugin 'dag/vim-fish'
  Plugin 'mxw/vim-jsx'
  Plugin 'lifepillar/vim-solarized8'
  Plugin 'burner/vim-svelte'
  Plugin 'leafgarland/typescript-vim'
  Plugin 'editorconfig/editorconfig-vim'
  Plugin 'ElmCast/elm-vim'

  call vundle#end()
  filetype plugin indent on
endif

syntax enable
set mouse=a
set laststatus=0
set cursorline
set ruler
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

set background=light
colorscheme solarized8

hi VertSplit guibg=bg guifg='grey'
set fillchars+=vert:│
set wildignore+=*.png,*.gif,*.jpeg,*.jpg,*.pyc,*.o,*.so,*.woff,*.ttf,*.eot,*.svg

" Disable the annoying pause when pressing C-c in a SQL file
let g:ftplugin_sql_omni_key = '<Plug>DisableSqlOmni'

" nerdtree
" --------
nmap <Leader>nt :NERDTreeToggle<CR>
let g:NERDTreeWinSize=35
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=[
  \'\.DS_Store',
  \'\.pyc$',
  \'\.o$',
  \'\.so$',
  \'\.eggs',
  \'\.egg-info',
  \'\.tox',
  \'__pycache__',
  \'node_modules',
  \'site.retry',
\]

" netrw
" -----
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" ctrl-p
" ------
let g:ctrlp_custom_ignore = 'dist\|eggs\|\.egg-info\|target\|node_modules\|DS_Store\|git\|env\|build\|__pycache__'

set rtp+=/usr/share/fzf
nmap <C-P> :FZF<CR>

" tslime
" ------
let g:tslime_ensure_trailing_newlines=1
let g:tslime_normal_mapping='<localleader>t'
let g:tslime_visual_mapping='<localleader>t'
let g:tslime_vars_mapping='<localleader>T'

autocmd FileType gitcommit set colorcolumn=50
autocmd FileType gitcommit set colorcolumn+=72
autocmd FileType rust set colorcolumn=
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

" Terminal stuff taken from :help terminal
autocmd TermOpen * setlocal nonumber norelativenumber
tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Vue specific things
" See https://github.com/posva/vim-vue#faq
autocmd FileType vue syntax sync fromstart
let g:vue_disable_pre_processors=1

" Rust
let g:rustfmt_autosave = 1
