" Center horizontally
nnoremap <silent> z. :<C-u>normal! zszH<CR>
" Allow floating terminal navigating
let g:floaterm_keymap_new    = '<leader>tc'
let g:floaterm_keymap_prev   = '<leader>tp'
let g:floaterm_keymap_next   = '<leader>tn'
let g:floaterm_keymap_toggle = '<leader>tt'
let g:floaterm_height        = 0.8
let g:floaterm_width         = 0.8

" Use f to search forward, F to search back
nmap f <Plug>(leap-forward)
vmap f <Plug>(leap-forward)
nmap F <Plug>(leap-backward)
vmap F <Plug>(leap-backward)
" Show telescope
lua require('telescope').load_extension('coc')

" Minimap
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_highlight_search = 1
let g:minimap_highlight_range = 1

" vim-tmux-navigator
" Save all buffers when switching
let g:tmux_navigator_save_on_switch = 2
