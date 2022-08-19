source ~/.config/nvim/coc.vim

" Set Ctrl-J for copilot
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" Find all references to item
nmap <leader>cr <cmd>Telescope coc references<cr>
" Search all symbols
nmap <leader>cs <cmd>Telescope coc workspace_symbols<cr>
" Normal coc
nmap <leader>c <cmd>Telescope coc<cr>
" Autoformat selection
nmap <F3> :Autoformat<cr>
" See definiton of symbol
nmap <silent> gd <Plug>(coc-definition)
" See description of of all symbols
nmap <leader>v :Vista coc<cr>

lua require('git-conflict').setup()
