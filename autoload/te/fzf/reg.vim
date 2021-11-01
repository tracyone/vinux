
function! s:edit_file(item) abort
    if len(a:item) < 2 | return | endif
    "let l:pos = stridx(a:item[1], ':')
    "let l:str = a:item[1][pos+1:-1]
    "call setline(".", l:str)
    let l:pos = stridx(a:item[1], ':')
    let l:str = a:item[1][0:pos-1]
    execute "normal! \"".l:str."p"
endfunction

function! te#fzf#reg#get_reg(reg)
    let l:dict = getreginfo(a:reg)
    if has_key(l:dict, 'regcontents')
        return l:dict.regcontents[0]
    endif
    return ""
endfunction

function! te#fzf#reg#start() abort
    let l:regs = [ '"', '0', '1', '2', '3', '4', '5', '6', 'w', 'b']
    let l:run_dict = {
                \ 'source': map(l:regs, 'v:val.":".te#fzf#reg#get_reg(v:val)'),
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
