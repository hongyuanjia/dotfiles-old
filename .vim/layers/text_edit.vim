" Text/Code Editing ------------------------------------------------------------

" add/remove comments
Plug 'tpope/vim-commentary'

" add surround brackets
Plug 'machakann/vim-sandwich'

" more text objects
Plug 'wellle/targets.vim'

" multi-cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" auto pair brackets
Plug 'cohama/lexima.vim'

" highlight unique character targets for f/F and t/T motions
Plug 'unblevable/quick-scope'
    " trigger a highlight in the appropriate direction when pressing these keys:
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" move using s and S with two characters
Plug 'justinmk/vim-sneak'
    " using label mode
    let g:sneak#label = 1
    " case insensitive sneak
    let g:sneak#use_ic_scs = 1
    " immediately move to the next instance of search
    let g:sneak#s_next = 1
    " remap to use , and ; with f and t
    map gS <Plug>Sneak_,
    map gs <Plug>Sneak_;

" align
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" show tree of all options for current buffer
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" move function arguments positions
Plug 'AndrewRadev/sideways.vim', { 'on': ['SidewaysLeft', 'SidewaysRight'] }
    omap aa <Plug>SidewaysArgumentTextobjA
    xmap aa <Plug>SidewaysArgumentTextobjA
    omap ia <Plug>SidewaysArgumentTextobjI
    xmap ia <Plug>SidewaysArgumentTextobjI
    nnoremap <c-h> :SidewaysLeft<cr>
    nnoremap <c-l> :SidewaysRight<cr>

" show mark label
Plug 'kshenoy/vim-signature'

" highlight and remove whitespace
Plug 'ntpeters/vim-better-whitespace', { 'on': 'StripWhitespace' }
