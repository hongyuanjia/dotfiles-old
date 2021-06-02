" force showing color column
setlocal colorcolumn=80

" use syntax folding
setlocal foldmethod=syntax

" set comment string
setlocal commentstring=#%s
setlocal comments+=b:#'

" insert the current comment leader
setlocal formatoptions+=r

" add EnergyPlus class dict
setlocal dictionary+=$HOME/.vim/dict/idd.dic

" assign, pipe and data.table assign
inoremap <buffer> <M-=> <c-v><Space>%>%<c-v><Space>
inoremap <buffer> <M-;> <c-v><Space>:=<c-v><Space>

" devtools integration
nnoremap <buffer> <LocalLeader>da :RLoadPackage<cr>
nnoremap <buffer> <LocalLeader>dd :RDocumentPackage<cr>
nnoremap <buffer> <LocalLeader>dt :RTestPackage<cr>
nnoremap <buffer> <LocalLeader>df :RTestFile<cr>
nnoremap <buffer> <LocalLeader>dc :RCheckPackage<cr>
nnoremap <buffer> <LocalLeader>dr :RSend devtools::build_readme()<cr>
nnoremap <buffer> <LocalLeader>dI :RInstallPackage<cr>

" targets
nnoremap <buffer> <LocalLeader>tm :RSend targets::tar_make()<cr>
nnoremap <buffer> <LocalLeader>tM :RSend targets::tar_make(callr_function = NULL)<cr>

" doge to generate roxygen2 template
nnoremap <buffer> <LocalLeader>rO :DogeGenerate<cr>

" debug
nnoremap <buffer> <LocalLeader>tb :RSend traceback()<cr>
nnoremap <buffer> <LocalLeader>sq :RSend Q<cr>
nnoremap <buffer> <LocalLeader>sc :RSend c<cr>
nnoremap <buffer> <LocalLeader>sn :RSend n<cr>
