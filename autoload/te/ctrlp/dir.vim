"ctrlp dir
"like spacemacs SPC ff
"author:tracyone@live.cn

call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#dir#init()',
      \ 'accept': 'te#ctrlp#dir#accept',
      \ 'lname': 'dir',
      \ 'sname': 'dir',
      \ 'type': 'path',
      \ 'sort': 0,
      \ 'specinput': 0,
      \ })

let s:text = ''
function! te#ctrlp#dir#init() abort
  return s:text
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
"press ctrl-v will not exit ctrlp
function! te#ctrlp#dir#accept(mode, str) abort
    echom a:mode
    "enter will cd else open netrw
    if isdirectory(a:str) && a:mode ==# 'e' 
        call ctrlp#exit()
        execute 'cd 'a:str
        call te#ctrlp#dir#start()
    else
        call ctrlp#exit()
        if a:mode ==# 'e'
            let l:HowToOpen='e'
        elseif a:mode ==# 't'
            let l:HowToOpen='tabnew'
        elseif a:mode ==# 'v'
            let l:HowToOpen='vsplit'
        elseif a:mode ==# 'h'
            let l:HowToOpen='sp'
        else
            let l:HowToOpen='e'
        endif
        execute l:HowToOpen.' '.a:str
    endif
endfunction

function! te#ctrlp#dir#id() abort
  return s:id
endfunction

function! te#ctrlp#dir#start() abort
    let s:text = te#compatiable#systemlist('ls -a -F')
    call ctrlp#init(te#ctrlp#dir#id()) 
endfunction
