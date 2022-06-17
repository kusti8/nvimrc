call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'sonph/onehalf', {'rtp': 'vim' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'luochen1990/rainbow'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'moll/vim-bbye'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
" Plug 'kshenoy/vim-signature'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mg979/vim-visual-multi'
Plug 'liuchengxu/vista.vim'
Plug 'ojroques/vim-oscyank'
Plug 'jez/vim-better-sml'
Plug 'ggandor/leap.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'machakann/vim-sandwich'
Plug 'folke/which-key.nvim'
Plug 'wellle/targets.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'fannheyward/telescope-coc.nvim'
Plug 'sudormrfbin/cheatsheet.nvim'
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

set history=10000
set undolevels=10000
set undodir=~/.config/nvim/undodir
set undofile

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

set signcolumn=auto

" nnoremap <Leader>b :ls<CR>:b<Space>

set nostartofline
set clipboard=unnamedplus

set autowrite
set autowriteall

nmap <leader>sv :vsplit<cr>
nmap <leader>sh :split<cr>

nmap <leader>1 :NvimTreeToggle<cr>
nmap <leader>b <cmd>Telescope buffers<cr>
nnoremap <c-p> <cmd>Telescope find_files<cr>
nmap <leader>g <cmd>Telescope live_grep<cr>
nmap <leader>m <cmd>Telescope marks<cr>
nmap <leader>cr <cmd>Telescope coc references<cr>
nmap <leader>q :Bdelete<cr>
nmap <leader>cs <cmd>Telescope coc workspace_symbols<cr>
nmap <leader>c <cmd>Telescope coc<cr>
nmap <F3> :Autoformat<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <leader>v :Vista coc<cr>
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP
nnoremap <silent> z. :<C-u>normal! zszH<CR>

set ignorecase

let g:rainbow_active = 1
let g:indent_guides_enable_on_vim_startup = 1

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" set rtp+=~/.fzf

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
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif
augroup vimbettersml
  au!

  " ----- Keybindings -----

  au FileType sml nnoremap <silent> <buffer> <leader>t :SMLTypeQuery<CR>
  au FileType sml nnoremap <silent> <buffer> gd :SMLJumpToDef<CR>

  " open the REPL terminal buffer
  au FileType sml nnoremap <silent> <buffer> <leader>is :SMLReplStart<CR>
  " close the REPL (mnemonic: k -> kill)
  au FileType sml nnoremap <silent> <buffer> <leader>ik :SMLReplStop<CR>
  " build the project (using CM if possible)
  au FileType sml nnoremap <silent> <buffer> <leader>ib :SMLReplBuild<CR>
  " for opening a structure, not a file
  au FileType sml nnoremap <silent> <buffer> <leader>io :SMLReplOpen<CR>
  " use the current file into the REPL (even if using CM)
  au FileType sml nnoremap <silent> <buffer> <leader>iu :SMLReplUse<CR>
  " clear the REPL screen
  au FileType sml nnoremap <silent> <buffer> <leader>ic :SMLReplClear<CR>
  " set the print depth to 100
  au FileType sml nnoremap <silent> <buffer> <leader>ip :SMLReplPrintDepth<CR>

  " ----- Other settings -----

  " Uncomment to try out conceal characters
  "au FileType sml setlocal conceallevel=2

  " Uncomment to try out same-width conceal characters
  "let g:sml_greek_tyvar_show_tick = 1
augroup END
let g:rainbow_conf = {
\	'separately': {
\		'sml': {
\			'parentheses': ['start=/\v\(\ze[^\*]/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\		},
\	}
\}
let g:sml_auto_create_def_use='always'
lua << EOF
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
EOF
nmap f <Plug>(leap-forward)
vmap f <Plug>(leap-forward)
nmap F <Plug>(leap-backward)
vmap F <Plug>(leap-backward)
lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
lua require('telescope').load_extension('coc')
lua << EOF
    require'nvim-tree'.setup {
        actions = {
            change_dir = {
                enable = true,
                global = true
            }
        }
    }
EOF
