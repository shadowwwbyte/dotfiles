" plugin manager im using vim-plug
" https://github.com/junegunn/vim-plug

call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
call plug#end()

set background=dark
colorscheme gruvbox
syntax enable
set hlsearch incsearch ignorecase
set number relativenumber
set showmatch
set smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set termguicolors
set mouse=a
filetype plugin indent on
set autoindent
set expandtab
set clipboard=unnamedplus

