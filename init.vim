call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'sonph/onehalf', {'rtp': 'vim' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'luochen1990/rainbow'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-autoformat/vim-autoformat'
Plug 'moll/vim-bbye'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'kshenoy/vim-signature'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mg979/vim-visual-multi'
Plug 'liuchengxu/vista.vim'
Plug 'ojroques/vim-oscyank'
call plug#end()

filetype plugin indent on
syntax on

runtime macros/matchit.vim

set autoindent
set backspace=indent,eol,start
set hidden
set incsearch
set ruler
set nowrap
set tabstop=4
set copyindent
set shiftwidth=4
set shiftround
set showmatch
set ignorecase
set smartcase
set smarttab
set hlsearch
set incsearch
set expandtab

set history=1000
set undolevels=1000

set pastetoggle=<F2>

set wildmenu

set number relativenumber

let mapleader=","

set t_Co=256
set cursorline
colorscheme onehalfdark
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='onehalfdark'

source ~/.config/nvim/coc.vim

" nnoremap <Leader>b :ls<CR>:b<Space>

set nostartofline
set clipboard=unnamedplus

set autowrite
set autowriteall

nmap <leader>sv :vsplit<cr>
nmap <leader>sh :split<cr>

nmap <leader>1 :NERDTreeToggle<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>m :Marks<cr>
nmap <leader>s :Lines<cr>
nmap <leader>sb :BLines<cr>
nmap <leader>q :Bdelete<cr>
nmap <F3> :Autoformat<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <leader>v :Vista coc<cr>
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP
nnoremap <silent> z. :<C-u>normal! zszH<CR>
vnoremap <leader>c :OSCYank<CR>

set ignorecase

let g:rainbow_active = 1
let g:indent_guides_enable_on_vim_startup = 1

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set rtp+=~/.fzf
nnoremap <c-p> :Files<cr>

if &term =~ '^xterm' || &term =~ '^tmux'
  " Cursor in terminal:
  " Link: https://vim.fandom.com/wiki/Configuring_the_cursor
  " 0 -> blinking block not working in wsl
  " 1 -> blinking block
  " 2 -> solid block
  " 3 -> blinking underscore
  " 4 -> solid underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar

  " normal mode
  let &t_EI .= "\e[1 q"
  " insert mode
  let &t_SI .= "\e[5 q"

  augroup windows_term
    autocmd!
    autocmd VimEnter * silent !echo -ne "\e[1 q"
    autocmd VimLeave * silent !echo -ne "\e[5 q"
  augroup END
endif

autocmd FileType systemverilog setlocal shiftwidth=2 softtabstop=2 expandtab
