" open URL in default web-browser
Plug 'tyru/open-browser.vim', { 'on': ['<Plug>(openbrowser-smart-search)', '<Plug>(openbrowser-open)'] }

" UNIX shell commands in Vim
Plug 'tpope/vim-eunuch', {'on':
    \ [ 'Mkdir',
    \   'Rename',
    \   'Unlink',
    \   'Delete',
    \   'Move',
    \   'Chmod',
    \   'Cfind',
    \   'Clocate',
    \   'Lfine',
    \   'Llocate',
    \   'SudoEdit',
    \   'SudoWrite',
    \   'Wall',
    \   'W'
    \ ]}
