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

let s:text = []
function! te#ctrlp#dir#init() abort
  return s:text
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
"press ctrl-v will not exit ctrlp
function! te#ctrlp#dir#accept(mode, str) abort
    let l:file_or_dir=matchstr(a:str,".*[^@]")
    "enter will cd else open netrw
    if isdirectory(l:file_or_dir) && a:mode ==# 'e' 
        call ctrlp#exit()
        execute 'cd 'l:file_or_dir
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
        execute l:HowToOpen.' '.l:file_or_dir
    endif
endfunction

function! te#ctrlp#dir#id() abort
  return s:id
endfunction

function! te#ctrlp#dir#start() abort
    if te#env#IsWindows()
        let s:text = te#compatiable#systemlist('dir /B /D')
        let l:text_dir=filter(deepcopy(s:text),'isdirectory(v:val)')
        call filter(s:text,'isdirectory(v:val) == 0')
        call map(l:text_dir, 'v:val."\\"')
        call extend(s:text, l:text_dir)
        call add(s:text, '..\')
    else
        let s:text = te#compatiable#systemlist('ls -a -F')
    endif
    call ctrlp#init(te#ctrlp#dir#id()) 
endfunction
