" startup landing page
Plug 'mhinz/vim-startify'

" key mapping menu when pressing <Space>
Plug 'liuchengxu/vim-which-key', { 'on': [
    \ 'WhichKey', 'WhichKey!',
    \ 'WhichKeyVisual', 'WhichKeyVisual!'
    \ ] }
autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')

" statusline
Plug 'liuchengxu/eleline.vim'

" highlight current word
DeferPlug 'itchyny/vim-cursorword', { 'defer': 500 }

" rainbow parentheses improved
Plug 'luochen1990/rainbow', { 'on': 'RainbowToggle'}

" show indent line
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesToggle' }

" show search status
Plug 'haya14busa/is.vim'
Plug 'osyo-manga/vim-anzu', {
    \ 'on': [
    \ '<Plug>(anzu-n-with-echo)',
    \ '<Plug>(anzu-N-with-echo)',
    \ '<Plug>(anzu-star-with-echo)',
    \ '<Plug>(anzu-sharp-with-echo)'
    \ ]
    \ }

" highlights patterns and ranges for substitute
DeferPlug 'markonm/traces.vim', { 'defer': 500 }

" maximize and restore the current window
Plug 'szw/vim-maximizer', { 'on': 'MaximizerToggle!'}

" label each window and directly jump to it
Plug 't9md/vim-choosewin', { 'on': '<Plug>(choosewin)'}
