"  __  ____   ____     _____ __  __ ____   ____
" |  \/  \ \ / /\ \   / /_ _|  \/  |  _ \ / ___|
" | |\/| |\ V /  \ \ / / | || |\/| | |_) | |
" | |  | | | |    \ V /  | || |  | |  _ <| |___
" |_|  |_| |_|     \_/  |___|_|  |_|_| \_\\____|
"

" Author: @hongyuanjia
" Created Date: 2021-06-01
" Last Modified: 2021-06-02 16:44

set runtimepath+=$HOME/.vim

if get(s:, 'loaded', 0) != 0
    finish
else
    let s:loaded = 1
endif

if empty(glob($HOME.'/.vim/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($HOME.'/.vim/plugged')

for f in split(glob($HOME.'/.vim/layers/**/packages.vim'), '\n')
    execute 'source' f
endfor

call plug#end()

for f in split(glob($HOME.'/.vim/layers/**/config.vim'), '\n')
    execute 'source' f
endfor

" vim:set ft=vim et sw=4:
