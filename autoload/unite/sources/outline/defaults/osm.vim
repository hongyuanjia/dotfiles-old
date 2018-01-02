"=============================================================================
" File    : autoload/unite/sources/outline/defaults/idf.vim
" Author  : Hongyuan Jia <jiahony@outlook.com>
" Updated : 2017-05-31
"
" Licensed under the MIT license:
" http://www.opensource.org/licenses/mit-license.php
"
"=============================================================================

" Default outline info for OpenStudio osm files
" Version: 0.0.1

function! unite#sources#outline#defaults#osm#outline_info() abort
  return s:outline_info
endfunction

"-----------------------------------------------------------------------------
" Outline Info

let s:outline_info = {
      \ 'heading'  : '^\(\! \)*\s*\(OS:\w.*\),$',
      \ }

function! s:outline_info.create_heading(which, heading_line, matched_line, context) abort
    let heading = {
                 \ 'word' : a:heading_line,
                 \ 'level': 0,
                 \ 'type' : 'generic',
                 \ }

    " RegEx for all headings
    let regex_object = '^\(\! \)*\s*\(OS:\w.*\),$'
    let regex_handle = '^\(\! \)*\s*{\S\{8}-\S\{4}-\S\{4}-\S\{4}-\S\{12}}\s*,\s*!\s*-\s*Handle$'
    let regex_field = '^\(! \)*\s*\(\S.*\)[,;]\s*!\s*-\s*.*$'
    let regex_output = '^\(\! \)*\s*\(OS:Output:Variable\),$'

    " Get all lines in the current buffer.
    let lines = a:context.lines

    if a:which ==# 'heading'
        let line = a:heading_line
        let h_lnum = a:context.heading_lnum
        if line =~ regex_object
            " Check if the line before is an empty line or an ending of an object.
            let line_after = lines[h_lnum + 1]
            if line_after =~ regex_handle
                let heading.level = 1
                " Check if in a 'Output:Variable' object.
                if line =~ regex_output
                    let line_key = lines[h_lnum + 3]
                    let line_value = lines[h_lnum + 4]
                    " Let the heading word be 'Object: Key Value'.
                    let heading.word = substitute(line, ',$', ': ', 'g'). substitute(line_key, regex_field, '\2', 'g'). ': '. substitute(line_value, regex_field, '\2', 'g')
                else
                    " Let the heading word be 'Object: Name'.
                    let line_name = lines[h_lnum + 2]
                    let heading.word = substitute(line, ',$', ': ', 'g'). substitute(line_name, regex_field, '\2', 'g')
                endif
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
endfunction
