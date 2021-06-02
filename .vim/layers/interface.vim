" Interface --------------------------------------------------------------------

" key mapping menu when pressing <Space>
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
    autocmd! FileType which_key
    autocmd  FileType which_key set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Key mappings {{{
" Use space as leader key
let g:mapleader = "\<Space>"

" Use comma as local leader key
let g:maplocalleader = ','

" Use which-key
autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>

" Define prefix dictionary
let g:which_key_map =  {}

" a {{{
let g:which_key_map.a = {
    \ 'name' : '+arguments'  ,
    \ 'h' : ['SidewaysLeft'  , 'argument-move-left'  ] ,
    \ 'l' : ['SidewaysRight' , 'argument-move-right']  ,
    \ }
" }}}

" b {{{
let g:which_key_map.b = {
    \ 'name' : '+buffer'      ,
    \ '1' : ['b1'             , 'buffer-1']         ,
    \ '2' : ['b2'             , 'buffer-2']         ,
    \ '3' : ['b3'             , 'buffer-3']         ,
    \ '4' : ['b4'             , 'buffer-4']         ,
    \ '5' : ['b5'             , 'buffer-5']         ,
    \ '6' : ['b6'             , 'buffer-6']         ,
    \ '7' : ['b7'             , 'buffer-7']         ,
    \ '8' : ['b8'             , 'buffer-8']         ,
    \ '9' : ['b9'             , 'buffer-9']         ,
    \ 'b' : ['Buffers'        , 'buffer-list']      ,
    \ 'c' : ['bclose'         , 'buffer-close']     ,
    \ 'd' : ['Bdelete'        , 'buffer-delete']    ,
    \ 'h' : ['Startify'       , 'open-home']        ,
    \ 'l' : ['BLines'         , 'buffer-lines']     ,
    \ 'L' : ['Lines'          , 'buffer-lines-all'] ,
    \ 'k' : ['Bwipeout'       , 'buffer-kill']      ,
    \ 'n' : ['bnext'          , 'buffer-next']      ,
    \ 'p' : ['bprevious'      , 'buffer-previous']  ,
    \ }
" }}}

" c {{{
let g:which_key_map.c = {
    \ 'name' : '+code'                           ,
    \ 'c' : ['<Plug>(coc-classobj-i)'            , 'select-inside-class']    ,
    \ 'C' : ['<Plug>(coc-classobj-a)'            , 'select-around-class']    ,
    \ 'l' : ['<Plug>(coc-format-selected)'       , 'format-selected']        ,
    \ 'b' : ['<Plug>(coc-format)'                , 'format-buffer']          ,
    \ 'd' : ['<Plug>(coc-definition)'            , 'jump-to-definition']     ,
    \ 'f' : ['<Plug>(coc-funcobj-i)'             , 'select-inside-function'] ,
    \ 'F' : ['<Plug>(coc-funcobj-a)'             , 'select-around-function'] ,
    \ 'i' : ['<Plug>(coc-implementation)'        , 'goto-implementation']    ,
    \ 'r' : ['<Plug>(coc-references)'            , 'jump-to-references']     ,
    \ 'R' : ['<Plug>(coc-rename)'                , 'rename-symbol']          ,
    \ 's' : ['<Plug>(coc-range-select)'          , 'range-select']           ,
    \ 'S' : ['<Plug>(coc-range-select-backward)' , 'range-select-backward']  ,
    \ 'T' : ['<Plug>(coc-type-definition)'       , 'goto-type-definition']   ,
    \ 'e' : ['<Plug>(coc-diagnostic-info)'       , 'diagnostic-current']     ,
    \ 'n' : ['<Plug>(coc-diagnostic-info)'       , 'diagnostic-next']        ,
    \ 'p' : ['<Plug>(coc-diagnostic-info)'       , 'diagnostic-prev']        ,
    \ }
" }}}

" f {{{
let g:which_key_map.f = { 'name' : '+find/files/fold'}
nnoremap <silent> <leader>f0 :set foldlevel=0<CR>
let g:which_key_map.f.0 = 'fold-0-level'
nnoremap <silent> <leader>f1 :set foldlevel=1<CR>
let g:which_key_map.f.1 = 'fold-1-level'
nnoremap <silent> <leader>f2 :set foldlevel=2<CR>
let g:which_key_map.f.2 = 'fold-2-level'
nnoremap <silent> <leader>f3 :set foldlevel=3<CR>
let g:which_key_map.f.3 = 'fold-3-level'
nnoremap <silent> <leader>f4 :set foldlevel=4<CR>
let g:which_key_map.f.4 = 'fold-4-level'
nnoremap <silent> <leader>f5 :set foldlevel=5<CR>
let g:which_key_map.f.5 = 'fold-5-level'
nnoremap <silent> <leader>f6 :set foldlevel=6<CR>
let g:which_key_map.f.6 = 'fold-6-level'
nnoremap <silent> <leader>f7 :set foldlevel=7<CR>
let g:which_key_map.f.7 = 'fold-7-level'
nnoremap <silent> <leader>f8 :set foldlevel=8<CR>
let g:which_key_map.f.8 = 'fold-8-level'
nnoremap <silent> <leader>f9 :set foldlevel=9<CR>
let g:which_key_map.f.9 = 'fold-9-level'
nnoremap <silent> <leader>fR :source $MYVIMRC<CR>
let g:which_key_map.f.R = 'reload-vimrc'
nnoremap <silent> <leader>fd :NERDTreeFind<CR>
let g:which_key_map.f.d = 'find-current-buffer-in-NERDTree'
nnoremap <silent> <leader>ff :Files<CR>
let g:which_key_map.f.f = 'files-in-current-directory'
nnoremap <silent> <leader>fh :History<CR>
let g:which_key_map.f.h = 'history-file'
nnoremap <silent> <leader>fs :update<CR>
let g:which_key_map.f.s = 'save-file'
nnoremap <silent> <leader>ft :NERDTreeToggle<CR>
let g:which_key_map.f.t = 'NERDTree'
nnoremap <silent> <leader>fv :e $MYVIMRC<CR>
let g:which_key_map.f.v = 'open-vimrc'
" }}}

" g {{{
let g:which_key_map.g = {
    \ 'name' : '+git'                         ,
    \ 'O' :  [':CocCommand git.browserOpen'   , 'git-open-current']            ,
    \ 'P' :  [':Git pull'                     , 'git-pull']                    ,
    \ 'S' :  [':CocCommand git.chunkStage'    , 'git-chunk-stage']             ,
    \ 'U' :  [':CocCommand git.chunkUndo'     , 'git-chunk-undo']              ,
    \ 'V' :  [':GV!'                          , 'git-commit-log-current-file'] ,
    \ 'a' :  [':Git add -p %'                 , 'git-add']                     ,
    \ 'b' :  ['Git_blame'                     , 'git-blame']                   ,
    \ 'c' :  [':CocCommand git.chunkInfo'     , 'git-chunk-info']              ,
    \ 'd' :  ['Gdiffsplit'                    , 'git-diff']                    ,
    \ 'D' :  [':CocCommand git.diffCached'    , 'git-cached']                  ,
    \ 'e' :  ['Gedit'                         , 'git-edit']                    ,
    \ 'h' :  [':GV?'                          , 'git-revision-current-file']   ,
    \ 'l' :  ['Gclog'                         , 'git-log']                     ,
    \ 'p' :  [':CocCommand git.push'          , 'git-push']                    ,
    \ 'r' :  ['Gread'                         , 'git-read']                    ,
    \ 's' :  ['Git'                           , 'git-status']                  ,
    \ 'v' :  ['GV'                            , 'git-commit-log']              ,
    \ 'w' :  ['Gwrite'                        , 'git-write']                   ,
    \ 'z' :  [':CocCommand git.foldUnchanged' , 'git-fold-unchanged']          ,
    \ }
" }}}

" l {{{
let g:which_key_map.l = {
    \ 'name' : '+list'      ,
    \ 's' : 'list-symbols' ,
    \ 'c' : 'list-commits-buffer' ,
    \ 'C' : 'list-commits-project' ,
    \ 'R' : 'list-resume' ,
    \ }
nnoremap <leader>ls :CocList symbols<cr>
nnoremap <leader>lc :CocList bcommits<cr>
nnoremap <leader>lo :CocList outline<cr>
nnoremap <leader>lC :CocList commits<cr>
nnoremap <leader>lR :CocListResume<cr>
" }}}

" o {{{
let g:which_key_map.o = {
    \ 'name' : '+open'    ,
    \ 'q' : ['copen' , 'open-quickfix']     ,
    \ 'l' : ['copen' , 'open-locationlist'] ,
    \ }
" }}}

" q {{{
nnoremap <silent> <leader>q :q<CR>
let g:which_key_map.q = [ 'q', 'quit' ]
nnoremap <silent> <leader>Q :qa!<CR>
let g:which_key_map.Q = [ 'qa!', 'quit-without-saving' ]

" fix FZF job issue on Windows
autocmd FileType fzf nnoremap <silent> <leader>q :q!<CR>
" }}}

" s {{{
let g:which_key_map.s = {
    \ 'name' : '+search/show' ,
    \ 'C' : [':Commands'      , 'search-commands']        ,
    \ 'F' : [':Filetypes'     , 'search-file-types']      ,
    \ 'H' : [':History:'      , 'search-command-history'] ,
    \ 'M' : [':Maps'          , 'search-maps']            ,
    \ 'S' : [':History/'      , 'search-search-history']  ,
    \ 'b' : [':Buffers'       , 'search-buffers']         ,
    \ 'c' : [':Colors'        , 'search-colorschemes']    ,
    \ 'f' : [':BTags'         , 'search-functions']       ,
    \ 'h' : [':Helptags'      , 'search-help-tags']       ,
    \ 'l' : [':BLines'        , 'search-lines']           ,
    \ 'm' : [':Marks'         , 'search-marks']           ,
    \ 'p' : [':Rg'            , 'grep-on-the-fly']        ,
    \ 't' : [':Tags'          , 'search-tags']            ,
    \ 'w' : [':Windows'       , 'search-windows']         ,
    \ }

nnoremap <silent> <Leader>sn :nohlsearch<CR>
let g:which_key_map.s.n = 'disable-highlight-search'

nnoremap <silent> <leader>sy  :<C-u>CocList -A --normal yank<cr>
let g:which_key_map.s.y = 'search-yanks'
" }}}

" t {{{
let g:which_key_map.t = {
    \ 'name' : '+tabs/toggle'             ,
    \ 'C' :  [':call ToggleColorColumn()' , 'toggle-color-column']        ,
    \ 'N' :  ['tabnew'                    , 'tab-new']                    ,
    \ 'L' :  [':call ToggleLineNumber()'  , 'toggle-line-number']         ,
    \ 'P' :  [':MarkdownPreview'          , 'toggle-markdown-preview']    ,
    \ 'R' :  [':RainbowToggle'            , 'toggle-rainbow-parentheses'] ,
    \ 'S' :  [':call ToggleSpellCheck()'  , 'toggle-spell-check']         ,
    \ '\' :  ['ToggleSlash'               , 'toggle-file-path-style']     ,
    \ 'c' :  ['tabclose'                  , 'tab-close']                  ,
    \ 'f' :  [':1tabnext'                 , 'tab-first']                  ,
    \ 'i' :  ['IndentLinesToggle'         , 'toggle-indent-lines']        ,
    \ 'l' :  [':$tabnext'                 , 'tab-last']                   ,
    \ 'm' :  ['TableModeToggle'           , 'toggle-table-mode']          ,
    \ 'n' :  [':+tabnext'                 , 'tab-next']                   ,
    \ 'p' :  [':-tabnext'                 , 'tab-previcus']               ,
    \ 's' :  [':call ToggleCursorLine()'  , 'toggle-cursor-line']         ,
    \ 'u' :  ['UndotreeToggle'            , 'toggle-undotree']            ,
    \ }
" }}}

" w {{{
let g:which_key_map.w = {
    \ 'name' : '+windows'       ,
    \ 'w' :  ['<c-w>w'          , 'window-other']             ,
    \ 'c' :  ['<c-w>c'          , 'window-close']             ,
    \ '-' :  ['<c-w>s'          , 'window-split-below']       ,
    \ '|' :  ['<c-w>v'          , 'window-split-right']       ,
    \ '\' :  ['<c-w>v'          , 'window-split-right']       ,
    \ 'm' :  ['MaximizerToggle' , 'windows-maximizer-toggle'] ,
    \ 'h' :  ['<c-w>h'          , 'window-left']              ,
    \ 'j' :  ['<c-w>j'          , 'window-below']             ,
    \ 'l' :  ['<c-w>l'          , 'window-right']             ,
    \ 'k' :  ['<c-w>k'          , 'window-up']                ,
    \ 'H' :  ['<c-w>5<'         , 'window-expand-left']       ,
    \ 'J' :  [':resize +5'      , 'window-expand-below']      ,
    \ 'L' :  ['<c-w>5>'         , 'window-expand-right']      ,
    \ 'K' :  [':resize -5'      , 'window-expand-up']         ,
    \ '=' :  ['<c-w>='          , 'window-balance']           ,
    \ 's' :  ['<c-w>s'          , 'split-window-below']       ,
    \ 'v' :  ['<c-w>v'          , 'split-window-below']       ,
    \ }
" }}}

" W {{{
let g:which_key_map.W = {
      \ 'name' : '+Wiki',
      \ 'i' : ['<plug>(wiki-index)', 'Index'],
      \ 'o' : ['<plug>(wiki-open)', 'Open'],
      \ 'j' : ['<plug>(wiki-journal)', 'Journal'],
      \ 'd' : ['<plug>(wiki-page-delete)', 'PageDelete'],
      \ 'r' : ['<plug>(wiki-page-rename)', 'PageRename'],
      \ 'E' : ['<plug>(wiki-export)', 'Export'],
      \ '/' : ['<plug>(wiki-fzf-pages)', 'FzfPages'],
      \ 'g' : {
      \   'name' : '+ Graph',
      \   'b' : ['<plug>(wiki-graph-find-backlinks)', 'Find Backlinks'],
      \   't' : ['<plug>(wiki-graph-in)', 'Graph to current Page'],
      \   'f' : ['<plug>(wiki-graph-out)', 'Graph from current Paget'],
      \  },
      \ 'J' : {
      \   'name' : '+ Journal',
      \   'i' : ['<plug>(wiki-journal-index)', 'Create Index'],
      \   'I' : ['<plug>(wiki-journal-index-md)', 'Create Index md-style'],
      \   'n' : ['<plug>(wiki-journal-next)', 'Next'],
      \   'p' : ['<plug>(wiki-journal-prev)', 'Prev'],
      \   'cn' : ['<plug>(wiki-journal-copy-tonext)', 'CopyToNext'],
      \   'w' : ['<plug>(wiki-journal-toweek)', 'To Week Summary'],
      \   'm' : ['<plug>(wiki-journal-tomonth)', 'To Month Summary'],
      \  },
      \ 'l' : {
      \   'name' : '+ List',
      \   't' : ['<plug>(wiki-list-toggle)', 'Toggle item'],
      \   'u' : ['<plug>(wiki-list-uniq)', 'Remove duplicates'],
      \   'U' : ['<plug>(wiki-list-uniq-local)', 'Rem. duplicates local'],
      \  },
      \ 'L' : {
      \   'name' : '+ Link',
      \   'n' : ['<plug>(wiki-link-next)', 'Next'],
      \   'p' : ['<plug>(wiki-link-prev)', 'Prev'],
      \   'o' : ['<plug>(wiki-link-open)', 'Open'],
      \   's' : ['<plug>(wiki-link-open-split)', 'Open in Split'],
      \   'b' : ['<plug>(wiki-link-return)', 'Back to prev. page'],
      \  },
      \ 't' : {
      \   'name' : '+ Tag/ToC',
      \   'l' : ['<plug>(wiki-tag-list)', 'List'],
      \   'r' : ['<plug>(wiki-tag-reload)', 'Reload'],
      \   's' : ['<plug>(wiki-tag-search)', 'Search' ],
      \   't' : ['<plug>(wiki-page-toc)', 'Page ToC'],
      \   'T' : ['<plug>(wiki-page-toc-local)', 'Page ToC Local'],
      \  },
      \ }
let g:wiki_mappings_local = {
      \ '<plug>(wiki-link-open)' : '<cr>',
      \ '<plug>(wiki-link-return)' : '<bs>',
      \}
" }}}

" x {{{
let g:which_key_map.x = {
    \ 'name' : '+extra'        ,
    \ 'd' :  ['StripWhitespace', 'trim-whitespaces'] ,
    \ }
" }}}

" z {{{
let g:which_key_map.z = {
    \ 'name' : '+zoom'    ,
    \ '+' :  ['zoom-in']  ,
    \ '=' :  ['zoom-in']  ,
    \ '-' :  ['zoom-out'] ,
    \ }

noremap <silent><leader>z+ :Bigger<CR>
noremap <silent><leader>z- :Smaller<CR>
" }}}

" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

" }}}

