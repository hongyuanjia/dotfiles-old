"=============================================================================
" File    : autoload/unite/sources/outline/defaults/r.vim
" Author  : Hongyuan Jia <jiahony@outlook.com>
" Updated : 2017-05-31
"
" Licensed under the MIT license:
" http://www.opensource.org/licenses/mit-license.php
"
"=============================================================================

" Default outline info for EnergyPlus idf files
" Version: 0.0.1

function! unite#sources#outline#defaults#r#outline_info() abort
  return s:outline_info
endfunction

"-----------------------------------------------------------------------------
" Outline Info

let s:outline_info = {
                     \ 'heading'  : '\(^\s*\(#\s*\)\+\(.*\){{{\(\d\+\)*\s*$\)\|\(^#\s\+\S\+.*\s\+#$\)',
                     \ }

function! s:outline_info.create_heading(which, heading_line, matched_line, context) abort
    let heading = {
                 \ 'word' : a:heading_line,
                 \ 'level': 0,
                 \ 'type' : 'generic',
                 \ }

    " RegEx for all headings
    let regex_fold = '^\s*\(#\s*\)\+\(.*\){{{\(\d\+\)*\s*$'
    let regex_comment = '^\s*#\s*\(\(#\s*\)*.*\)\s*$'
    let regex_box = '^#\s\+\(\S\+.*\)\s\+#$'
    " Get all lines in the current buffer.
    let lines = a:context.lines

    if a:which ==# 'heading'
        let line = a:heading_line
        let h_lnum = a:context.heading_lnum
        if line =~ regex_fold
            let fold_level = substitute(line, regex_fold, '\3', 'g')
            let heading.level = str2nr(fold_level)
            if heading.level == 0
                let heading.level = 1
            endif
            let heading.word = substitute(heading.word, regex_fold, '\2','g')
            let len = strlen(heading.word)
            if len == 0
                let line_before = lines[h_lnum - 1]
                if line_before =~ regex_comment
                    let heading.word = substitute(line_before, regex_comment, '\1', 'g')
                endif
            endif
            return heading
        elseif line =~ regex_box
            let line_before = lines[h_lnum - 1]
            let line_after = lines[h_lnum + 1]
            if line_before =~ '^#\{80}$'
                if line_after =~ '#\{80}$'
                    let heading.level = 1
                    let heading.word = substitute(line, regex_box, '[*GROUP*]: \1', 'g')
                    return heading
                else
                    return {}
                endif
            else
                return {}
            endif
        else
            return {}
        endif
    elseif
        return {}
    endif
endfunction
