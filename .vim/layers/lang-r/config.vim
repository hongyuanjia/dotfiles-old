" do not align function arguments
let r_indent_align_args = 0

" enable to go to NORMAL mode in TERMINAL mode
let R_esc_term = 0

" number of columns to be offset when calculating R terminal width
let R_setwidth = -7

" do not update $HOME on Windows since I set it manually
if has('win32')
    let R_set_home_env = 0
endif

" use 2 backticks to trigger the completion of chunk delimeter
let R_rmdchunk = '``'

" use Alt+- to insert assign (<-)
let R_assign_map = '<M-->'

" do not show elements of data.frames in Object Browser
let R_objbr_opendf = 0

" show hidden objects in Object Browser
let R_objbr_allnames = 1

" show syntax highlighting in .Rout files
let Rout_more_colors = 1

" open the .Rout file in a new split window instead of a new tab
let R_routnotab = 1

" show commented lines when sourced
let R_commented_lines = 1

" not losing focus every time that you generate the pdf
let R_openpdf = 1

" use the same working directory as Vim
let R_nvim_wd = 1

" disable omni completion since it is handled by coc-r-lsp
let R_set_omnifunc = []
let R_auto_omni = []

" highlight chunk header as R code
let rmd_syn_hl_chunk = 1

" disable R debug support
let R_debug = 0

" by default use UTF-8 encoding
let R_source_args = 'print.eval = FALSE, echo = TRUE, spaced = TRUE, encoding = "UTF-8"'

let r_syntax_fun_pattern = 1

" auto quit R when close Vim
autocmd VimLeave * if exists("g:SendCmdToR") && string(g:SendCmdToR) != "function('SendCmdToR_fake')" | call RQuit("nosave") | endif

" redefine test current file
command! -nargs=0 RTestFile :call devtools#test_file()

let g:pandoc#syntax#conceal#use=0
