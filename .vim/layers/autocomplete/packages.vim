DeferPlug 'neoclide/coc.nvim', { 'do': { -> coc#util#install()}, 'defer': 200 }

" insert documentation template
Plug 'kkoomen/vim-doge', { 'do': {-> doge#install()}, 'on': [] }

" snippets
Plug 'honza/vim-snippets'
