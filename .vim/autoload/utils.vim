" Most of functions are adapted from 'liuchengxu/space-vim'

" toggle between Windows path and Linux/macOS path
function! utils#ToggleSlash(independent) range
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

function! utils#ToggleCursorColumn() abort
    if &cursorcolumn
        setlocal nocursorcolumn
    else
        setlocal cursorcolumn
    endif
endfunction

function! utils#ToggleColorColumn() abort
    if &colorcolumn
        setlocal colorcolumn=
    else
        setlocal colorcolumn=80
    endif
endfunction

function! utils#ToggleSpellCheck() abort
    setlocal spell!
    if &spell
        echo "Spellcheck ON"
    else
        echo "Spellcheck OFF"
    endif
endfunction

function! utils#ToggleCursorLine() abort
    if(&cursorline == 1)
        set nocursorline
    else
        set cursorline
    endif
endfunction

function! utils#ToggleLineNumber() abort
    execute {
        \ '00': 'set relativenumber   | set number',
        \ '01': 'set norelativenumber | set number',
        \ '10': 'set norelativenumber | set nonumber',
        \ '11': 'set norelativenumber | set number'
        \ }[&number . &relativenumber]
endfunction

function! utils#VisualSelection() abort
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! utils#ProfileStart() abort
    profile start profile.log
    profile func *
    profile file *
    set verbosefile=verbose.log
    set verbose=9
endfunction

function! utils#ProfileStop() abort
    profile pause
    noautocmd wqa!
endfunction

function! utils#CycleQuickfix(action, fallback) abort
    try
        execute a:action
    catch
        execute a:fallback
    finally
        normal! zz
    endtry
endfunction