scriptencoding utf-8


let s:save_cpo = &cpo
set cpo&vim


"
" util:
"


function! rw#echo(mes) abort "{{{
  if hlexists('Comment')
    echohl Comment | echo a:mes | echohl None
  else
    echo a:mes
  endif
endfunction "}}}


function! rw#open_external(path) abort "{{{
  if isdirectory(a:path)
    call external#explorer(a:path)
  else
    call external#open(a:path)
  endif
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo
