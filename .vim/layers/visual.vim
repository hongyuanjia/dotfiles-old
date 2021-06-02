" Visual helpers ---------------------------------------------------------------

" statusline
Plug 'liuchengxu/eleline.vim'
" enable powerline font
let g:eleline_powerline_fonts = 1

" highlight current word
Plug 'itchyny/vim-cursorword'

" icons support
Plug 'ryanoasis/vim-devicons'

" rainbow parentheses improved
Plug 'luochen1990/rainbow', { 'on': 'RainbowToggle'}

" show indent line
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesToggle' }
let g:indentLine_char='¦'
let g:indentLine_enabled=1
let g:indentLine_color_term=239
let g:indentLine_color_gui='#4A9586'
let g:indentLine_concealcursor='vc'
let g:indentLine_fileTypeExclude=['help', 'startify']

" show search status
Plug 'osyo-manga/vim-anzu', {
    \ 'on': [
    \ '<Plug>(anzu-n-with-echo)',
    \ '<Plug>(anzu-N-with-echo)',
    \ '<Plug>(anzu-star-with-echo)',
    \ '<Plug>(anzu-sharp-with-echo)'
    \ ]
    \ }
" mapping
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

" highlights patterns and ranges for substitute
Plug 'markonm/traces.vim'

