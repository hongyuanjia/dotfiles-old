" Define all regex used.
let s:regex_object = '^\(\! \)*\s*\(OS:\w.*\),$'
let s:regex_handle = '^\(\! \)*\s*{\S\{8}-\S\{4}-\S\{4}-\S\{4}-\S\{12}}\s*,\s*!\s*-\s*Handle$'
let s:regex_field = '^\(! \)*\s*\(\S.*\)[,;]\s*!\s*-\s*.*$'
let s:regex_blank = '^\s*$'
let s:regex_comment = '^!.*\(\(\(!\s*-\)\@!\)\|\(\(,\)\@<!$\)\)'
let s:regex_output = '^\(\! \)*\s*\(OS:Output:Variable\),$'

function! OSMFolds()
    let thisline = getline(v:lnum)
    " If not sort_ordered formated
    if thisline =~ s:regex_object
        let nextline = getline(v:lnum + 1)
        if nextline =~ s:regex_handle
            return ">1"
        else
            return "-1"
        endif
    elseif thisline =~ s:regex_field
        return "1"
    elseif thisline =~ s:regex_blank
        return "-1"
    elseif thisline =~ s:regex_comment
        let nextline = getline(v:lnum + 1)
        " Only comment above a object will be unfolded.
        if nextline =~ s:regex_object
            return "0"
        else
            return "-1"
        endif
    else
        return "="
    endif
endif
endfunction
setlocal foldmethod=expr
setlocal foldexpr=OSMFolds()

function! OSMFoldText()
    let line = getline(v:foldstart)
    let level = v:foldlevel
    if level == 1
        " Check if in a 'Output:Variable' object.
        if line=~ s:regex_output
            let line_key = getline(v:foldstart+3)
            let line_value = getline(v:foldstart+4)
            " Let the fold text be 'Object: Key Value'.
            let class = substitute(line, ',$', ': ', 'g'). substitute(line_key, s:regex_field, '\2', 'g'). ': '. substitute(line_value, s:regex_field, '\2', 'g')
        else
            " Let the heading word be 'Object: Name'.
            let line_name = getline(v:foldstart+2)
            let class = substitute(line, ',$', ': ', 'g'). substitute(line_name, s:regex_field, '\2', 'g')
        endif
    endif
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart(repeat('▼', v:foldlevel) . repeat('―', v:foldlevel*1) . class, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
setlocal foldtext=OSMFoldText()
