set nocompatible

if isdirectory(expand('~/.vim/bundle'))
  filetype off
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()

  Plugin 'VundleVim/Vundle.vim'
  Plugin 'kana/vim-operator-user'
  Plugin 'rhysd/vim-clang-format'
  Plugin 'scrooloose/nerdtree'
  Plugin 'tpope/vim-fugitive'
  Plugin 'airblade/vim-gitgutter'
  Plugin 'bling/vim-airline'
  Plugin 'bronson/vim-trailing-whitespace'
  Plugin 'bufkill.vim'
  Plugin 'pangloss/vim-javascript'
  Plugin 'cakebaker/scss-syntax.vim'
  Plugin 'hail2u/vim-css3-syntax'
  Plugin 'tikhomirov/vim-glsl'
  Plugin 'sophacles/vim-processing'
  Plugin 'groenewege/vim-less'
  Plugin 'plasticboy/vim-markdown'
  Plugin 'kien/ctrlp.vim'
  Plugin 'mileszs/ack.vim'
  Plugin 'mkarmona/colorsbox'

  call vundle#end()
  filetype plugin indent on
endif

set background=dark
highlight ColorColumn guibg=Gray
let g:rehash256=1
let &t_Co=256

colorscheme colorsbox-material

syntax enable
set mouse=a
set laststatus=2
set cursorline
set colorcolumn+=80
set ruler
set number
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

set hidden

let g:netrw_list_hide='.*\.pyc$'

let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled=1

let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$', '.DS_Store', '\.o$', '\.so$']
let NERDTreeMinimalUI=1
let g:NERDTreeWinSize=20
nmap <Leader>nt :NERDTreeToggle<CR>

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git|env'

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

command! PrettifyJSON execute ":%!python -m json.tool"
