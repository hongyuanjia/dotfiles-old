"  __  ____   ____     _____ __  __ ____   ____
" |  \/  \ \ / /\ \   / /_ _|  \/  |  _ \ / ___|
" | |\/| |\ V /  \ \ / / | || |\/| | |_) | |
" | |  | | | |    \ V /  | || |  | |  _ <| |___
" |_|  |_| |_|     \_/  |___|_|  |_|_| \_\\____|
"

" Author: @hongyuanjia
" Date: 2021-02-24

set runtimepath^=~/.vim

" Initialize {{{
if ! filereadable(expand('~/.vim/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ~/.vim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ~/.vim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif
" }}}

" Load Plugins {{{
call plug#begin('~/.vim/plugged')

" fzf finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Startup
Plug 'mhinz/vim-startify'

" Show mark label
Plug 'kshenoy/vim-signature'

" Show whitespace
Plug 'ntpeters/vim-better-whitespace', { 'on': 'StripWhitespace' }

" Show search status
Plug 'osyo-manga/vim-anzu'

" Git integration
" Main
Plug 'tpope/vim-fugitive'
" Git commit browser
Plug 'rbong/vim-flog', { 'on': ['Flog'] }
" Gbrowser
Plug 'tpope/vim-rhubarb'

" Maximize and restore the current window
Plug 'szw/vim-maximizer'

" Text editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'Julian/vim-textobj-brace'
Plug 'AndrewRadev/sideways.vim'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'cohama/lexima.vim'
Plug 'rhysd/vim-grammarous'
Plug 'unblevable/quick-scope'
Plug 'justinmk/vim-sneak'

" R
Plug 'jalvesaq/Nvim-R', {'for': ['r', 'rmd']}
Plug 'mllg/vim-devtools-plugin', { 'for': ['r', 'rmd', 'rnoweb']}
Plug 'jalvesaq/R-Vim-runtime', {'for': ['r', 'rmd']}
Plug 'vim-pandoc/vim-pandoc-syntax',  {'for': ['rmd', 'markdown']}

" Insert documentation template
Plug 'kkoomen/vim-doge'

" LaTex
Plug 'lervag/vimtex', {'for': ['tex', 'rmd']}

" Stan syntax highlighting
Plug 'maverickg/stan.vim'

" LSP finder Finder
Plug 'liuchengxu/vista.vim'

" Open URL in default web-browser
Plug 'tyru/open-browser.vim'

" For better looking
Plug 'ryanoasis/vim-devicons'

" For IM switching
Plug 'rlue/vim-barbaric'

" Key menu
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" Autocompletion
Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install()} }

" vimscript lsp
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'

" grepper
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

" Colorscheme
Plug 'liuchengxu/space-vim-theme'

" Status line
Plug 'itchyny/lightline.vim'

" Highlight current word
Plug 'RRethy/vim-illuminate'

" Align
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" Rename a buffer within Vim
Plug 'danro/rename.vim', { 'on' : 'Rename' }

" Refer to https://github.com/junegunn/dotfiles  vimrc
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'vifm/vifm.vim'

" Snippets
Plug 'honza/vim-snippets'

" Rainbow Parentheses Improved
Plug 'luochen1990/rainbow', { 'on': 'RainbowToggle'}

" Auto change working directory
Plug 'airblade/vim-rooter'

" Show indent line
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesToggle' }

" Open dir of current file
Plug 'justinmk/vim-gtfo'

" Delete buffers and close files without closing windows
Plug 'moll/vim-bbye', { 'on': ['Bdelete', 'Bwipeout'] }

" Markdown
Plug 'mzlogin/vim-markdown-toc', { 'on': ['GenTocGFM', 'GenTocRedcarpet', 'GenTocGitLab', 'UpdateToc', 'RemoveToc'] , 'for' :['markdown', 'rmd'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }

" LaTeX preview
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" EnergyPlus IDF syntax highlighting
Plug 'mitchpaulus/energyplus-vim', {'for' : 'idf' }

" Note taking
Plug 'lervag/wiki.vim'

" Window Management
Plug 't9md/vim-choosewin'

call plug#end()
" }}}

" Better Defaults {{{

" Always use utf-8 encoding
set langmenu=en_US.UTF-8
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8

" Use gui colors in terminal if available
if has('termguicolors')
    set termguicolors
endif

" Theme
set background=dark
colorscheme space_vim_theme

" Enable syntax highlight
syntax on

" Enable filetype plugins
filetype plugin indent on

" Copy indent from current line when starting a new line
set autoindent

" Do not wrap long lines
set nowrap

" Change buffer without saving
set hidden

" Disable fold when opening
set nofoldenable

" Disable backup
set nobackup
set noswapfile

" Set undo directory
if has('persistent_undo')
    set undofile
    if !isdirectory($HOME.'/.vim/undo')
        silent call mkdir($HOME.'/.vim/undo', 'p')
    endif
    set undodir=$HOME/.vim/undo//,.
endif

" Set English word dictionary
set dictionary+=$HOME/.vim/dict/english.dic

" Backspace can go up above
set backspace=indent,eol,start

" Do not display information in preview window
set complete-=i

if !has("nvim")
    " Set Chinese fonts
    set guifont=DejaVuSansMono\ NF:h12
    set guifontwide=SimHei:h12

    " Disable GUI menu
    au GUIEnter * simalt ~x
    set guioptions-=m
    set guioptions-=r        " Hide the right scrollbar
    set guioptions-=L        " Hide the left scrollbar
    set guioptions-=T
    set guioptions-=e
endif

" No annoying sound on errors
set noerrorbells
set novisualbell
set visualbell t_vb=

" Always show tabline
set showtabline=2

" Use 4 spaces to insert a Tab
set smarttab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Do not treat numbers that starts with a zero to be octal
set nrformats-=octal

" Maximum width of text that is being inserted
set textwidth=80

" Show special characters
set list!
set listchars=tab:>\ ,trail:~,extends:>,precedes:<,nbsp:+

" Format options
set formatoptions+=B " Don't insert a space before or after a multi-byte when join
set formatoptions+=m " Multibyte line breaking
set formatoptions+=j " Remove a comment leader when joining
set formatoptions+=q " New line will start with a commen leader
set formatoptions+=n " When formatting text, recognize numbered lists
set formatoptions-=r " Do not insert the current comment leader
set formatoptions-=t " Do not auto format text

" Enable relative number
set number
set relativenumber

" Enable cursor line
set cursorline

" Always open new windows in the right bottom
set splitright
set splitbelow

" Ignore case when searching
set ignorecase

" Use smart case
set smartcase

" Show matches on the fly when searching
set incsearch

" Do not refresh when running macros
set lazyredraw

" Always show the status line
set laststatus=2

" Show the line and column number of the cursor position
set ruler

" Show completions of Ex command
set wildmenu

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=5

" The minimal number of screen columns to keep to the left and to the right of the cursor
set sidescrolloff=5

" Auto read modified files
set autoread

" Number of histories to store
set history=1000

" Max number of tab pages to open
set tabpagemax=50

" Do not store options and mappings when saving sessions
set sessionoptions-=options
set viewoptions-=options

" Use system clipboard as the default
set clipboard=unnamed,unnamedplus

" Always show signcolumns
set signcolumn=yes

" Use PowerShell as the default shell
" if has('win32')
"     set shell=powershell.exe
"     set shellcmdflag=-NoProfile\ -NoLogo\ -NonInteractive\ -Command
"     set shellpipe=|
"     set shellredir=>
" endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
    set t_Co=16
endif

" for different cursor shapes
" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Jump to the last position when reopen a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Move through wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Toggle folding: \
nnoremap \ za
vnoremap \ za

" Picked from https://github.com/tpope/vim-unimpaired
" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" Tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" Visual select to beginning or end
vnoremap H ^
vnoremap L $

" Jump to beginning or end
nnoremap H ^
nnoremap L $

" Use Y to yank to the end of line
nnoremap Y y$
vnoremap Y "+y

" Indentation
nnoremap < <<
nnoremap > >>

" Visual shifting: <>
vnoremap < <gv
vnoremap > >gv

" Always show the matched in center
nnoremap n nzz
nnoremap N Nzz

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-^> <C-o><C-^>

" <Leader>c Close quickfix/location window
nnoremap <leader>q :cclose<bar>lclose<cr>

" Readline-style key bindings in command-line (excerpt from rsi.vim)
cnoremap        <C-A> <Home>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap        <M-b> <S-Left>
cnoremap        <M-f> <S-Right>
silent! exe "set <S-Left>=\<Esc>b"
silent! exe "set <S-Right>=\<Esc>f"

" Manipulate font size, from tpope
command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

" Terminal keybindings
tnoremap <Esc> <C-\><C-n>
tnoremap <M-[> <Esc>
tnoremap <C-v><Esc> <Esc>
tnoremap <c-w>h <c-\><c-n><c-w>h
tnoremap <c-w>j <c-\><c-n><c-w>j
tnoremap <c-w>k <c-\><c-n><c-w>k
tnoremap <c-w>l <c-\><c-n><c-w>l

" Enable clipboard in WSL
" https://superuser.com/a/1557751
function! Is_WSL() abort
  let proc_version = '/proc/version'
  return filereadable(proc_version)
        \  ? !empty(filter(
        \    readfile(proc_version, '', 1), { _, val -> val =~? 'microsoft' }))
        \  : v:false
endfunction

if Is_WSL()
    let g:clipboard = {
          \   'name': 'win32yank-wsl',
          \   'copy': {
          \      '+': 'win32yank.exe -i --crlf',
          \      '*': 'win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o --lf',
          \      '*': 'win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 0,
          \ }
endif
" }}}

" Plugins Specific {{{
autocmd FileType vim setlocal foldmethod=marker
autocmd FileType vim setlocal foldmarker={{{,}}}

" vim-choosewin {{{
nmap  -  <Plug>(choosewin)
" }}}

" vim-maximizer {{{
" Do not use the default mapping (F3)
let g:maximizer_set_default_mapping = 1
" }}}

" lightline {{{
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head'
    \ },
    \ 'colorscheme': 'darcula',
    \ }
" }}}

" Coc.nvim {{{
" fix the most annoying bug that coc has
" silent! au BufEnter,BufRead,BufNewFile * silent! unmap if
let g:coc_config_home = $HOME.'/.vim'
let g:coc_global_extensions = [
    \ 'coc-dictionary',
    \ 'coc-git',
    \ 'coc-gitignore',
    \ 'coc-json',
    \ 'coc-lists',
    \ 'coc-r-lsp',
    \ 'coc-vimlsp',
    \ 'coc-word',
    \ 'coc-yank',
    \ 'coc-snippets'
    \ ]
" }}}

" undotree {{{
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
function g:Undotree_CustomMap()
    nmap <buffer> K <plug>UndotreeNextState
    nmap <buffer> j <plug>UndotreePreviousState
    nmap <buffer> K 5<plug>UndotreeNextState
    nmap <buffer> J 5<plug>UndotreePreviousState
endfunction
" }}}

" vim-root {{{
"  Stop echoing
let g:rooter_silent_chdir = 1

" Change to file's directory when vim-rooter failed
let g:rooter_change_directory_for_non_project_files = 'current'
" }}}

" indentLine {{{
let g:indentLine_char='¦'
let g:indentLine_enabled=1
let g:indentLine_color_term=239
let g:indentLine_color_gui = '#4A9586'
let g:indentLine_concealcursor='vc'      " default 'inc'
let g:indentLine_fileTypeExclude = ['help', 'startify']
" }}}

" vim-markdown-toc {{{
let g:vmt_auto_update_on_save = 0
let g:vmt_dont_insert_fence = 0
let g:vim_markdown_toc_autofit = 1
let g:vmt_fence_text = get(g:, 'g:vmt_fence_text', 'TOC')
let g:vmt_fence_closing_text = get(g:, 'g:vmt_fence_closing_text', '/TOC')
" }}}

" sideways {{{
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI
" }}}

" vimtex {{{
let g:vimtex_fold_enabled=1
if has("win32")
    let g:vimtex_view_general_viewer="SumatraPDF"
endif
" if has('nvim')
"     g:vimtex_compiler_progname = 'nvr'
" endif
" }}}

" vim-markdown {{{
" Turn off most of the features
let g:vim_markdown_override_foldtext=0
let g:vim_markdown_no_default_key_mappings=1
let g:vim_markdown_emphasis_multiline=0
let g:vim_markdown_conceal=0
let g:vim_markdown_frontmatter=1
let g:vim_markdown_new_list_item_indent=0
let g:vim_markdown_math = 0
" }}}

" Nvim-R {{{
let r_syntax_folding = 1
" do not update $HOME
if has('win32')
    let R_set_home_env = 0
endif
let r_indent_align_args = 0
let rmd_syn_hl_chunk = 1
" not losing focus every time that you generate the pdf
let R_openpdf = 1
let R_nvimpager = "horizontal"
" open html output
let R_openhtml = 1
let R_objbr_opendf = 0
let R_objbr_openlist = 0
let Rout_more_colors = 1
" show a preview window of function arguments description and arguments
let R_commented_lines = 1
" clear R Console line before sending commands~
let R_source_args = "print.eval = TRUE, encoding = 'UTF-8', echo = TRUE"
" Auto quit R when close Vim
autocmd VimLeave * if exists("g:SendCmdToR") && string(g:SendCmdToR) != "function('SendCmdToR_fake')" | call RQuit("nosave") | endif
autocmd FileType rnoweb let b:rplugin_non_r_omnifunc = "g:omnifunc=vimtex#complete#omnifunc"
let R_latex_build_dir = 'build'
let R_texerr=1
let R_assign_map="<M-->"
if has("win32") && !has("nvim")
    let R_external_term = 1
endif
let R_debug = 0
" let R_args = ['--quiet', '--no-save', '-d', 'gdb']
" let R_args = ['--quiet', '--no-save', '--debugger=valgrind']
" }}}

" vim-which-key {{{
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" }}}

" markdown-preview {{{
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1
    \ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'
" }}}

" vim-pandoc {{{
let g:pandoc#folding#fold_yaml=1
let g:pandoc#folding#fold_fenced_codeblocks=1
" }}}

" vim-pandox-syntax {{{
let g:pandoc#syntax#conceal#use=0
" }}}

" vim-anzu {{{
" mapping
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
" }}}

" wiki.vim {{{
let g:wiki_root = $HOME.'/Dropbox/github_repo/wiki'
let g:wiki_filetypes = ['md']
let g:wiki_link_extenstion = '.md'
let g:wiki_link_target_type = 'md'
let g:wiki_mappings_use_defaults = 0
" }}}

" vim-quickscope {{{
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" }}}

" sneak {{{
let g:sneak#label = 1

" case insensitive sneak
let g:sneak#use_ic_scs = 1

" immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
let g:sneak#s_next = 1

" remap so I can use , and ; with f and t
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;
" }}}
" }}}

" Key mappings {{{
" Use space as leader key
let g:mapleader = "\<Space>"

" Use comma as local leader key
let g:maplocalleader = ','

" Use which-key
autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>

" Define prefix dictionary
let g:which_key_map =  {}

" a {{{
let g:which_key_map.a = {
    \ 'name' : '+arguments'  ,
    \ 'h' : ['SidewaysLeft'  , 'argument-move-left'  ] ,
    \ 'l' : ['SidewaysRight' , 'argument-move-right']  ,
    \ }
" }}}

" b {{{
let g:which_key_map.b = {
    \ 'name' : '+buffer'      ,
    \ '1' : ['b1'             , 'buffer-1']         ,
    \ '2' : ['b2'             , 'buffer-2']         ,
    \ '3' : ['b3'             , 'buffer-3']         ,
    \ '4' : ['b4'             , 'buffer-4']         ,
    \ '5' : ['b5'             , 'buffer-5']         ,
    \ '6' : ['b6'             , 'buffer-6']         ,
    \ '7' : ['b7'             , 'buffer-7']         ,
    \ '8' : ['b8'             , 'buffer-8']         ,
    \ '9' : ['b9'             , 'buffer-9']         ,
    \ 'b' : ['Buffers'        , 'buffer-list']      ,
    \ 'c' : ['bclose'         , 'buffer-close']     ,
    \ 'd' : ['Bdelete'        , 'buffer-delete']    ,
    \ 'h' : ['Startify'       , 'open-home']        ,
    \ 'l' : ['BLines'         , 'buffer-lines']     ,
    \ 'L' : ['Lines'          , 'buffer-lines-all'] ,
    \ 'k' : ['Bwipeout'       , 'buffer-kill']      ,
    \ 'n' : ['bnext'          , 'buffer-next']      ,
    \ 'p' : ['bprevious'      , 'buffer-previous']  ,
    \ }
" }}}

" f {{{
let g:which_key_map.f = { 'name' : '+find/files/fold'}
nnoremap <silent> <leader>f0 :set foldlevel=0<CR>
let g:which_key_map.f.0 = 'fold-0-level'
nnoremap <silent> <leader>f1 :set foldlevel=1<CR>
let g:which_key_map.f.1 = 'fold-1-level'
nnoremap <silent> <leader>f2 :set foldlevel=2<CR>
let g:which_key_map.f.2 = 'fold-2-level'
nnoremap <silent> <leader>f3 :set foldlevel=3<CR>
let g:which_key_map.f.3 = 'fold-3-level'
nnoremap <silent> <leader>f4 :set foldlevel=4<CR>
let g:which_key_map.f.4 = 'fold-4-level'
nnoremap <silent> <leader>f5 :set foldlevel=5<CR>
let g:which_key_map.f.5 = 'fold-5-level'
nnoremap <silent> <leader>f6 :set foldlevel=6<CR>
let g:which_key_map.f.6 = 'fold-6-level'
nnoremap <silent> <leader>f7 :set foldlevel=7<CR>
let g:which_key_map.f.7 = 'fold-7-level'
nnoremap <silent> <leader>f8 :set foldlevel=8<CR>
let g:which_key_map.f.8 = 'fold-8-level'
nnoremap <silent> <leader>f9 :set foldlevel=9<CR>
let g:which_key_map.f.9 = 'fold-9-level'
nnoremap <silent> <leader>fR :source $MYVIMRC<CR>
let g:which_key_map.f.R = 'reload-vimrc'
nnoremap <silent> <leader>fd :NERDTreeFind<CR>
let g:which_key_map.f.d = 'find-current-buffer-in-NERDTree'
nnoremap <silent> <leader>ff :Files<CR>
let g:which_key_map.f.f = 'files-in-current-directory'
nnoremap <silent> <leader>fh :History<CR>
let g:which_key_map.f.h = 'history-file'
nnoremap <silent> <leader>fs :update<CR>
let g:which_key_map.f.s = 'save-file'
nnoremap <silent> <leader>ft :NERDTreeToggle<CR>
let g:which_key_map.f.t = 'NERDTree'
nnoremap <silent> <leader>fv :e $MYVIMRC<CR>
let g:which_key_map.f.v = 'open-vimrc'
" }}}

" g {{{
let g:which_key_map.g = {
    \ 'name' : '+git/goto'                  ,
    \ 'D' :  ['<Plug>(coc-definition)'      , 'goto-definition']             ,
    \ 'N' :  ['<Plug>(coc-rename)'          , 'rename-variables']            ,
    \ 'P' :  [':Git pull'                   , 'git-pull']                    ,
    \ 'R' :  ['<Plug>(coc-references)'      , 'goto-reference']              ,
    \ 'T' :  ['<Plug>(coc-type-definition)' , 'goto-type-definition']        ,
    \ 'V' :  [':GV!'                        , 'git-commit-log-current-file'] ,
    \ 'a' :  [':Git add -p %'               , 'git-add']                     ,
    \ 'b' :  ['Gblame'                      , 'git-blame']                   ,
    \ 'c' :  ['Gcommit'                     , 'git-commit']                  ,
    \ 'd' :  ['Gdiff'                       , 'git-diff']                    ,
    \ 'e' :  ['Gedit'                       , 'git-edit']                    ,
    \ 'h' :  [':GV?'                        , 'git-revision-current-file']   ,
    \ 'i' :  ['<Plug>(coc-implementation)'  , 'goto-implementation']         ,
    \ 'l' :  ['Glog'                        , 'git-log']                     ,
    \ 'p' :  [':Git push'                   , 'git-push']                    ,
    \ 'r' :  ['Gread'                       , 'git-read']                    ,
    \ 's' :  ['Gstatus'                     , 'git-status']                  ,
    \ 'v' :  ['GV'                          , 'git-commit-log']              ,
    \ 'w' :  ['Gwrite'                      , 'git-write']                   ,
    \ }
" }}}

" l {{{
let g:which_key_map.l = {
    \ 'name' : '+list'      ,
    \ 's' : 'list-symbols' ,
    \ 'c' : 'list-commits-buffer' ,
    \ 'C' : 'list-commits-project' ,
    \ 'R' : 'list-resume' ,
    \ }
nnoremap <leader>ls :CocList symbols<cr>
nnoremap <leader>lc :CocList bcommits<cr>
nnoremap <leader>lo :CocList outline<cr>
nnoremap <leader>lC :CocList commits<cr>
nnoremap <leader>lR :CocListResume<cr>
" }}}

" o {{{
let g:which_key_map.o = {
    \ 'name' : '+open'    ,
    \ 'q' : ['copen' , 'open-quickfix']     ,
    \ 'l' : ['copen' , 'open-locationlist'] ,
    \ }
" }}}

" q {{{
nnoremap <silent> <leader>q :q<CR>
let g:which_key_map.q = [ 'q', 'quit' ]
nnoremap <silent> <leader>Q :qa!<CR>
let g:which_key_map.Q = [ 'qa!', 'quit-without-saving' ]

" fix FZF job issue on Windows
autocmd FileType fzf nnoremap <silent> <leader>q :q!<CR>
" }}}

" s {{{
let g:which_key_map.s = {
    \ 'name' : '+search/show' ,
    \ 'C' : [':Commands'      , 'search-commands']        ,
    \ 'F' : [':Filetypes'     , 'search-file-types']      ,
    \ 'H' : [':History:'      , 'search-command-history'] ,
    \ 'M' : [':Maps'          , 'search-maps']            ,
    \ 'S' : [':History/'      , 'search-search-history']  ,
    \ 'b' : [':Buffers'       , 'search-buffers']         ,
    \ 'c' : [':Colors'        , 'search-colorschemes']    ,
    \ 'f' : [':BTags'         , 'search-functions']       ,
    \ 'h' : [':Helptags'      , 'search-help-tags']       ,
    \ 'l' : [':BLines'        , 'search-lines']           ,
    \ 'm' : [':Marks'         , 'search-marks']           ,
    \ 'p' : [':Rg'            , 'grep-on-the-fly']        ,
    \ 't' : [':Tags'          , 'search-tags']            ,
    \ 'w' : [':Windows'       , 'search-windows']         ,
    \ }

nnoremap <silent> <Leader>sn :nohlsearch<CR>
let g:which_key_map.s.n = 'disable-highlight-search'

nnoremap <silent> <leader>sy  :<C-u>CocList -A --normal yank<cr>
let g:which_key_map.s.y = 'search-yanks'
" }}}

" t {{{
let g:which_key_map.t = {
    \ 'name' : '+tabs/toggle'             ,
    \ 'C' :  [':call ToggleColorColumn()' , 'toggle-color-column']        ,
    \ 'N' :  ['tabnew'                    , 'tab-new']                    ,
    \ 'L' :  [':call ToggleLineNumber()'  , 'toggle-line-number']         ,
    \ 'P' :  [':MarkdownPreview'          , 'toggle-markdown-preview']    ,
    \ 'R' :  [':RainbowToggle'            , 'toggle-rainbow-parentheses'] ,
    \ 'S' :  [':call ToggleSpellCheck()'  , 'toggle-spell-check']         ,
    \ '\' :  ['ToggleSlash'               , 'toggle-file-path-style']     ,
    \ 'c' :  ['tabclose'                  , 'tab-close']                  ,
    \ 'f' :  [':1tabnext'                 , 'tab-first']                  ,
    \ 'i' :  ['IndentLinesToggle'         , 'toggle-indent-lines']        ,
    \ 'l' :  [':$tabnext'                 , 'tab-last']                   ,
    \ 'm' :  ['TableModeToggle'           , 'toggle-table-mode']          ,
    \ 'n' :  [':+tabnext'                 , 'tab-next']                   ,
    \ 'p' :  [':-tabnext'                 , 'tab-previcus']               ,
    \ 's' :  [':call ToggleCursorLine()'  , 'toggle-cursor-line']         ,
    \ 'u' :  ['UndotreeToggle'            , 'toggle-undotree']            ,
    \ }
" }}}

" w {{{
let g:which_key_map.w = {
    \ 'name' : '+windows'       ,
    \ 'w' :  ['<c-w>w'          , 'window-other']             ,
    \ 'c' :  ['<c-w>c'          , 'window-close']             ,
    \ '-' :  ['<c-w>s'          , 'window-split-below']       ,
    \ '|' :  ['<c-w>v'          , 'window-split-right']       ,
    \ '\' :  ['<c-w>v'          , 'window-split-right']       ,
    \ 'm' :  ['MaximizerToggle' , 'windows-maximizer-toggle'] ,
    \ 'h' :  ['<c-w>h'          , 'window-left']              ,
    \ 'j' :  ['<c-w>j'          , 'window-below']             ,
    \ 'l' :  ['<c-w>l'          , 'window-right']             ,
    \ 'k' :  ['<c-w>k'          , 'window-up']                ,
    \ 'H' :  ['<c-w>5<'         , 'window-expand-left']       ,
    \ 'J' :  [':resize +5'      , 'window-expand-below']      ,
    \ 'L' :  ['<c-w>5>'         , 'window-expand-right']      ,
    \ 'K' :  [':resize -5'      , 'window-expand-up']         ,
    \ '=' :  ['<c-w>='          , 'window-balance']           ,
    \ 's' :  ['<c-w>s'          , 'split-window-below']       ,
    \ 'v' :  ['<c-w>v'          , 'split-window-below']       ,
    \ }
" }}}

" W {{{
let g:which_key_map.W = {
      \ 'name' : '+Wiki',
      \ 'i' : ['<plug>(wiki-index)', 'Index'],
      \ 'o' : ['<plug>(wiki-open)', 'Open'],
      \ 'j' : ['<plug>(wiki-journal)', 'Journal'],
      \ 'd' : ['<plug>(wiki-page-delete)', 'PageDelete'],
      \ 'r' : ['<plug>(wiki-page-rename)', 'PageRename'],
      \ 'E' : ['<plug>(wiki-export)', 'Export'],
      \ '/' : ['<plug>(wiki-fzf-pages)', 'FzfPages'],
      \ 'g' : {
      \   'name' : '+ Graph',
      \   'b' : ['<plug>(wiki-graph-find-backlinks)', 'Find Backlinks'],
      \   't' : ['<plug>(wiki-graph-in)', 'Graph to current Page'],
      \   'f' : ['<plug>(wiki-graph-out)', 'Graph from current Paget'],
      \  },
      \ 'J' : {
      \   'name' : '+ Journal',
      \   'i' : ['<plug>(wiki-journal-index)', 'Create Index'],
      \   'I' : ['<plug>(wiki-journal-index-md)', 'Create Index md-style'],
      \   'n' : ['<plug>(wiki-journal-next)', 'Next'],
      \   'p' : ['<plug>(wiki-journal-prev)', 'Prev'],
      \   'cn' : ['<plug>(wiki-journal-copy-tonext)', 'CopyToNext'],
      \   'w' : ['<plug>(wiki-journal-toweek)', 'To Week Summary'],
      \   'm' : ['<plug>(wiki-journal-tomonth)', 'To Month Summary'],
      \  },
      \ 'l' : {
      \   'name' : '+ List',
      \   't' : ['<plug>(wiki-list-toggle)', 'Toggle item'],
      \   'u' : ['<plug>(wiki-list-uniq)', 'Remove duplicates'],
      \   'U' : ['<plug>(wiki-list-uniq-local)', 'Rem. duplicates local'],
      \  },
      \ 'L' : {
      \   'name' : '+ Link',
      \   'n' : ['<plug>(wiki-link-next)', 'Next'],
      \   'p' : ['<plug>(wiki-link-prev)', 'Prev'],
      \   'o' : ['<plug>(wiki-link-open)', 'Open'],
      \   's' : ['<plug>(wiki-link-open-split)', 'Open in Split'],
      \   'b' : ['<plug>(wiki-link-return)', 'Back to prev. page'],
      \  },
      \ 't' : {
      \   'name' : '+ Tag/ToC',
      \   'l' : ['<plug>(wiki-tag-list)', 'List'],
      \   'r' : ['<plug>(wiki-tag-reload)', 'Reload'],
      \   's' : ['<plug>(wiki-tag-search)', 'Search' ],
      \   't' : ['<plug>(wiki-page-toc)', 'Page ToC'],
      \   'T' : ['<plug>(wiki-page-toc-local)', 'Page ToC Local'],
      \  },
      \ }
let g:wiki_mappings_local = {
      \ '<plug>(wiki-link-open)' : '<cr>',
      \ '<plug>(wiki-link-return)' : '<bs>',
      \}
" }}}

" x {{{
let g:which_key_map.x = {
    \ 'name' : '+extra'        ,
    \ 'd' :  ['StripWhitespace', 'trim-whitespaces'] ,
    \ }
" }}}

" z {{{
let g:which_key_map.z = {
    \ 'name' : '+zoom'    ,
    \ '+' :  ['zoom-in']  ,
    \ '=' :  ['zoom-in']  ,
    \ '-' :  ['zoom-out'] ,
    \ }

noremap <silent><leader>z+ :Bigger<CR>
noremap <silent><leader>z- :Smaller<CR>
" }}}

" }}}

" R {{{
" AutoCmd {{{
augroup au_R
    au!
    " force showing color column
    au FileType r,rmd setlocal colorcolumn=80

    au FileType r setlocal foldmethod=syntax

    " set comment string
    au FileType r setlocal formatoptions+=r "insert the current comment leader
    au FileType r setlocal commentstring=#%s
    au FileType r setlocal comments+=b:#'

    au FileType rmd setlocal comments=b:*,b:-,b:+,n:>

    " add EnergyPlus class dict
    au FileType r,rmd setlocal dictionary+=$HOME/.vim/dict/idd.dic

    " Keybindings
    " NVim-R
    autocmd FileType rbrowser nnoremap <buffer><silent> <CR> :call RBrowserDoubleClick()<CR>
    autocmd FileType rbrowser nnoremap <buffer><silent> <2-LeftMouse> :call RBrowserDoubleClick()<CR>
    autocmd FileType rbrowser nnoremap <buffer><silent> <RightMouse> :call RBrowserRightClick()<CR>

    " assign, pipe and data.table assign
    if (has("win32"))
        autocmd FileType r,rmd inoremap <buffer> ½ <c-v><Space>%>%<c-v><Space>
        autocmd FileType r,rmd inoremap <buffer> » <c-v><Space>:=<c-v><Space>
    endif
    autocmd FileType r,rmd inoremap <buffer> <M--> <c-v><Space><-<c-v><Space>
    autocmd FileType r,rmd inoremap <buffer> <M-=> <c-v><Space>%>%<c-v><Space>
    autocmd FileType r,rmd inoremap <buffer> <M-;> <c-v><Space>:=<c-v><Space>

    " devtools integration
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>da :RLoadPackage<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>dd :RDocumentPackage<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>dt :RTestPackage<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>df :RTestFile<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>dc :RCheckPackage<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>dr :RSend devtools::build_readme()<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>dI :RInstallPackage<cr>

    " targets
    autocmd FileType r nnoremap <buffer> <LocalLeader>tm :RSend targets::tar_make()<cr>
    autocmd FileType r nnoremap <buffer> <LocalLeader>tM :RSend targets::tar_make(callr_function = NULL)<cr>

    " doge to generate roxygen2 template
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>rO :DogeGenerate<cr>

    " debug
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>tb :RSend traceback()<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>sq :RSend Q<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>sc :RSend c<cr>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>sn :RSend n<cr>

    " RMarkdown
    autocmd FileType r nnoremap <buffer> <LocalLeader>ki :call SpinRmd()<CR>
    autocmd FileType rnoweb nnoremap <buffer> <LocalLeader>kk :call RenderRnw()<CR>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>kk :call RenderRmd()<CR>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>kb :call RenderBook()<CR>
    autocmd FileType r,rmd nnoremap <buffer> <LocalLeader>kp :call RenderChapter()<CR>

    " Blogdown
    autocmd FileType rmd nnoremap <buffer> <LocalLeader>Ss :RSend blogdown::serve_site()<CR>
augroup END
" }}}
" }}}

" Functions {{{
" SpinRmd {{{
function SpinRmd()
    let rmdPath = expand("%:p")
    if has("win32")
        let rmdPath = substitute(rmdPath, '\\', '/', 'g')
    endif
    let cmd = "RSend knitr::spin('" . rmdPath. "', knit = FALSE, report = FALSE)"
    exec cmd
endfunction
" }}}
" RenderRnw {{{
function RenderRnw()
    let rnwPath = expand("%:p")
    if has("win32")
        let rnwPath = substitute(rnwPath, '\\', '/', 'g')
    endif
    let cmd = "RSend knitr::knit2pdf('" . rnwPath. "')"
    exec cmd
endfunction
" }}}
" RenderRmd {{{
function RenderRmd()
    let rmdPath = expand("%:p")
    if has("win32")
        let rmdPath = substitute(rmdPath, '\\', '/', 'g')
    endif
    let cmd = "RSend rmarkdown::render('" . rmdPath. "', encoding = 'UTF-8')"
    exec cmd
endfunction
" }}}
" RenderBook {{{
function RenderBook()
    let rmdPath = expand("%:p")
    if has("win32")
        let rmdPath = substitute(rmdPath, '\\', '/', 'g')
    endif
    let cmd = "RSend bookdown::render_book('" . rmdPath. "', encoding = 'UTF-8')"
    exec cmd
endfunction
" }}}
" RenderChapter {{{
function RenderChapter()
    let rmdPath = expand("%:p")
    if has("win32")
        let rmdPath = substitute(rmdPath, '\\', '/', 'g')
    endif
    let cmd = "RSend bookdown::preview_chapter('" . rmdPath. "', encoding = 'UTF-8')"
    exec cmd
endfunction
" }}}
" ToggleSlash {{{
function! ToggleSlash(independent) range
    let from = ''
    for lnum in range(a:firstline, a:lastline)
        let line = getline(lnum)
        let first = matchstr(line, '[/\\]')
        if !empty(first)
            if a:independent || empty(from)
                let from = first
            endif
            let opposite = (from == '/' ? '\' : '/')
            call setline(lnum, substitute(line, from, opposite, 'g'))
        endif
    endfor
endfunction
command! -bang -range ToggleSlash <line1>,<line2>call ToggleSlash(<bang>1)
" }}}
" ToggleCursorColumn {{{
function! ToggleCursorColumn() abort
    if &cursorcolumn
        setlocal nocursorcolumn
    else
        setlocal cursorcolumn
    endif
endfunction
" }}}
" ToggleCursorColumn {{{
function! ToggleColorColumn() abort
    if &colorcolumn
        setlocal colorcolumn=
    else
        setlocal colorcolumn=80
    endif
endfunction
" }}}
" ToggleSpellCheck {{{
function! ToggleSpellCheck() abort
    setlocal spell!
    if &spell
        echo "Spellcheck ON"
    else
        echo "Spellcheck OFF"
    endif
endfunction
" }}}
" ToggleCursorLine {{{
function! ToggleCursorLine() abort
    if(&cursorline == 1)
        set nocursorline
    else
        set cursorline
    endif
endfunction
" }}}
" ToggleLineNumber {{{
function! ToggleLineNumber() abort
    execute {
          \ '00': 'set relativenumber   | set number',
          \ '01': 'set norelativenumber | set number',
          \ '10': 'set norelativenumber | set nonumber',
          \ '11': 'set norelativenumber | set number'
          \ }[&number . &relativenumber]
endfunction
" }}}
" }}}

" vim:set ft=vim et sw=4:
