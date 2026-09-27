" plugin manager im using vim-plug
" https://github.com/junegunn/vim-plug
" :PlugInstall

call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
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

nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-f> :NERDTreeFind<CR>
