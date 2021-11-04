let s:is_v_mode = 0
let s:cur_line = 0
let s:start_col = 0
let s:end_col = 0

call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#reg#init()',
      \ 'accept': 'te#ctrlp#reg#accept',
      \ 'lname': 'register',
      \ 'sname': 'reg',
      \ 'type': 'line',
      \ 'sort': 0,
      \ 'specinput': 0,
      \ })

let s:text = []
function! te#ctrlp#reg#init() abort
  return s:text
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! te#ctrlp#reg#id() abort
    return s:id
endfunction

function! te#ctrlp#reg#accept(mode, str) abort
    call ctrlp#exit()
    let l:pos = stridx(a:str, ':')
    let l:cmd = ""
    if s:is_v_mode == 1
        let l:cmd = "normal! ".s:start_col."|"."v".s:end_col."|"
    else
        let l:cmd = "normal! "
    endif
    if !l:pos
        let l:pos = stridx(a:item[1], '::')
        if l:pos == 0
            let l:cmd .= "\"\:p"
        else
            let l:cmd .= "\"\"p"
        endif
    else
        let l:str = a:str[0:pos-1]
        let l:cmd .= "\"".l:str."p"
    endif
    execute l:cmd
endfunction

function! te#ctrlp#reg#start(is_v_mode) abort
    let s:is_v_mode = a:is_v_mode
    if a:is_v_mode
        let s:cur_line = line('.')
        let s:start_col = col("'<")
        let s:end_col = col("'>")
    endif
    let s:text = te#utils#get_reg()
    call ctrlp#init(te#ctrlp#reg#id()) 
endfunction
