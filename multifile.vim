" Vertical and horizontal split keymaps
nmap <leader>sv :vsplit<cr>
nmap <leader>sh :split<cr>

" Set keymap for nvim-tree
nmap <leader>1 :NvimTreeToggle<cr>
" Setup nvim tree
" Set global change directory
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

" Set keymaps for buffers, finding files, all search, and marks
nmap <leader>b <cmd>Telescope buffers<cr>
nnoremap <c-p> <cmd>Telescope find_files<cr>
nmap <leader>g <cmd>Telescope live_grep<cr>
nmap <leader>m <cmd>Telescope marks<cr>
" Close file
nmap <leader>q :Bdelete<cr>

" Better split resizing
noremap <silent> <C-S-Left> :vertical resize +1<CR>
noremap <silent> <C-S-Right> :vertical resize -1<CR>
noremap <silent> <C-S-Up> :horizontal resize +1<CR>
noremap <silent> <C-S-Down> :horizontal resize -1<CR>

" Use sessions automatically on start
let g:prosession_on_startup = 1
noremap <leader>p :Prosession<cr>

" Enable focus automatic pane/split management
lua require("focus").setup()
