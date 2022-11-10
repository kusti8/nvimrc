" No clipboard delete and paste
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

" Use to remove indent and enter paste toggle
set pastetoggle=<F2>

" Allow system clipboard
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif
" Show cheatsheet
lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

" Use ufo folding/collapsing
lua << EOF
    vim.wo.foldcolumn = '1'
    vim.wo.foldlevel = 99 -- feel free to decrease the value
    vim.wo.foldenable = true
    require('ufo').setup()
EOF

" setup git-conflict
lua << EOF
    require('git-conflict').setup()
EOF
