"=============================================================================
" File    : autoload/unite/sources/outline/defaults/idf.vim
" Author  : Hongyuan Jia <jiahony@outlook.com>
" Updated : 2017-05-30
"
" Licensed under the MIT license:
" http://www.opensource.org/licenses/mit-license.php
"
"=============================================================================

" Default outline info for EnergyPlus idf files
" Version: 0.0.2

function! unite#sources#outline#defaults#idf#outline_info() abort
  return s:outline_info
endfunction

"-----------------------------------------------------------------------------
" Outline Info

let s:outline_info = {
      \ 'heading'  : '\(^\(\(! \)*\(\(!- \{3}=\{11} \{2}ALL OBJECTS IN CLASS: .* =\{11}\)\|\(\s*\w.*,\)\|\(##\w.*\)\|\(\s*\w.*\s*,\s*.*;\)\)\)$\)\|\(^!\s\+\S\+.*\s\+!$\)',
      \ }

function! s:outline_info.create_heading(which, heading_line, matched_line, context) abort
    let heading = {
                 \ 'word' : a:heading_line,
                 \ 'level': 0,
                 \ 'type' : 'generic',
                 \ }

    " RegEx for all headings
    let regex_class = '^\(! \)*!- \{3}=\{11} \{2}ALL OBJECTS IN CLASS: \(.*\) =\{11}' 
    let regex_macro = '^\(! \)*#\(#\(include\|fileprefix\|includesilent\|nosilent\|if\|ifdef\|ifndef\|elseif\|else\|endif\|def\|enddef\|def1\|set1\|list\|nolist\|show\|noshow\|showdetail\|noshowdetail\|expandcomment\|traceback\|notraceback\|write\|nowrite\|symboltable\|clear\|reverse\|!\)\|eval\|[\)'
    let regex_object = '^\(\! \)*\s*\([A-Z].*\),$'
    let regex_blank_or_ending = '^\(\(\s*\)\|\(\(! \)*\s*\(\S.*\);\s*!\s*-\s*.*\)\)$'
    let regex_field = '^\(! \)*\s*\(\S.*\)[,;]\s*!\s*-\s*.*$'
    let regex_special = '^\(! \)*\s*\([A-Z].\{-}\)\s*,\s*\(.\{-}\)\s*\(,.*\s*\)*;$'
    let regex_output_variable = '^\(! \)*\s*\(Output:Variable\)\s*,\s*\(.\{-}\)\s*,\(.\{-}\)\s*\(,.*\s*\)*;$'
    let regex_box = '^!\s\+\(\S\+.*\)\s\+!$'

    " Get all lines in the current buffer.
    let lines = a:context.lines

    if a:which ==# 'heading'
        let line = a:heading_line
        let h_lnum = a:context.heading_lnum
        if line =~ regex_class
            let heading.level = 1
            let heading.word = substitute(heading.word, regex_class, '\1\2','g')
            return heading
        " Check if the current line is a macro statement.
        elseif line =~ regex_macro
            let heading.level = 1
            let heading.word = 'EpMacro: '. substitute(heading.word, '^\(\! \)*#\(#\)*\(.*\)', '\3', 'g')
            return heading
        elseif line =~ regex_special
            let heading.level = 2
            if line =~# regex_output_variable
                let heading.word = substitute(line, regex_output_variable, '\1\2: \3: \4', 'g')
            else
                let heading.word = substitute(line, regex_special, '\1\2: \3', 'g')
            endif
            return heading
        elseif line =~ regex_object
            " Check if the line before is an empty line or an ending of an object.
            let line_before = lines[h_lnum - 1]
            if line_before =~ regex_blank_or_ending
                let heading.level = 2
                " Check if in a 'Output:Variable' object.
                let line_after = lines[h_lnum + 1]
                if line_after =~ '^\(! \)*\s*\(\S.*\),.*!\s*-\s*Key Value$'
                    let line_after2 = lines[h_lnum + 2]
                    " Let the heading word be 'Object: Key Value'.
                    let heading.word = substitute(line, ',$', ': ', 'g'). substitute(line_after, regex_field, '\2', 'g') . ': '. substitute(line_after2, regex_field, '\2', 'g')
                else
                    " Let the heading word be 'Object: Name'.
                    let heading.word = substitute(line, ',$', ': ', 'g'). substitute(line_after, regex_field, '\2', 'g')
                endif
                return heading
            else
                return {}
            endif
        elseif line =~ regex_box
            " Check if the line before and after are both lines of comment marks
            let line_before = lines[h_lnum - 1]
            let line_after = lines[h_lnum + 1]
            if line_before =~ '^!\{80}$'
                if line_after =~ '^!\{80}$'
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
    else
        return {}
    endif
endfunction
