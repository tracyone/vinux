function! s:get_terminal_list()
    let l:buf_list = te#terminal#get_buf_list()
    for l:buf in l:buf_list
        let l:content = getbufline(l:buf, 1, 40)
        call writefile(l:content, g:fzf_history_dir.'/'.l:buf)
    endfor
    return l:buf_list
endfunction

function! s:open_shell(timer)
    let l:buf = str2nr(s:buf)
    call te#terminal#open_term(l:buf, str2nr(s:shell_pop_option))
    let l:buf_list = te#terminal#get_buf_list()
    for l:buf in l:buf_list
        call delete(g:fzf_history_dir.'/'.l:buf)
    endfor
endfunction

function! s:edit_file(item) abort
    if len(a:item) < 2 | return | endif
    let l:pos = stridx(a:item[1], ' ')
    let s:buf = a:item[1][pos+1:-1]
    let l:cmd = get({'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit',
                \ 'ctrl-t': 'tabedit'}, a:item[0], 'e')

    if l:cmd == 'e' || l:cmd == 'vsplit'
        let s:shell_pop_option = 0x2
    elseif l:cmd == 'split'
        let s:shell_pop_option  = 0x1
    elseif l:cmd == 'tabedit'
        let s:shell_pop_option  = 0x4
    endif
    call timer_start(100, function('<SID>open_shell'), {'repeat': 1})
endfunction

function! te#fzf#terminal#start() abort
    let l:run_dict = {
                \ 'source': <SID>get_terminal_list(),
                \ 'sink*': function('<SID>edit_file'),
                \ 'options' : ' --ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : '.
                \              '-m --prompt "Term> "',
                \ 'dir': g:fzf_history_dir,
                \ 'placeholder': '{-1}',
                \ }
    call fzf#run(fzf#wrap(fzf#vim#with_preview(l:run_dict)))
endfunction
