" add/remove comments
Plug 'tpope/vim-commentary'

" add surround brackets
DeferPlug 'machakann/vim-sandwich', { 'on': 200 }

" change naming style
Plug 'tpope/vim-abolish', { 'on': '<Plug>(abolish-coerce-word)' }

" more text objects
DeferPlug 'wellle/targets.vim', { 'on': 200 }

" multi-cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" auto pair brackets
Plug 'cohama/lexima.vim'

" highlight unique character targets for f/F and t/T motions
Plug 'unblevable/quick-scope'

" move using s and S with two characters
Plug 'justinmk/vim-sneak', { 'on': [ '<Plug>Sneak_s', '<Plug>Sneak_S' ] }

" align
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" show tree of all options for current buffer
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" move function arguments positions
Plug 'AndrewRadev/sideways.vim', { 'on': ['SidewaysLeft', 'SidewaysRight'] }

" show mark label
DeferPlug 'kshenoy/vim-signature', { 'defer': 200 }

" highlight and remove whitespace
Plug 'ntpeters/vim-better-whitespace', { 'on': 'StripWhitespace' }
