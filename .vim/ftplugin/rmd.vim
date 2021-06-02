" add EnergyPlus class dict
setlocal dictionary+=$HOME/.vim/dict/idd.dic

" render all formats listed in R Markdown header
call RCreateMaps('nvi', 'RMakeAll', 'kA', ':call RMakeRmd("all")')
