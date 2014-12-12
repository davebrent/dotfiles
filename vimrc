set nocompatible

if isdirectory(expand('~/.vim/bundle'))
  filetype off
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()

  Plugin 'editorconfig/editorconfig-vim'
  Plugin 'bufkill.vim'
  Plugin 'tpope/vim-fugitive'
  Plugin 'airblade/vim-gitgutter'
  Plugin 'bling/vim-airline'
  Plugin 'bronson/vim-trailing-whitespace'
  Plugin 'scrooloose/nerdtree'
  Plugin 'croaker/mustang-vim'
  Plugin 'pangloss/vim-javascript'
  Plugin 'cakebaker/scss-syntax.vim'
  Plugin 'groenewege/vim-less'
  Plugin 'hail2u/vim-css3-syntax'
  Plugin 'tikhomirov/vim-glsl'
  Plugin 'sophacles/vim-processing'

  call vundle#end()
  filetype plugin indent on
endif

let mapleader=','
syntax enable
set laststatus=2
set cursorline
set colorcolumn+=80
set ruler
set number
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
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
set guifont=Consolas:h14
set wildignore=*.pyc
set noerrorbells
set novisualbell
set autoread
set pastetoggle=<F2>
set showmode
set background=dark
highlight ColorColumn guibg=Gray
autocmd! GUIEnter * set vb t_vb=
let g:rehash256=1
let &t_Co=256

try
  colorscheme mustang
catch
  colorscheme default
endtry

let g:netrw_list_hide='.*\.pyc$'

let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$', '.DS_Store']
let NERDTreeMinimalUI=1
nmap <Leader>nt :NERDTreeToggle<CR>

let g:airline#extensions#tabline#enabled=1

" Fix highlighting certain keywords
augroup VimCSS3Syntax
  autocmd!
  autocmd FileType css setlocal iskeyword+=-
augroup END

autocmd FileType gitcommit set colorcolumn=50
autocmd FileType gitcommit set colorcolumn+=72

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

" Work
autocmd Filetype javascript setlocal colorcolumn=100
autocmd Filetype html setlocal colorcolumn=100
autocmd Filetype css setlocal colorcolumn=100
