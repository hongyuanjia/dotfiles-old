nnoremap <silent> ]q :<c-u>call utils#CycleQuickfix('cnext', 'cfirst')<CR>
nnoremap <silent> [q :<c-u>call utils#CycleQuickfix('cprev', 'clast')<CR>

nnoremap <silent> ]l :<c-u>call utils#CycleQuickfix('lnext', 'lfirst')<CR>
nnoremap <silent> [l :<c-u>call utils#CycleQuickfix('lprev', 'llast')<CR>

nnoremap <silent> <buffer> q :cclose<bar>:lclose<CR>
nnoremap <buffer> <CR> <CR>

setlocal nowrap