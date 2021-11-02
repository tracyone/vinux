
function! s:edit_file(item) abort
    if len(a:item) < 2 | return | endif
    "let l:pos = stridx(a:item[1], ':')
    "let l:str = a:item[1][pos+1:-1]
    "call setline(".", l:str)
    let l:pos = stridx(a:item[1], ':')
    if !l:pos
        execute "normal! \"\"p"
    else
        let l:str = a:str[0:pos-1]
        execute "normal! \"".l:str."p"
    endif
endfunction


function! te#fzf#reg#start() abort
    let l:run_dict = {
                \ 'source': te#utils#get_reg(),
                \ 'sink*': function('<SID>edit_file'),
                \ 'down':'40%' ,
                \ 'options' : ' --ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : '.
                \              '-m --prompt "Reg> "',
                \ }
    if te#env#IsNvim() != 0
        :call extend(l:run_dict, {'window':'call FloatingFZF()'})
    else
        :call extend(l:run_dict, g:fzf_layout)
    endif
    call fzf#run(l:run_dict)
endfunction
