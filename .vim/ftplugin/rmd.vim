" add EnergyPlus class dict
setlocal dictionary+=$HOME/.vim/dict/idd.dic

" wrap long lines
setlocal wrap

" render all formats listed in R Markdown header
call RCreateMaps('nvi', 'RMakeAll', 'kA', ':call RMakeRmd("all")')
