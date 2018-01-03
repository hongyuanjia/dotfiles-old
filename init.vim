" Dark powered mode of SpaceVim, generated by SpaceVim automatically.
let g:spacevim_enable_debug = 1
let g:spacevim_realtime_leader_guide = 1
call SpaceVim#layers#load('incsearch')
call SpaceVim#layers#load('autocomplete')
call SpaceVim#layers#load('lang#python')
call SpaceVim#layers#load('lang#vim')
call SpaceVim#layers#load('shell')
call SpaceVim#layers#load('tools#screensaver')
call SpaceVim#layers#load('indentmove')
let g:spacevim_enable_vimfiler_welcome = 1
let g:deoplete#auto_complete_delay = 10
let g:spacevim_enable_tabline_filetype_icon = 1
let g:spacevim_enable_statusline_display_mode = 0
let g:spacevim_enable_os_fileformat_icon = 1
let g:spacevim_buffer_index_type = 1
if has('python3')
    let g:ctrlp_map = ''
    nnoremap <silent> <C-p> :Denite file_rec<CR>
endif

" Custom for SpaceVim {{{
" load extra packages or load lazy loaded package when start
let g:spacevim_custom_plugins = [
      \ ['jalvesaq/Nvim-R'],
      \ ['roxma/nvim-completion-manager'],
      \ ['roxma/vim-hug-neovim-rpc'],
      \ ['gaalcaras/ncm-R'],
      \ ['vim-pandoc/vim-pandoc'],
      \ ['vim-pandoc/vim-rmarkdown'],
      \ ['ntpeters/vim-better-whitespace', {'on_cmd' : 'EnableStripWhitespaceOnSave'}],
      \ ['ujihisa/neco-look', {'merged' : 0}]
      \ ]

" Set SpaceVim buffer index type
let g:spacevim_buffer_index_type = 4
" Set SpaceVim windows index type
let g:spacevim_windows_index_type = 3
let g:spacevim_github_username = 'hongyuanjia'
" For speed concern
let g:spacevim_enable_vimfiler_welcome = 0
" My favourite
let g:spacevim_colorscheme = 'molokai'
" Use `ultisnips` instead of `neosnippet`
let g:spacevim_snippet_engine = 'ultisnips'
let g:python3_host_prog = 'C:\\Python36\\python.exe'
" Remove minor mode
let g:spacevim_statusline_left_sections =
            \ [
            \ 'winnr',
            \ 'filename',
            \ 'major mode',
            \ 'version control info'
            \ ]
let g:spacevim_default_indent = 4
let g:spacevim_max_column = 80
let g:better_whitespace_filetypes_blacklist = [
            \ 'startify',
            \ 'diff',
            \ 'gitcommit',
            \ 'unite',
            \ 'qf',
            \ 'help',
            \ 'markdown',
            \ 'leaderGuide'
            \ ]
" }}} Custom
" GUI {{{
set guifont=DroidSansMonoForPowerline\ NF:h12
set guifontwide=SimHei:h12
autocmd ColorScheme * highlight Folded guifg = SlateGray
"}}}
" Set folding method for specfic file types {{{
augroup ft_vim
    au!
au FileType vim setlocal foldmethod=marker
au FileType r setlocal foldmethod=marker
augroup END
" }}}
" Commentary strings for different file types {{{
augroup plugin_commentary
    au!
    au FileType python setlocal commentstring=#%s
    au FileType idf setlocal commentstring=!\ %s
    au FileType osm setlocal commentstring=!\ %s
augroup END
" }}}
" EnergyPlus file type {{{
augroup ft_idf
    au!
    au BufRead,BufNewFile *.idf set filetype=idf
    au BufRead,BufNewFile *.epmidf set filetype=idf
    au BufRead,BufNewFile *.imf set filetype=idf
    au BufRead,BufNewFile *.ddy set filetype=idf
    au BufRead,BufNewFile *.osm set filetype=osm
augroup END
" }}}
" Auto quit R when close Vim {{{
autocmd VimLeave * if exists("g:SendCmdToR") && string(g:SendCmdToR) != "function('SendCmdToR_fake')" | call RQuit("nosave") | endif
" }}}
" Insert '%>%' pipe '.[]' operator in R {{{
augroup r_pipe
    autocmd!
    autocmd FileType R inoremap <buffer> ½ <c-v><Space>%>%<c-v><Space>
    autocmd FileType R inoremap <buffer> <M-=> <c-v><Space>%>%<c-v><Space>
    autocmd FileType R inoremap <buffer> ® .[]
    autocmd FileType R inoremap <buffer> <M-.> .[]
    autocmd FileType R inoremap <buffer> <M-;> <c-v><Space>:=<c-v><Space>
    autocmd FileType R inoremap <buffer> <C-o> <C-x><C-o>
augroup END
" }}}
" Nvim-R {{{
let rmd_syn_hl_chunk = 1
" not losing focus every time that you generate the pdf
let R_openpdf = 1
" highlight R functions only if the `(` is typed
let R_hl_fun_paren = 1
let R_hl_term = 1
let R_listmethods = 1
" lists the arguments of a function, but and also the arguments of its methods
let R_objbr_opendf = 0
let Rout_more_colors = 1
let R_objbr_openlist = 0
" show a preview window of function arguments description and arguments
let R_show_arg_help = 1
let R_commented_lines = 1
let R_assign_map = "<M-->"
" clear R Console line before sending commands~
let R_clear_line = 1
let R_source_args = "print.eval = TRUE, max.deparse.length = 1000, echo = TRUE, encoding = 'UTF-8'"
let R_in_buffer = 0
" }}}
" Auto delete trailing spaces when saving R, vim files {{{
autocmd FileType r,vim autocmd BufEnter <buffer> EnableStripWhitespaceOnSave
" }}}
" better default {{{
" No annoying sound on errors
set noerrorbells
set novisualbell
set visualbell t_vb=
set noerrorbells
set novisualbell
set visualbell t_vb=
set clipboard+=unnamed
let maplocalleader = ","
" keybindings {{{
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
" Move to the start of line
nnoremap H ^
vnoremap H ^
" Move to the end of line
nnoremap L $
vnoremap L $
" Quick command mode
nnoremap ; :
nnoremap : ;
" Easy move using <Ctrl>[aedhjkl] {{{
" Insert mode shortcut
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
" Bash like
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Delete>
" Command mode shortcut
cnoremap <C-h> <left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Delete>
" }}}
" }}}
" Case sensitive when uc present
set smartcase
set dictionary+=$HOME/.SpaceVim.d/dict/english.dic
" formatoptions {{{
set formatoptions+=M "don't insert a space before or after a multi-byte when join
set formatoptions+=m "Multibyte line breaking
set formatoptions+=j "Remove a comment leader when joining
set formatoptions+=q "New line will start with a commen leader
set formatoptions+=n "When formatting text, recognize numbered lists
"}}}
set complete+=k
set list!
set listchars=tab:→\ ,trail:·,precedes:«,extends:»,eol:¶
" }}}
" ToggleSlash {{{
function! ToggleSlash(independent) range
    let from = ''
    for lnum in range(a:firstline, a:lastline)
        let line = getline(lnum)
        let first = matchstr(line, '[/\\]')
        if !empty(first)
            if a:independent || empty(from)
                let from = first
            endif
            let opposite = (from == '/' ? '\' : '/')
            call setline(lnum, substitute(line, from, opposite, 'g'))
        endif
    endfor
endfunction
command! -bang -range ToggleSlash <line1>,<line2>call ToggleSlash(<bang>1)
nnoremap <Leader>r<BSlash> :ToggleSlash<CR>
" }}}

if executable('pt')
    let g:unite_source_grep_command='pt'
    let g:unite_source_grep_default_opts='--nocolor --nogroup --smart-case'
    let g:unite_source_grep_recursive_opt=''
    let g:unite_source_grep_encoding='utf-8'
    let g:unite_source_rec_async_command= ['pt', '--nocolor', '--nogroup', '-g', '.']
endif
