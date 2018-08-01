" Define all regex used.
let s:regex_class = '^\(! \)*!- \{3}=\{11} \{2}ALL OBJECTS IN CLASS: \(.*\) =\{11}'
let s:regex_macro = '^\(! \)*#\(#\(include\|fileprefix\|includesilent\|nosilent\|if\|ifdef\|ifndef\|elseif\|else\|endif\|def\|enddef\|def1\|set1\|list\|nolist\|show\|noshow\|showdetail\|noshowdetail\|expandcomment\|traceback\|notraceback\|write\|nowrite\|symboltable\|clear\|reverse\|!\)\|eval\|[\)'
let s:regex_object = '^\(\! \)*\s*\([A-Z].*\),$'
let s:regex_blank = '^\s*$'
let s:regex_field = '^\(! \)*\s*\(\S.*\)[,;]\s*!\s*-\s*.*$'
let s:regex_field_ending = '^\(! \)*\s*\(\S.*\);\s*!\s*-\s*.*$'
let s:regex_comment = '^!.*\(\(\(!\s*-\)\@!\)\|\(\(,\)\@<!$\)\)'
let s:regex_special = '^\(! \)*\s*\w.*\s*,\s*.*;$'

" Check if the idf file is 'SortOrdered' formated
function! Check_SortOrdered()
    let numlines = line('$')
    let line_num = 0
    let num_class = 0
    while line_num <= numlines
        let cur_line = getline(line_num)
        if cur_line =~ s:regex_class
            let num_class += 1
        endif
        let line_num += 1
    endwhile
    let sort_ordered = 0
    if num_class > 0
        let sort_ordered = 1
    endif
    return sort_ordered
endfunction
let s:sort_ordered = Check_SortOrdered()

function! IDFFolds()
    let thisline = getline(v:lnum)
    " If not sort_ordered formated
    if s:sort_ordered == 0
        if thisline =~ s:regex_macro
            return "0"
            " return "-1"
        elseif thisline =~ s:regex_blank
            return "0"
            " return "-1"
        elseif thisline =~ s:regex_special
            return "0"
        elseif thisline =~ s:regex_object
            let nextline = getline(v:lnum + 1)
            if nextline =~ s:regex_field
                return ">1"
            else
                return "-1"
            endif
        elseif thisline =~ s:regex_field
            return "1"
        elseif thisline =~ s:regex_comment
            let nextline = getline(v:lnum + 1)
            " Only comment above a class will be unfolded.
            if nextline =~ s:regex_object
                return "0"
            else
                return "-1"
            endif
        else
            return "="
        endif
    else
        if thisline =~ s:regex_macro
            return "0"
        elseif thisline =~ s:regex_blank
            return "-1"
        elseif thisline =~ s:regex_special
            return "0"
        elseif thisline =~ s:regex_class
            return ">1"
        elseif thisline =~ s:regex_object
            return ">2"
            " let nextline = getline(v:lnum + 1)
            " if nextline =~ s:regex_field
            "     return ">2"
            " else
            "     return "-1"
            " endif
        elseif thisline =~ s:regex_field
            return "=2"
        elseif thisline =~ s:regex_comment
            let nextline = getline(v:lnum + 1)
            " Only comment above a class will be unfolded.
            if nextline =~ s:regex_class
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
setlocal foldexpr=IDFFolds()

function! IDFFoldText()
    let line = getline(v:foldstart)
    let level = v:foldlevel
    let linenext = getline(v:foldstart+1)
    let lineoutput = getline(v:foldstart+2)
    " If not sort_ordered formated
    if s:sort_ordered == 0
        if level == 1
            if linenext =~ '^\(! \)*\s*\(\S.*\),.*!\s*-\s*Key Value$'
                let class = substitute(line, s:regex_object, '\1\2: ', 'g'). substitute(linenext, s:regex_field, '\2', 'g'). ': ' . substitute(lineoutput, s:regex_field, '\2', 'g')
            else
                let class = substitute(line, s:regex_object, '\1\2: ', 'g'). substitute(linenext, s:regex_field, '\2', 'g')
            endif
        endif
    " If sort_ordered formated
    else
        if level == 1
            let class = substitute(line, s:regex_class, '\1\L\u\2','g')
        elseif level == 2
            if linenext =~ '^\(! \)*\s*\(\S.*\),.*!\s*-\s*Key Value$'
                let class = substitute(line, s:regex_object, '\1\2: ', 'g'). substitute(linenext, s:regex_field, '\2', 'g'). ': ' . substitute(lineoutput, s:regex_field, '\2', 'g')
            else
                let class = substitute(line, s:regex_object, '\1\2: ', 'g'). substitute(linenext, s:regex_field, '\2', 'g')
            endif
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
setlocal foldtext=IDFFoldText()
