"===============================================================================
"
" Key mappings
"
" Author: Hongyuan Jia (@hongyuanjia)
" Created: 2021-06-01
" Last Modified: 2021-06-01 18:31
"
"===============================================================================
" vim: set ts=4 sw=4 tw=80 :

scriptencoding utf-8

if get(s:, 'loaded', 0) != 0
    finish
endif
let s:loaded = 1

" Basic ------------------------------------------------------------------------

" move through wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" use <C-a> to select all
nnoremap <C-a> ggVG

" move cursor using <C-[hjkl]>
noremap <C-h> <left>
noremap <C-j> <down>
noremap <C-k> <up>
noremap <C-l> <right>
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>

" readline-style key bindings in command-line (excerpt from rsi.vim)
cnoremap <C-h> <left>
cnoremap <C-j> <down>
cnoremap <C-k> <up>
cnoremap <C-l> <right>
cnoremap <C-a> <home>
cnoremap <C-e> <end>
cnoremap <C-f> <C-d>
cnoremap <C-b> <left>
cnoremap <C-d> <del>
cnoremap <C-_> <C-k>

" Emacs-style key bindings in INSERT mode
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <c-d> <del>
inoremap <c-_> <c-k>

" jump to beginning or end using H and L
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $

" use Y to yank to the end of line
nnoremap Y y$
vnoremap Y "+y

" indentation using < and >
nnoremap < <<
nnoremap > >>
vnoremap < <gv
vnoremap > >gv

" always show the matched in center
nnoremap n nzz
nnoremap N Nzz

" terminal keybindings
tnoremap <Esc> <C-\><C-n>
tnoremap <M-[> <Esc>
tnoremap <C-v><Esc> <Esc>
tnoremap <C-w>h <C-w><C-h>
tnoremap <C-w>j <C-w><C-j>
tnoremap <C-w>k <C-w><C-k>
tnoremap <C-w>l <C-w><C-l>

" use Ctrl-Tab and Alt-Tab to switch tab
map    <C-Tab>  :tabnext<CR>
imap   <C-Tab>  <C-O>:tabnext<CR>
map    <M-Tab>  :tabprev<CR>
imap   <M-Tab>  <C-O>:tabprev<CR>

" buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" manipulate font size
command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
noremap + :Bigger<CR>
noremap _ :Smaller<CR>

for s:i in range(1, 9)
    " <Leader>[1-9] move to window [1-9]
    execute 'nnoremap <Leader>'.s:i ' :'.s:i.'wincmd w<CR>'

    " <Leader><leader>[1-9] move to tab [1-9]
    execute 'nnoremap <Leader><Leader>'.s:i s:i.'gt'

    " <Leader>b[1-9] move to buffer [1-9]
    execute 'nnoremap <Leader>b'.s:i ':b'.s:i.'<CR>'
endfor
unlet s:i

" <Leader>b
nnoremap <Leader>bc :bclose<CR>
nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>bf :bfirst<CR>
nnoremap <Leader>bk :bwipeout<CR>
nnoremap <Leader>bl :blast<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprevious<CR>

" <Leader>d
nnoremap <Leader>d <C-d>

" <Leader>f
nnoremap <Leader>fs :update<CR>
nnoremap <Leader>fS :wa<CR>
nnoremap <Leader>fR :source $MYVIMRC<CR>
nnoremap <Leader>fv :e $MYVIMRC<CR>

" <Leader>o
nnoremap <Leader>oq :qopen<CR>
nnoremap <Leader>ol :lopen<CR>

" <Leader>q
nnoremap <Leader>q :q<CR>
" <Leader>Q
nnoremap <Leader>Q :qa!<CR>

" <Leader>r
" replace the word under cursor in current file
nnoremap <Leader>rc :%s/\<<C-r><C-w>\>/

" <Leader>s
nnoremap <Leader>sn :nohlsearch<CR>

" <Leader>t
nnoremap <Leader>tp :setlocal paste!<CR>
nnoremap <Leader>tc :call utils#ToggleColorColumn()<CR>
nnoremap <Leader>tC :call utils#ToggleCursorColumn()<CR>
nnoremap <Leader>tl :call utils#ToggleCursorLine()<CR>
nnoremap <Leader>tn :call utils#ToggleLineNumber()<CR>
nnoremap <Leader>ts :call utils#ToggleSpellCheck()<CR>
nnoremap <Leader>ts :set laststatus=2<CR>

" <Leader>u
nnoremap <Leader>u <C-u>

" <Leader>w
nnoremap <Leader>ww <C-w>w
nnoremap <Leader>wd <C-w>c
nnoremap <Leader>w- <C-w>s
nnoremap <Leader>w\| <C-w>v
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wk <C-w>k
tnoremap <Leader>wh <C-w><C-h>
tnoremap <Leader>wj <C-w><C-j>
tnoremap <Leader>wk <C-w><C-k>
tnoremap <Leader>wl <C-w><C-l>
nnoremap <Leader>wH <C-w>5<
nnoremap <Leader>wJ :resize +5<CR>
nnoremap <Leader>wL <C-w>5>
nnoremap <Leader>wK :resize -5<CR>
nnoremap <Leader>w= <C-w>=
nnoremap <Leader>wv <C-w>v
nnoremap <Leader>ws <C-w>s
nnoremap <Leader>wo :only<CR>

noremap <Leader>z+ :Bigger<CR>
noremap <Leader>z_ :Smaller<CR>

" <Leader><Leader>
nnoremap <Leader><Leader>c :tabclose<CR>
nnoremap <Leader><Leader>N :tabnew<CR>
nnoremap <Leader><Leader>f :1tabnext<CR>

command! ProfileStart call utils#ProfileStart()
command! ProfileStop  call utils#ProfileStop()

command! -bang -range ToggleSlash <line1>,<line2>call utils#ToggleSlash(<bang>1)
nnoremap <Leader>t<Bslash> :ToggleSlash<CR>
