" Project Management -----------------------------------------------------------

" startup landing page
Plug 'mhinz/vim-startify'

" auto change working directory based on version control
Plug 'airblade/vim-rooter'
    " stop echoing
    let g:rooter_silent_chdir = 1
    " fallback to file's directory when vim-rooter failed
    let g:rooter_change_directory_for_non_project_files = 'current'
