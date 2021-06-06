" add EnergyPlus class dict
setlocal dictionary+=$HOME/.vim/dict/idd.dic

" wrap long lines
setlocal wrap

" render all formats listed in R Markdown header
function! RMakeAll() abort
    let path = substitute(expand('%:p'), '\', '/', 'g')
    call g:SendCmdToR('rmarkdown::render("'. path .'", "all")')
endfunction
nnoremap <LocalLeader>ka :<C-u>RMakeAll()<CR>
