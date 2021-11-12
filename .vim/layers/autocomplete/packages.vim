" all kinds of autocompletion
DeferPlug 'neoclide/coc.nvim', { 'do': { -> coc#util#install()}, 'defer': 200 }

" tags
Plug 'ludovicchabant/vim-gutentags', { 'on': [] }

" LSP symbol and tags Finder
Plug 'liuchengxu/vista.vim', { 'on': [ 'Vista', 'Vista!!' ] }

" insert documentation template
Plug 'kkoomen/vim-doge', { 'do': {-> doge#install()}, 'on': [] }

" snippets
Plug 'honza/vim-snippets'
