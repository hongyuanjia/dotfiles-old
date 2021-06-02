" Markdown TOC
Plug 'mzlogin/vim-markdown-toc', { 'on': ['GenTocGFM', 'GenTocRedcarpet', 'GenTocGitLab', 'UpdateToc', 'RemoveToc'] , 'for' :['markdown', 'rmd'] }

" preview markdown in realtime
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }

" Markdown table editing
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
