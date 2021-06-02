" LaTeX ------------------------------------------------------------------------

Plug 'lervag/vimtex', {'for': ['tex', 'rmd']}
    let g:vimtex_fold_enabled=1
    if has("win32")
        let g:vimtex_view_general_viewer="SumatraPDF"
    endif
