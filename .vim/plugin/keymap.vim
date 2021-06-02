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

" Basic ------------------------------------------------------------------------

" move through wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

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

" toggle folding using \
nnoremap \ za
vnoremap \ za

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
tnoremap <c-w>h <c-\><c-n><c-w>h
tnoremap <c-w>j <c-\><c-n><c-w>j
tnoremap <c-w>k <c-\><c-n><c-w>k
tnoremap <c-w>l <c-\><c-n><c-w>l

" manipulate font size
command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
noremap + :Bigger<CR>
noremap _ :Smaller<CR>

" <Leader>q close quickfix/location list window
nnoremap <leader>q :cclose<bar>lclose<cr>
