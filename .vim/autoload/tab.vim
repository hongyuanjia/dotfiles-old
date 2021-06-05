" Most of functions are adapted from 'liuchengxu/space-vim'
let s:sep = ['', '']
let s:right_sep = ['', '']

function! s:get_color(group, attr) abort
  return synIDattr(synIDtrans(hlID(a:group)), a:attr)
endfunction

function! s:use_gui() abort
  return has('gui_running') || (has('termguicolors') && &termguicolors)
endfunction

function! s:bufname(bufnr) abort
  let l:file = bufname(a:bufnr)

  if l:file ==# ''
    return '[No Name] '
  endif

  let l:buftype = getbufvar(a:bufnr, 'buftype')

  if l:buftype ==# 'nofile'
    if l:file =~# '\/.'
      let l:file = substitute(l:file, '.*\/\ze.', '', '')
    endif
  else
    let l:file = fnamemodify(l:file, ':p:t')
  endif

  return l:file.' '
endfunction

function! s:bufnr(tabnr) abort
  let buflist = tabpagebuflist(a:tabnr)
  let winnr = tabpagewinnr(a:tabnr)
  return buflist[winnr - 1]
endfunction

function! s:append_common(str, tabnr, bufnr) abort
  let str = a:str
  let str .= ' '.a:tabnr.':'.s:bufname(a:bufnr)
  if getbufvar(a:bufnr, "&mod")
    let str .= '[+]'
  endif
  return str
endfunction

function! s:get_attrs(fg, bg) abort
  let fg = call(function('s:get_color'), a:fg)
  let bg = call(function('s:get_color'), a:bg)
  let g_c = s:use_gui() ? 'gui' : 'cterm'
  return printf('%sfg=%s %sbg=%s', g_c, fg, g_c, bg)
endfunction

function! s:hi() abort
  hi TabLineSel ctermfg=232 ctermbg=178 guifg=#333300 guibg=#ffbb7d
  hi TabLine    ctermfg=178 ctermbg=243 guifg=#ffbb7d guibg=#767676

  hi! link TabLineFill StatusLine

  execute 'hi TabLineActiveSep'       s:get_attrs(['TabLine'    , 'bg'] , ['TabLineSel' , 'bg'])
  execute 'hi TabLineInactiveSep'     s:get_attrs(['TabLineSel' , 'bg'] , ['TabLine'    , 'bg'])
  execute 'hi TabLineLastActiveSep'   s:get_attrs(['TabLine'    , 'bg'] , ['StatusLine' , 'bg'])
  execute 'hi TabLineLastInactiveSep' s:get_attrs(['TabLineSel' , 'bg'] , ['StatusLine' , 'bg'])

  execute 'hi TabLineRightXSep'       s:get_attrs(['TabLineSel' , 'bg'] , ['StatusLine' , 'bg'])
  execute 'hi TabLineRightX'          s:get_attrs(['TabLineSel' , 'bg'] , ['StatusLine' , 'bg'])
  execute 'hi TabLineRightSep'        s:get_attrs(['TabLineSel' , 'bg'] , ['StatusLine' , 'bg'])
  execute 'hi TabLineRightTabs'       s:get_attrs(['TabLine'    , 'bg'] , ['TabLineSel' , 'bg'])
endfunction

function! tab#TabLine()
  let tabline = ''

  let last_tabnr = tabpagenr('$')

  for tabnr in range(1, last_tabnr)

    let tabline .= '%'.tabnr.'T'

    let bufnr = s:bufnr(tabnr)

    if tabnr == tabpagenr()
      let tabline .= '%#TabLineActiveSep#'.s:sep[0].'%*'.'%#TabLineSel#'
      let tabline = s:append_common(tabline, tabnr, bufnr)

      if tabnr == last_tabnr
        let tabline .= '%#TabLineLastInactiveSep#'.s:sep[0].'%*'
      else
        let tabline .= '%#TabLineInactiveSep#'.s:sep[0].'%*'
      endif

    else

      let tabline .= '%#TabLine#'
      let tabline = s:append_common(tabline, tabnr, bufnr)

      if tabnr == last_tabnr
        let tabline .= '%#TabLineLastActiveSep#'.s:sep[0].'%*'
      else
        let tabline .= '%#TabLineInactiveSep#'.s:sep[1].'%*'
      endif
    endif

  endfor

  let tabline .= '%#TabLineFill#%T'
  let tabline .= tabpagenr('$') > 1 ? '%=%#TabLine#%999X' : ''

  let tabline .= '%#TabLineRightXSep#'.s:right_sep[1].'%*'
  let tabline .= '%#TabLineRightX# X %*'

  let tabline .= '%#TabLineRightSep#'.s:right_sep[0].'%*'
  let tabline .= '%#TabLineRightTabs# tabs %*'

  call s:hi()

  return tabline
endfunction