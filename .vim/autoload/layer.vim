" Most of functions are adapted from 'liuchengxu/space-vim'

let g:layer = {}
let g:layer.loaded = []

function! layer#begin() abort
    call s:check_vim_plug()
    call s:define_command()
endfunction

function! layer#end() abort
    call s:register_plugins()
    call s:check_missing_plugins()
endfunction

" download vim-plug if necessary
function! s:check_vim_plug() abort
    if empty(glob($HOME.'/.vim/autoload/plug.vim'))
        echo "==> Downloading vim-plug to manage plugins..."
        silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
            \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endfunction

" defind Layer function
function! s:define_command() abort
    command! -nargs=+ -bar Layer call s:load_layer(<args>)
endfunction

function! s:load_layer(name, ...)
    if index(g:layer.loaded, a:name) == -1
        call add(g:layer.loaded, a:name)
    endif
endfunction

function! s:load_init() abort
    if filereadable(expand($HOME . '.vimrc'))
        execute 'source '. fnameescape(l:layer_packages)
    endif
endfunction

function! s:register_plugins()
    call plug#begin($HOME.'/.vim/plugged/')
    for l:layer in g:layer.loaded
        let l:layer_packages = $HOME.'/.vim/layers/'.l:layer.'/packages.vim'
        execute 'source '. fnameescape(l:layer_packages)
    endfor
    call plug#end()
    for l:layer in g:layer.loaded
        let l:layer_config = $HOME.'/.vim/layers/'.l:layer.'/config.vim'
        execute 'source '. fnameescape(l:layer_config)
    endfor
endfunction

" check missing plugins to be installed
function! s:check_missing_plugins() abort
    call timer_start(1500, 'layer#check_missing_plugins')
endfunction

" https://github.com/junegunn/vim-plug/wiki/extra#automatically-install-missing-plugins-on-startup
function! layer#check_missing_plugins(...) abort
    let l:msg = 'Need to install the missing plugins: '
    let missing = filter(values(g:plugs), '!isdirectory(v:val.dir)')
    if len(missing)
        let plugs = map(missing, 'split(v:val.dir, "/")[-1]')
        let l:msg .= string(plugs).' (y/N): '
        if a:0 == 1
            if s:ask(l:msg)
                silent PlugInstall --sync | q
            endif
        else
            echom l:msg
            PlugInstall --sync | q
        endif
    endif
endfunction

function! s:ask(message) abort
    call inputsave()
    echohl WarningMsg
    let answer = input(a:message)
    echohl None
    call inputrestore()
    echo "\r"
    return (answer =~? '^y') ? 1 : 0
endfunction

function! layer#plug_load(...)
    call plug#load(a:1)
endfunction

function! layer#plug_defer(github_ref, options) abort
    if !has('vim_starting')
        return
    endif

    " extract defer time
    if has_key(a:options, 'defer')
        let defer = a:options['defer']
        let options = remove(a:options, 'defer')
    else
        let defer = 100
    endif

    " disable plugin by default
    call extend(a:options, { 'on': [] })

    " register plugins
    call plug#(a:github_ref, a:options)

    " extract plugin name
    let plugin = a:github_ref[stridx(a:github_ref, '/') + 1:]

    " defer loading
    call timer_start(defer, function('layer#plug_load', [ plugin ]))
endfunction

command! -nargs=+ DeferPlug call layer#plug_defer(<args>)
