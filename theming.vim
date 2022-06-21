" show relative numbers
set number relativenumber

" set width of signs (like git) to auto
set signcolumn=auto

" set only one status bar for all vim
set laststatus=3

set cmdheight=0

" set number of colors in terminal
set t_Co=256
" highlight the current line
set cursorline
" use onehalf theme
colorscheme nord
" use airline in tmux
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='nord_minimal'
" only show filename in titlebar
let g:airline#extensions#tabline#fnamemod = ':t'

" Set rainbow brackets
let g:rainbow_active = 1
" Show indent guides
let g:indent_guides_enable_on_vim_startup = 1

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

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

" Git signs setup
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
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
EOF
