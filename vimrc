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
  Plugin 'tomasr/molokai'
  Plugin 'croaker/mustang-vim'
  Plugin 'w0ng/vim-hybrid'
  Plugin 'pangloss/vim-javascript'
  Plugin 'cakebaker/scss-syntax.vim'
  Plugin 'groenewege/vim-less'
  Plugin 'hail2u/vim-css3-syntax'
  Plugin 'tikhomirov/vim-glsl'
  Plugin 'sophacles/vim-processing'

  call vundle#end()
  filetype plugin indent on
endif

" Settings
" ========

let mapleader=','
syntax enable
set laststatus=2 " Always show the statusline
set cursorline " highlight the cursor line
set colorcolumn+=80 " show a ruler
set ruler
set number
set smartindent
set tabstop=4 " Make a tab four sapces
set softtabstop=4
set shiftwidth=4 " Indent four sapces
set expandtab " Use spaces not tabs
set showcmd " show <leader> when pressed in bottom right
set backspace=indent,eol,start " allow backspacing over everything
set autoindent " Alwats set autoindenting on
set showmatch " Set show matching parenthesis
set ignorecase " Ignore case when searching
set hlsearch " Highlight search terms
set incsearch " Show search matches as you type
set nobackup " Disable backups and swap files
set noswapfile
set guifont=Consolas:h14
set wildignore=*.pyc
set noerrorbells
set novisualbell
set autoread " Set to auto read when a file is changed from the outside
set pastetoggle=<F2>
set showmode
set background=dark
highlight ColorColumn guibg=Gray
autocmd! GUIEnter * set vb t_vb= " Disable error bells?
let g:rehash256=1
let &t_Co=256

try
  colorscheme mustang
catch
  colorscheme default
endtry

let g:netrw_list_hide='.*\.pyc$'

let NERDTreeIgnore=['\.pyc$']
nmap <Leader>nt :NERDTreeToggle<CR>

let g:airline#extensions#tabline#enabled=1

"" Fix highlighting certain keywords
augroup VimCSS3Syntax
  autocmd!
  autocmd FileType css setlocal iskeyword+=-
augroup END

"" Work specific
autocmd Filetype javascript setlocal colorcolumn=100
autocmd Filetype html setlocal colorcolumn=100
autocmd Filetype css setlocal colorcolumn=100

autocmd FileType gitcommit set colorcolumn=50
autocmd FileType gitcommit set colorcolumn+=72

" Key Mappings
" ============

nnoremap ; :

" Navigate between tabs
map <C-j> :bprev<CR>
map <C-k> :bnext<CR>
map <C-l> :tabn<CR>

" So exiting out of block insert mode doesn't cancel the insert
vnoremap <C-c> <Esc>

" No ex-mode
nnoremap Q <nop>

" Copy & paste
nnoremap <F2> :set invpaste paste?<CR>
nnoremap <Leader>vv <F2>"+p<F2>
