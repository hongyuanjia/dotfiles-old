" Window Management ------------------------------------------------------------

" maximize and restore the current window
Plug 'szw/vim-maximizer'
    " do not use the default mapping (F3)
    let g:maximizer_set_default_mapping = 1

" label each window and directly jump to it
Plug 't9md/vim-choosewin'
    " use - to choose window
    nmap - <Plug>(choosewin)
