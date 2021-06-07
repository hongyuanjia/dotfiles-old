" vista {{{
" show these pretty symbols
let g:vista#renderer#enable_icon = 1
let g:vista_fzf_preview = ['right:50%']
nnoremap <Leader>tt :<C-u>Vista!!<CR>
nnoremap <Leader>ts :<C-u>Vista show<CR>
nnoremap <Leader>to :<C-u>Vista toc<CR>

let g:vista_default_executive = 'ctags'

let g:vista_ctags_cmd = {
    \ 'idf': 'Rscript -e "idftags::build_idf_tags(cmd = TRUE)"'
    \ }

let s:types = {}
let s:types.lang = 'idf'
let s:types.kinds = {
    \ 'c': {'long' : 'classes', 'fold' : 0, 'stl' : 1},
    \ 'o': {'long' : 'objects', 'fold' : 0, 'stl' : 1}
    \ }
let s:types.kind2scope = {
    \ 'c' : 'class',
    \ 'o' : 'method'
    \ }
let s:types.scope2kind = {
    \ 'class'  : 'c',
    \ 'method' : 'o'
    \ }
let g:vista#types#uctags#idf# = s:types

let g:vista_executive_for = {
    \ 'rmd': 'markdown',
    \ 'markdown': 'toc'
    \ }
" }}}

" coc {{{
" save config in .vim folder
let g:coc_config_home = $HOME.'/.vim'

" install plugins
let g:coc_global_extensions = [
    \ 'coc-git',
    \ 'coc-github',
    \ 'coc-gitignore',
    \ 'coc-explorer',
    \ 'coc-lists',
    \ 'coc-dictionary',
    \ 'coc-word',
    \ 'coc-yank',
    \ 'coc-snippets',
    \ 'coc-json',
    \ 'coc-r-lsp',
    \ 'coc-vimlsp',
    \ 'coc-ci',
    \ 'coc-zi',
    \ ]

" uninstall coc extensions if not used
" https://github.com/fgheng/vime/blob/b60cdb60ed/config/plugins/coc.nvim.vim
function! s:uninstall_unused_coc_extensions() abort
    if has_key(g:, 'coc_global_extensions')
        for e in keys(json_decode(join(readfile(expand(g:coc_data_home . '/extensions/package.json')), "\n"))['dependencies'])
            if index(g:coc_global_extensions, e) < 0
                execute 'CocUninstall ' . e
            endif
        endfor
    endif
endfunction
autocmd User CocNvimInit call s:uninstall_unused_coc_extensions()

" use Tab key to trigger completion, completion confirm and snippets
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
function! s:check_back_space() abort
    let col = col('.') - 1
    return ! col || getline('.')[col - 1] =~? '\s'
endfunction
augroup user_plugin_coc
    autocmd!
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

" use <c-space>for trigger completion
inoremap <silent><expr> <C-space> coc#refresh()

" movement within 'ins-completion-menu'
imap <expr><C-j>   pumvisible() ? "\<Down>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<Up>" : "\<C-k>"

" scroll pages in menu
inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
imap     <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
imap     <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"

" enable using w/b for Chinese words
nmap <silent> w <Plug>(coc-ci-w)
nmap <silent> b <Plug>(coc-ci-b)

" use `[e` and `]e` to navigate diagnostics
nmap [e <Plug>(coc-diagnostic-prev)
nmap ]e <Plug>(coc-diagnostic-next)

" remap keys for gotos
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)

" use `[g` and `]g` to navigate git chunk
nmap gs <Plug>(coc-git-chunkinfo)
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

" code block support
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" show commit contains current position
nmap gC <Plug>(coc-git-commit)

" toggle Git Gutter
nnoremap <Leader>gG :<C-u>CocCommand git.toggleGutters<CR>
" open current file on GitHub
nnoremap <Leader>gO :<C-u>CocCommand git.browserOpen<CR>
" stage current chunk
nnoremap <Leader>gS :<C-u>CocCommand git.chunkStage<CR>
" discard current chunk
nnoremap <Leader>gU :<C-u>CocCommand git.chunkUndo<CR>
" show current chunk info
nnoremap <Leader>gC :<C-u>CocCommand git.chunkInfo<CR>
nnoremap <Leader>gI :<C-u>CocList issues<CR>
nnoremap <Leader>gD :<C-u>CocCommand git.diffCached<CR>
nnoremap <Leader>gP :<C-u>CocCommand git.push<CR>
nnoremap <Leader>gH :<C-u>CocList bcommits<CR>
nnoremap <Leader>gW :<C-u>CocList commits<CR>
nnoremap <Leader>gB :<C-u>CocList branches<CR>
nnoremap <Leader>gZ :<C-u>CocCommand git.foldUnchanged<CR>

" use gK to show documentation in preview window
nnoremap gK :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        let l:found = CocAction('doHover')
    endif
endfunction

" <Leader>?
nnoremap <Leader>? :<C-u>CocList maps<CR>

" <Leader>b
" search buffers
nnoremap <Leader>bb :<C-u>CocList buffers<CR>

" <Leader>f
" file explorer
nnoremap <Leader>ft :<C-u>CocCommand explorer<CR>
" search files
nnoremap <Leader>ff :<C-u>CocList files<CR>
" search files in Git
nnoremap <Leader>fg :<C-u>CocList gfiles<CR>
" search in home directory
nnoremap <Leader>f? :<C-u>CocList files ~<CR>
" search history files
nnoremap <Leader>fh :<C-u>CocList -A mru<CR>
" edit coc-setting.json
nnoremap <Leader>fc :<C-u>CocConfig<CR>

function! s:GrepFromSelected(type)
    let saved_unnamed_register = @@
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif
    let word = substitute(@@, '\n$', '', 'g')
    let word = escape(word, '| ')
    let @@ = saved_unnamed_register
    execute 'CocList -I -A grep '.word
endfunction

function! s:WordsFromSelected(type)
    let saved_unnamed_register = @@
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif
    let word = substitute(@@, '\n$', '', 'g')
    let word = escape(word, '| ')
    let @@ = saved_unnamed_register
    execute 'CocList --normal -A words '.word
endfunction

" <Leader>G search under cursor
" locate files under cursor
nnoremap <Leader>Gf :<C-u>call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<CR>
" grep on the fly using current word
nnoremap <Leader>Gg :<C-u>execute 'CocList -A -I --input='.expand('<cword>').' grep'<CR>
" grep on the fly using current selection
nnoremap <leader>Gr :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@
xnoremap <leader>Gr :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
" search current word in current buffer
nnoremap <Leader>G* :<C-u>execute 'CocList --normal -A --input='.expand('<cword>').' words'<CR>
" search current selection in current buffer
xnoremap <leader>G* :<C-u>call <SID>LinesFromSelected(visualmode())<CR>

" <Leader>h
nnoremap <Leader>h :<C-u>CocList helptags<CR>

" <Leader>s
" search command history
nnoremap <Leader>s; :<C-u>CocList cmdhistory<CR>
" search buffers
nnoremap <Leader>sb :<C-u>CocList buffers<CR>
" search colorschemes
nnoremap <Leader>sc :<C-u>CocList colors<CR>
" search all available command
nnoremap <Leader>sC :<C-u>CocList commands<CR>
" search files
nnoremap <Leader>sf :<C-u>CocList files<CR>
" search files under git
nnoremap <Leader>sF :<C-u>CocList gfiles<CR>
" grep on the fly
nnoremap <Leader>sg :<C-u>CocList -I -A grep<CR>
" search help tags
nnoremap <Leader>sh :<C-u>CocList helptags<CR>
" search in current buffer
nnoremap <Leader>sl :<C-u>CocList lines<CR>
" search entries of the location list
nnoremap <Leader>sL :<C-u>CocList locationlist<CR>
" search marks
nnoremap <Leader>sm :<C-u>CocList marks<CR>
" search all key mappings
nnoremap <Leader>sM :<C-u>CocList maps<CR>
" search quickfix list
nnoremap <Leader>sq :<C-u>CocList quickfix<CR>
" search registers
nnoremap <Leader>sr :<C-u>CocList registers<CR>
" search tags
nnoremap <Leader>st :<C-u>Vista finder<CR>
" search Vim command
nnoremap <Leader>sv :<C-u>CocList vimcommands<CR>
" search windows
nnoremap <Leader>sw :<C-u>CocList windows<CR>
" search registers
nnoremap <Leader>sy :<C-u>CocList -A yank<CR>
" search outlines
nnoremap <Leader>so :<C-u>CocList -A outline<CR>
" search symbols
nnoremap <Leader>ss :<C-u>CocList symbols<CR>
" search snippets
nnoremap <Leader>sS :<C-u>CocList -A snippets<CR>
" list resume
nnoremap <Leader>sR :<C-u>CocListResume<CR>
" list all available lists
nnoremap <Leader>sO :<C-u>CocList lists<CR>

" <Leader>S
nnoremap <Leader>Sl :<C-u>CocList sessions<CR>
nnoremap <Leader>Ss :<C-u>CocCommand session.save<CR>

" <Leader>l
" list symbol
nnoremap <Leader>ls :<C-u>CocList symbols<CR>
" list sessions
nnoremap <Leader>lS :<C-u>CocList sessions<CR>
" list outline
nnoremap <Leader>lo :<C-u>CocList -A --normal outline<CR>
" list diagnostics
nnoremap <Leader>le :<C-u>CocList --normal diagnostics<CR>
" list tags
nnoremap <Leader>lt :<C-u>Vista!!<CR>
" list commit for current buffer
nnoremap <Leader>lc :<C-u>CocList --normal bcommits<CR>
" list commit for current project
nnoremap <Leader>lC :<C-u>CocList commits<CR>
" list registers
nnoremap <Leader>sy :<C-u>CocList -A --normal yank<CR>
" list resume
nnoremap <Leader>lR :<C-u>CocListResume<CR>
" list coc commands
nnoremap <Leader>ll :<C-u>CocCommand<CR>

" <Leader>w
nnoremap <Leader>w? :<C-u>CocList windows<CR>
" }}}

" gutentags {{{
let g:gutentags_exclude_filetypes = ['tags']
let g:gutentags_resolve_symlinks = 1
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_ctags_executable_idf = 'Rscript -e "idftags::build_idf_tag(cmd = TRUE)"'

let g:gutentags_cache_dir = expand($HOME.'/.vim/tmp')

if !isdirectory(g:gutentags_cache_dir)
    call mkdir(g:gutentags_cache_dir, 'p')
endif

let g:gutentags_plus_switch = 0
" }}}
