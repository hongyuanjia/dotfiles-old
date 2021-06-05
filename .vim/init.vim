"  __  ____   ____     _____ __  __ ____   ____
" |  \/  \ \ / /\ \   / /_ _|  \/  |  _ \ / ___|
" | |\/| |\ V /  \ \ / / | || |\/| | |_) | |
" | |  | | | |    \ V /  | || |  | |  _ <| |___
" |_|  |_| |_|     \_/  |___|_|  |_|_| \_\\____|
"

" Author: @hongyuanjia
" Created Date: 2021-06-01
" Last Modified: 2021-06-05 16:10

scriptencoding utf-8

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32')
    set runtimepath^=~/.vim
endif

if get(s:, 'loaded', 0) != 0
    finish
else
    let s:loaded = 1
endif

" use space as leader key
let g:mapleader = "\<Space>"
" use comma as local leader key
let g:maplocalleader = ','

" load layers
call layer#begin()

Layer 'theme'
Layer 'interface'
Layer 'startup'
Layer 'project'
Layer 'lsp'
Layer 'git'
Layer 'lang-r'
Layer 'file-manager'
Layer 'editing'
Layer 'autocomplete'

call layer#end()

" vim:set ft=vim et sw=4:
