" Reference:
" https://github.com/jalvesaq/Nvim-R/issues/151
" https://github.com/jalvesaq/Nvim-R/issues/125
function! SendCmdToR_Windows(...)
  if g:R_clear_line
    let cmd = "\001" . "\013" . a:1 . "\n"
  else
    let cmd = a:1 . "\n"
  endif
  let cmd = iconv(cmd, "UTF-8", "cp936")
  call JobStdin(g:rplugin.jobs["ClientServer"], "\003" . cmd)
  return 1
endfunction
