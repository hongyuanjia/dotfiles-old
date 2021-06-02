"===============================================================================
" Basic settings
"
" Author: Hongyuan Jia (@hongyuanjia)
" Created: 2021-06-01
" Last Modified: 2021-06-01 20:21
"===============================================================================
" vim: set ts=4 sw=4 tw=80 :

" Basic ------------------------------------------------------------------------
" {{{

" disable vi compatible mode
set nocompatible

" Backspace can go up above
set backspace=indent,eol,start

" copy indent from current line when starting a new line
set autoindent

" oo not wrap long lines
set nowrap

" wait for complete keystrokes
set ttimeout
if $TMUX != ''
    set ttimeoutlen=30
elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
    set ttimeoutlen=80
endif

" show line and column number of cursor
set ruler

" enable changing buffer without saving
set hidden

" show completions of Ex command
set wildmenu

" do not refresh when running macros
set lazyredraw

" disable sound on errors
set noerrorbells
set novisualbell
set visualbell t_vb=

" open new windows in the right bottom
set splitright
set splitbelow
" }}}

" Search -----------------------------------------------------------------------
" {{{

" ignore case when searching
set ignorecase

" use smart case
set smartcase

" highlight searching results
set hlsearch

" show matches on the fly when searching
set incsearch
" }}}

" Language ---------------------------------------------------------------------
" {{{
" always use English
set langmenu=en_US.UTF-8
" }}}

" Encoding ---------------------------------------------------------------------
" {{{
if has('multi_byte')
    " default encoding inside Vim
    set encoding=utf-8

    " default encoding for file
    set fileencoding=utf-8

    " try encodings when opening files
    set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
endif
" }}}

" Syntax -----------------------------------------------------------------------
" {{{
" enable syntax highlight
if has('autocmd')
    filetype plugin indent on
endif

" enable filetype plugins
if has('syntax')
    syntax enable
    syntax on
endif
" }}}

" Display ----------------------------------------------------------------------
" {{{
" show matched brackets
set showmatch
set matchtime=2

" show the last line if possible
set display+=lastline

" show tabline
set showtabline=2

" show statusline
set laststatus=2

" show signcolumn
set signcolumn=yes

" show special characters
set list
set listchars=tab:>\ ,trail:~,extends:>,precedes:<,nbsp:+

" show relative number
set number
set relativenumber

" show cursor line
set cursorline

" show command in the last line of screen
set showcmd

" minimal number of screen lines to keep above and below the cursor
set scrolloff=5

" minimal number of screen columns to keep to the left and right of the cursor
set sidescrolloff=5

" disable line number and signcolumn for terminal windows
if has('terminal') && exists(':terminal') == 2
    if exists('##TerminalOpen')
        augroup VimUnixTerminalGroup
            au!
            au TerminalOpen * setlocal nonumber signcolumn=no
        augroup END
    endif
endif

" disable line number for quickfix list
augroup VimInitStyle
    au!
    au FileType qf setlocal nonumber
augroup END

" use gui colors in terminal if available
if has('termguicolors')
    set termguicolors
endif

" fix cursor shape
if has('nvim')
    set guicursor=
elseif (!has('gui_running')) && has('terminal') && has('patch-8.0.1200')
    let g:termcap_guicursor = &guicursor
    let g:termcap_t_RS = &t_RS
    let g:termcap_t_SH = &t_SH
    set guicursor=
    set t_RS=
    set t_SH=
endif

" GVim options
if !has("nvim") && has('gui_running')
    " set Chinese fonts
    set guifont=DejaVuSansMono\ NF:h10
    set guifontwide=SimHei:h10

    " disable GUI menu
    set guioptions-=m
    " disable right scrollbar
    set guioptions-=r
    " disable left scrollbar
    set guioptions-=L
    " disable Toolbar scrollbar
    set guioptions-=T
    " disable tab pages
    set guioptions-=e
endif
" }}}

" Colorscheme ------------------------------------------------------------------
" {{{
set background=dark
set t_Co=256

colorscheme space_vim_theme
" }}}

" Fomat options ----------------------------------------------------------------
" {{{
" use unix EOL by default
set fileformats=unix,dos,mac

" maximum width of text that is being inserted
set textwidth=80

" don't insert a space before or after a multi-byte when join
set formatoptions+=B

" multibyte line breaking
set formatoptions+=m

" remove a comment leader when joining
set formatoptions+=j

" new line will start with a commen leader
set formatoptions+=q

" when formatting text, recognize numbered lists
set formatoptions+=n

" oo not insert the current comment leader
set formatoptions-=r

" oo not auto format text
set formatoptions-=t
" }}}

" Folding ----------------------------------------------------------------------
" {{{
if has('folding')
    " enable folding
    set foldenable

    " default use indent
    set foldmethod=indent

    " open all foldings
    set foldlevel=99
endif
" }}}

" ALT key ----------------------------------------------------------------------
" {{{
" disable ALT key on Windows
set winaltkeys=no

if has('nvim') == 0 && has('gui_running') == 0
    function! s:metacode(key)
        exec "set <M-".a:key.">=\e".a:key
    endfunc
    for i in range(10)
        call s:metacode(nr2char(char2nr('0') + i))
    endfor
    for i in range(26)
        call s:metacode(nr2char(char2nr('a') + i))
        call s:metacode(nr2char(char2nr('A') + i))
    endfor
    for c in [',', '.', '/', ';', '{', '}']
        call s:metacode(c)
    endfor
    for c in ['?', ':', '-', '_', '+', '=', "'"]
        call s:metacode(c)
    endfor
endif
" }}}

" F1-F12 -----------------------------------------------------------------------
" {{{
function! s:key_escape(name, code)
    if has('nvim') == 0 && has('gui_running') == 0
        exec "set ".a:name."=\e".a:code
    endif
endfunc

call s:key_escape('<F1>', 'OP')
call s:key_escape('<F2>', 'OQ')
call s:key_escape('<F3>', 'OR')
call s:key_escape('<F4>', 'OS')
call s:key_escape('<S-F1>', '[1;2P')
call s:key_escape('<S-F2>', '[1;2Q')
call s:key_escape('<S-F3>', '[1;2R')
call s:key_escape('<S-F4>', '[1;2S')
call s:key_escape('<S-F5>', '[15;2~')
call s:key_escape('<S-F6>', '[17;2~')
call s:key_escape('<S-F7>', '[18;2~')
call s:key_escape('<S-F8>', '[19;2~')
call s:key_escape('<S-F9>', '[20;2~')
call s:key_escape('<S-F10>', '[21;2~')
call s:key_escape('<S-F11>', '[23;2~')
call s:key_escape('<S-F12>', '[24;2~')
" }}}

" Backup -----------------------------------------------------------------------
" {{{
" enable backup
set backup

" back when save
set writebackup

" location of backups
set backupdir=$HOME/.vim/tmp

" extenstion of backup file
set backupext=.bak

" disable swap file
set noswapfile

" enable undo
if has('persistent_undo')
    set undofile
    set undodir=$HOME/.vim/tmp
endif

" create tmp dir
if !isdirectory($HOME.'/.vim/tmp')
    silent! call mkdir(expand($HOME.'/.vim/tmp'), "p", 0755)
endif

" number of histories to store
set history=1000

" max number of tab pages to open
set tabpagemax=50

" do not store options and mappings when saving sessions
set sessionoptions-=options
set viewoptions-=options
" }}}

" Tab size ---------------------------------------------------------------------
" {{{
" use 4 spaces for Tab
set smarttab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" }}}

" Diff -------------------------------------------------------------------------
" {{{
" use the patience diff algorithm when creating a diff
if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:patience
endif
" }}}

" Filetype specific settings ---------------------------------------------------
" {{{
augroup InitFileTypesGroup
    " clear autocommand in same group
    autocmd!

    " use {{{,}}} marker for VimScript folding
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim setlocal foldmarker={{{,}}}

    " enable wrap for Markdown and R Markdown
    autocmd FileType markdown,rmd setlocal wrap
augroup END
" }}}

" Misc -------------------------------------------------------------------------
" {{{
" move cursor to the last modified line when open
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \    exe "normal! g`\"" |
    \ endif
" }}}
