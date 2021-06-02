" key mapping menu when pressing <Space>
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" statusline
Plug 'liuchengxu/eleline.vim'

" highlight current word
Plug 'itchyny/vim-cursorword'

" icons support
Plug 'ryanoasis/vim-devicons'

" rainbow parentheses improved
Plug 'luochen1990/rainbow', { 'on': 'RainbowToggle'}

" show indent line
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesToggle' }

" show search status
Plug 'osyo-manga/vim-anzu', {
    \ 'on': [
    \ '<Plug>(anzu-n-with-echo)',
    \ '<Plug>(anzu-N-with-echo)',
    \ '<Plug>(anzu-star-with-echo)',
    \ '<Plug>(anzu-sharp-with-echo)'
    \ ]
    \ }

" highlights patterns and ranges for substitute
Plug 'markonm/traces.vim'

" maximize and restore the current window
Plug 'szw/vim-maximizer'

" label each window and directly jump to it
Plug 't9md/vim-choosewin'
