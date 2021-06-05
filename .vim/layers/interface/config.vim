" startify {{{
let g:startify_list_order = [
    \ ['   Recent Files:'],
    \ 'files',
    \ ['   Project:'],
    \ 'dir',
    \ ['   Sessions:'],
    \ 'sessions',
    \ ['   Bookmarks:'],
    \ 'bookmarks',
    \ ['   Commands:'],
    \ 'commands',
    \ ]
let g:startify_change_to_vcs_root = 1
nnoremap <Leader>bh :Startify<CR>
" }}}

" eleline {{{
let g:eleline_powerline_fonts = 1
" }}}

" indentLine {{{
let g:indentLine_char = '¦'
let g:indentLine_enabled = 1
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#4A9586'
let g:indentLine_concealcursor = 'vc'
let g:indentLine_fileTypeExclude= ['help', 'startify', 'coc-explorer']
nnoremap <Leader>ti :<C-u>IndentLinesToggle<CR>
" }}}

" anzu {{{
nmap n <Plug>(is-nohl)<Plug>(anzu-n-with-echo)
nmap N <Plug>(is-nohl)<Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
" }}}

" maximizer {{{
" do not use the default mapping (F3)
let g:maximizer_set_default_mapping = 0
nnoremap <Leader>wm :<C-u>MaximizerToggle!<CR>
" }}}

" choosewin {{{
" use - to choose window
nmap - <Plug>(choosewin)
" }}}

" which-key {{{
set timeoutlen=500
" use which-key
autocmd! FileType which_key

" do not show statusline in which-key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

nnoremap  <Leader>      :<C-u>WhichKey '<Space>'<CR>
vnoremap  <Leader>      :<C-u>WhichKeyVisual '<Space>'<CR>

nnoremap  <LocalLeader> :<C-u>WhichKey  ','<CR>
vnoremap  <LocalLeader> :<C-u>WhichKeyVisual ','<CR>

let g:which_key_map =  {}
let g:which_key_map['name'] = 'Mappings'

for s:i in range(1, 9)
    let g:which_key_map[s:i] = 'window-'.s:i
endfor
unlet s:i

" <Leader>?
let g:which_key_map['?'] = 'show-keybindings'

" <Leader>;
let g:which_key_map[';'] = 'commenter'

" <Leader><Leader>
let g:which_key_map[' '] = { 'name' : '+tab' }
for s:i in range(1, 9)
    let g:which_key_map[' '][s:i] = 'tab-'.s:i
endfor
unlet s:i

" <Leader>a
let g:which_key_map.a = { 'name': '+arguments' }

" <Leader>b
let g:which_key_map['b'] = { 'name' : '+buffer' }
for s:i in range(1, 9)
    let g:which_key_map['b'][s:i] = 'buffer-'.s:i
endfor
unlet s:i

" <Leader>c
let g:which_key_map.c = { 'name' : '+code' }

" <Leader>d
let g:which_key_map['d'] = 'scroll-down'

" <Leader>e
let g:which_key_map['e'] = { 'name' : '+errors' }

" <Leader>f
let g:which_key_map['f'] = { 'name' : '+find/files/fold' }
for s:i in range(0, 9)
    let g:which_key_map['f'][s:i] = s:i.'-fold-level'
endfor
unlet s:i

" <Leader>g
let g:which_key_map['g'] = { 'name' : '+git'}

" <Leader>G
let g:which_key_map['G'] = { 'name' : '+grep'}

" <Leader>h
let g:which_key_map['h'] = 'help-tags'

" <Leader>j
let g:which_key_map['j'] = { 'name' : '+jumps'}

" <Leader>l
let g:which_key_map['l'] = { 'name' : '+list'}

" <Leader>o
let g:which_key_map.o = {
    \ 'name' : '+open'    ,
    \ 'q' : 'open-quickfix'     ,
    \ 'l' : 'open-locationlist' ,
    \ }

" <Leader>p
let g:which_key_map['p'] = { 'name' : '+projects'}

" <Leader>q
let g:which_key_map['q'] = 'quit'
let g:which_key_map['Q'] = 'quit-without-saving'

" <Leader>r
let g:which_key_map['r'] = {
    \ 'c' : 'replace-current-word-in-current-file',
    \ }

" <Leader>s
let g:which_key_map['s'] = { 'name' : '+search/show'}

" <Leader>t
let g:which_key_map['t'] = { 'name' : '+toggle/tag'}

" <Leader>u
let g:which_key_map['u'] = 'scroll-up'

" <Leader>w
let g:which_key_map['w'] = {
    \ 'name' : '+windows'                       ,
    \ 'w' :  'other-window'                     ,
    \ 'd' :  'delete-window'                    ,
    \ '-' :  'split-window-below'               ,
    \ '|' :  'split-window-right'               ,
    \ 'o' :  'close-all-windows-except-current' ,
    \ 'h' :  'window-left'                      ,
    \ 'j' :  'window-below'                     ,
    \ 'l' :  'window-right'                     ,
    \ 'k' :  'window-up'                        ,
    \ 'H' :  'expand-window-left'               ,
    \ 'J' :  'expand-window-below'              ,
    \ 'L' :  'expand-window-right'              ,
    \ 'K' :  'expand-window-up'                 ,
    \ '=' :  'balance-window'                   ,
    \ 's' :  'split-window-below'               ,
    \ 'v' :  'split-window-below'               ,
    \ }

" <Leader>x
let g:which_key_map['x'] = { 'name' : '+text'}

" <Leader>z
let g:which_key_map.z = {
    \ 'name' : '+zoom'    ,
    \ '+' :  ['zoom-in']  ,
    \ '_' :  ['zoom-out'] ,
    \ }
" }}}

" rainbow {{{
nnoremap <Leader>tR :<C-u>RainbowToggle<CR>
" }}}
