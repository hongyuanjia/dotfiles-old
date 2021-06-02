" Autocompletion ---------------------------------------------------------------

" finder and dispatcher
Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }
    " Ivy-like file explorer
    nnoremap <silent><Leader>ff :<C-u>Clap! filer<CR>
    " locate files under cursor
    nnoremap <silent><Leader>gf :<C-u>Clap! files ++query=<cword><CR>
    " locate files under selection
    xnoremap <silent><Leader>gf :<C-u>Clap! files ++query=@visual<CR><CR>
    " grep on the fly using current word
    nnoremap <silent><Leader>gg :<C-u>Clap! grep ++query=<cword><CR>
    " grep on the fly using current selection
    xnoremap <silent><Leader>gg :<C-u>Clap! grep ++query=@visual<CR><CR>
    " search current word in tags
    nnoremap <silent><Leader>gt :<C-u>Clap! tags ++query=<cword><CR>
    " search current selection in tags
    xnoremap <silent><Leader>gt :<C-u>Clap! tags ++query=@visual<CR><CR>
    " search current word in current buffer
    nnoremap <silent><Leader>g* :<C-u>Clap! blines ++query=<cword><CR>
    " search current selection in current buffer
    xnoremap <silent><Leader>g* :<C-u>Clap! blines ++query=@visual<CR>
    " search command history
    nnoremap <silent><Leader>s; :<C-u>Clap! command_history<CR>
    " search buffers
    nnoremap <silent><Leader>sb :<C-u>Clap! buffers<CR>
    " search colorschemes
    nnoremap <silent><Leader>sc :<C-u>Clap! colors<CR>
    " search all available command
    nnoremap <silent><Leader>sC :<C-u>Clap! command<CR>
    " search files
    nnoremap <silent><Leader>sf :<C-u>Clap! files<CR>
    " search files under git
    nnoremap <silent><Leader>sF :<C-u>Clap! gfiles<CR>
    " grep on the fly
    nnoremap <silent><Leader>sg :<C-u>Clap! grep<CR>
    " grep on the fly with cache
    nnoremap <silent><Leader>sG :<C-u>Clap! grep2<CR>
    " search help tags
    nnoremap <silent><Leader>sh :<C-u>Clap! help_tags<CR>
    " search in current buffer
    nnoremap <silent><Leader>si :<C-u>Clap! blines<CR>
    " search jumps
    nnoremap <silent><Leader>sj :<C-u>Clap! jumps<CR>
    " definitions/references using regexp with grep fallback
    nnoremap <silent><Leader>sJ :<C-u>Clap! dumb_jump<CR>
    " search in all open buffers
    nnoremap <silent><Leader>sl :<C-u>Clap! lines<CR>
    " search entries of the location list
    nnoremap <silent><Leader>sL :<C-u>Clap! loclist<CR>
    " search marks
    nnoremap <silent><Leader>sm :<C-u>Clap! marks<CR>
    " search all key mappings
    nnoremap <silent><Leader>sM :<C-u>Clap! maps<CR>
    " search quickfix list
    nnoremap <silent><Leader>sq :<C-u>Clap! quickfix<CR>
    " search tags
    nnoremap <silent><Leader>st :<C-u>Clap! tags<CR>
    " search tags in current project
    nnoremap <silent><Leader>sT :<C-u>Clap! proj_tags<CR>
    " search windows
    nnoremap <silent><Leader>sw :<C-u>Clap! windows<CR>
    " search registers
    nnoremap <silent><Leader>sy :<C-u>Clap! yanks<CR>

" integrate Coc with Clap
Plug 'vn-ki/coc-clap'
    " search outlines
    nnoremap <silent><Leader>so :<C-u>Clap! coc_outline<CR>
    " search symbols
    nnoremap <silent><Leader>ss :<C-u>Clap! coc_symbol<CR>
    " search actions
    nnoremap <silent><Leader>ss :<C-u>Clap! coc_action<CR>
    " list diagnostics
    nnoremap <silent><Leader>le :<C-u>Clap! coc_diagnostics<CR>
    " list tags
    nnoremap <silent><Leader>lt :<C-u>Vista!!<CR>

" insert documentation template
Plug 'kkoomen/vim-doge', { 'on': [] }

" snippets
Plug 'honza/vim-snippets'

