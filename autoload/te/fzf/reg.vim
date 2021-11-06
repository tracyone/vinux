
let s:is_v_mode = 0
let s:cur_line = 0
let s:start_col = 0
let s:end_col = 0

function! s:edit_file(item) abort
    "let l:pos = stridx(a:item[1], ':')
    "let l:str = a:item[1][pos+1:-1]
    "call setline(".", l:str)
    let l:pos = stridx(a:item[0], ':')
    let l:cmd = ""
    if s:is_v_mode == 1
        let l:cmd = "normal! ".s:start_col."|"."v".s:end_col."|"
    else
        let l:cmd = "normal! "
    endif
    if l:pos == 0
        let l:pos = stridx(a:item[0], '::')
        if l:pos == 0
            let l:cmd .= "\"\:p"
        else
            let l:cmd .= "\"\"p"
        endif
    else
        let l:str = a:item[0][0:pos-1]
        let l:cmd .= "\"".l:str."p"
    endif
    execute l:cmd
endfunction


function! te#fzf#reg#start(is_v_mode) abort
    let s:is_v_mode = a:is_v_mode
    if a:is_v_mode
        let s:cur_line = line('.')
        let s:start_col = col("'<")
        let s:end_col = col("'>")
    endif
    let l:run_dict = {
                \ 'source': te#utils#get_reg(),
                \ 'sink*': function('<SID>edit_file'),
                \ 'down':'40%' ,
                \ 'options' : '-m --prompt "Reg> "',
                \ }
    if te#env#IsNvim() != 0
        :call extend(l:run_dict, {'window':'call FloatingFZF()'})
    else
        :call extend(l:run_dict, g:fzf_layout)
    endif
    call fzf#run(l:run_dict)
endfunction
