"ctrlp feature
"author:tracyone@live.cn

call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#feat#init()',
      \ 'accept': 'te#ctrlp#feat#accept',
      \ 'lname': 'feature',
      \ 'sname': 'feat',
      \ 'type': 'line',
      \ 'sort': 1,
      \ 'specinput': 0,
      \ })

function! te#ctrlp#feat#init() abort
  return s:text
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
"press ctrl-v will not exit ctrlp
function! te#ctrlp#feat#accept(mode, str) abort
    call ctrlp#exit()
    if s:enable_flag == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    call te#feat#feature_enable(s:enable_flag, a:str)
endfunction

function! te#ctrlp#feat#id() abort
  return s:id
endfunction

function! te#ctrlp#feat#start(en) abort
    let s:text = []
    for l:key in keys(te#feat#get_feature_dict())
        call add(s:text, l:key)
    endfor
    call add(s:text, 'all')
    let s:enable_flag=a:en
    call ctrlp#init(te#ctrlp#feat#id()) 
endfunction
