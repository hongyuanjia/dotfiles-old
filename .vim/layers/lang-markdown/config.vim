let g:vmt_auto_update_on_save = 0
let g:vmt_dont_insert_fence = 0
let g:vim_markdown_toc_autofit = 1
let g:vmt_fence_text = get(g:, 'g:vmt_fence_text', 'TOC')
let g:vmt_fence_closing_text = get(g:, 'g:vmt_fence_closing_text', '/TOC')

let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_echo_preview_url = 1
let g:mkdp_preview_options = {
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1
    \ }
let g:mkdp_page_title = '「${name}」'
