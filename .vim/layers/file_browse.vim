" File Editing -----------------------------------------------------------------

" open URL in default web-browser
Plug 'tyru/open-browser.vim', { 'on': ['<Plug>(openbrowser-smart-search)', '<Plug>(openbrowser-open)'] }
    " disable netrw's gx mapping.
    let g:netrw_nogx = 1
    nmap gx <Plug>(openbrowser-smart-search)
    vmap gx <Plug>(openbrowser-smart-search)

" UNIX shell commands in Vim
Plug 'tpope/vim-eunuch'
