" save config in .vim folder
let g:coc_config_home = $HOME.'/.vim'

" install plugins
let g:coc_global_extensions = [
    \ 'coc-git',
    \ 'coc-github',
    \ 'coc-gitignore',
    \ 'coc-lists',
    \ 'coc-dictionary',
    \ 'coc-word',
    \ 'coc-yank',
    \ 'coc-snippets',
    \ 'coc-json',
    \ 'coc-r-lsp',
    \ 'coc-vimlsp'
    \ ]

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

" use `[e` and `]e` to navigate diagnostics
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

" remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use `[g` and `]g` to navigate git chunk
nmap gs <Plug>(coc-git-chunkinfo)
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show commit contains current position
nmap gC <Plug>(coc-git-commit)

" use gK to show documentation in preview window
nnoremap <silent> gK :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        let l:found = CocAction('doHover')
    endif
endfunction

nnoremap <silent> <Leader>tt :<C-u>Vista!!<CR>
nnoremap <silent> <Leader>ts :<C-u>Vista show<CR>
nnoremap <silent> <Leader>to :<C-u>Vista toc<CR>
