scriptencoding utf-8


let s:save_cpo = &cpo
set cpo&vim


"
" api:
"


function! metarw#rw#complete(arglead, cmdline, cursorpos) abort "{{{
  let _ = metarw#rw#read('rw:')
  if _[0] ==# 'browse'
    return [map(_[1], 'v:val.fakepath'), a:cmdline, '']
  else
    return [[], a:cmdline, '']
  endif
endfunction "}}}


function! metarw#rw#read(fakepath) abort "{{{
  let _ = s:parse_incomplete_fakepath(a:fakepath)
  if empty(_.path)
    return metarw#rw#read(_.scheme . ':' . getcwd())
  elseif isdirectory(_.path)
    call s:init_rw_buffer()
    return ['browse',
          \ [{'label' : '../',
          \   'fakepath' : _.scheme . ':' . fnamemodify(_.path, ':p:h:h'),
          \ }] +
          \ map(glob(_.path . '/*', !0, !0), '{
          \   "label" : empty(fnamemodify(v:val, ":p:t"))
          \             ? fnamemodify(v:val, ":p:h:t") . "/"
          \             : fnamemodify(v:val, ":p:t"),
          \   "fakepath" : _.scheme . ":" . v:val,
          \ }')]
  elseif filereadable(_.path)
    return ['read', _.path]
  else
    return ['error', 'invalid path.']
  endif
endfunction "}}}


function! metarw#rw#write(fakepath, line1, line2, append_p) abort "{{{
  let _ = s:parse_incomplete_fakepath(a:fakepath)
  if filereadable(_.path)
    return ['write', _.path]
  else
    return ['error', 'failed to write.']
  endif
endfunction "}}}


"
" helper:
"


function! s:parse_incomplete_fakepath(incomplete_fakepath) abort "{{{
  let _ = {}
  let fragments = split(a:incomplete_fakepath, ':', !0)
  let _.fakepath = a:incomplete_fakepath
  let _.scheme = fragments[0]
  let _.path = len(fragments) > 1 ? expand(join(fragments[1:], ':')) : ''
  return _
endfunction "}}}


" The result is a list.
" 1st element is a boolean.
" 2nd element is a dictionary which has two keys; `label` and `fakepath`.
function! s:get_item() abort "{{{
  let i = line('.') - b:metarw_base_linenr
  return 0 <= i && i < len(b:metarw_items)
        \ ? [v:true, b:metarw_items[i]]
        \ : [v:false, {'label' : '', 'fakepath' : ''}]
endfunction "}}}


function! s:get_fakepath() abort "{{{
  let [status, item] = s:get_item()
  return status && has_key(item, 'fakepath')
        \ ? [v:true, item.fakepath]
        \ : [v:false, '']
endfunction "}}}


function! s:init_rw_buffer() abort "{{{
  setfiletype metarw.rw

  nnoremap <buffer><expr> <Plug>(metarw-rw-open-external) <SID>open_external()
  nnoremap <buffer><expr> <Plug>(metarw-rw-create-file) <SID>create_file()
  nnoremap <buffer><expr> <Plug>(metarw-rw-create-directory) <SID>create_directory()
  nnoremap <buffer><expr> <Plug>(metarw-rw-rename) <SID>rename()
  nnoremap <buffer><expr> <Plug>(metarw-rw-delete) <SID>delete()

  if !get(g:, 'metarw_rw_no_default_key_mappings', 0)
    nmap <buffer> x <Plug>(metarw-rw-open-external)
    nmap <buffer> Cf <Plug>(metarw-rw-create-file)
    nmap <buffer> Cd <Plug>(metarw-rw-create-directory)
    nmap <buffer> R <Plug>(metarw-rw-rename)
    nmap <buffer> D <Plug>(metarw-rw-delete)
  endif
endfunction "}}}


"
" action:
"


function! s:open_external() abort "{{{
  let [status, fakepath] = s:get_fakepath()
  if status
    let _ = s:parse_incomplete_fakepath(fakepath)
    call rw#echo('open: ' . _.path)
    call rw#open_external(_.path)
  endif
endfunction "}}}


function! s:create_file() abort "{{{
  call rw#echo('create_file is not implemented.')
endfunction "}}}


function! s:create_directory() abort "{{{
  call rw#echo('create_directory is not implemented.')
endfunction "}}}


function! s:rename() abort "{{{
  call rw#echo('rename is not implemented.')
endfunction "}}}


function! s:delete() abort "{{{
  call rw#echo('delete is not implemented.')
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo
