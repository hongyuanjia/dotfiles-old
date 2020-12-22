if exists('g:fvim_loaded')
    " good old 'set guifont' compatibility
    set guifont=DejaVuSansMono\ NF:h14

    " Title bar tweaks, themed with colorscheme
    FVimCustomTitleBar v:true

    " Disable external popup menu
    FVimUIPopupMenu v:false

    " Font rendering tweaking
    FVimFontAntialias v:true
    FVimFontAutohint v:true
    FVimFontHintLevel 'full'

    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
endif
