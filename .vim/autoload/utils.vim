function! utils#toggle_slash(independent) range
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

function! utils#toggle_cursor_column() abort
    if &cursorcolumn
        setlocal nocursorcolumn
    else
        setlocal cursorcolumn
    endif
endfunction

function! utils#toggle_color_column() abort
    if &colorcolumn
        setlocal colorcolumn=
    else
        setlocal colorcolumn=80
    endif
endfunction

function! utils#toggle_spell_check() abort
    setlocal spell!
    if &spell
        echo "Spellcheck ON"
    else
        echo "Spellcheck OFF"
    endif
endfunction

function! utils#toggle_cursor_line() abort
    if(&cursorline == 1)
        set nocursorline
    else
        set cursorline
    endif
endfunction

function! utils#toggle_line_number() abort
    execute {
          \ '00': 'set relativenumber   | set number',
          \ '01': 'set norelativenumber | set number',
          \ '10': 'set norelativenumber | set nonumber',
          \ '11': 'set norelativenumber | set number'
          \ }[&number . &relativenumber]
endfunction
