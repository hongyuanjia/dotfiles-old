" trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" using label mode
let g:sneak#label = 1
" case insensitive sneak
let g:sneak#use_ic_scs = 1
" immediately move to the next instance of search
let g:sneak#s_next = 1
" since we use 'on' for lazy loading
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
" visual-mode
xmap s <Plug>Sneak_s
xmap Z <Plug>Sneak_S
" operator-pending-mode
omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S
" remap to use , and ; with f and t
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;

" omap aa <Plug>SidewaysArgumentTextobjA
" xmap aa <Plug>SidewaysArgumentTextobjA
" omap ia <Plug>SidewaysArgumentTextobjI
" xmap ia <Plug>SidewaysArgumentTextobjI
nnoremap <Leader>ah :<C-u>SidewaysLeft<cr>
nnoremap <Leader>al :<C-u>SidewaysRight<cr>

nnoremap <Leader>; :<C-u>Commentary<cr>

nnoremap <Leader>tu :<C-u>UndotreeToggle<cr>
nnoremap <Leader>tm :<C-u>TableModeToggle<cr>

" vim-better-whitespace
nnoremap <Leader>xd :StripWhitespace<CR>
