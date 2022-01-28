function! s:get_terminal_list()
    let l:buf_list = te#terminal#get_buf_list()
    let l:result_list = []
    for l:buf in l:buf_list
        let l:line_nr = te#terminal#get_line(l:buf)
        if l:line_nr > 12
            let l:line_nr -= 12 
        else
            let l:line_nr = 0
        endif
        let l:content = getbufline(l:buf, l:line_nr, '$')
        call writefile(l:content, g:fzf_history_dir.'/'.l:buf)
        call add(l:result_list, l:buf.':'.te#terminal#get_title(l:buf))
    endfor
    return l:result_list
endfunction

function! s:open_shell(timer)
    let l:buf = str2nr(s:buf)
    call te#terminal#open_term({'opener':str2nr(s:shell_pop_option), 'bufnr':l:buf})
    let l:buf_list = te#terminal#get_buf_list()
    for l:buf in l:buf_list
        call delete(g:fzf_history_dir.'/'.l:buf)
    endfor
endfunction

function! s:edit_file(item) abort
    if len(a:item) < 2 | return | endif
    let s:buf =  matchstr(a:item[1], '\d\+\(:\)\@=')
    let l:cmd = get({'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit',
                \ 'ctrl-t': 'tabedit'}, a:item[0], 'e')

    if l:cmd == 'e'
        let s:shell_pop_option = 0x0
    elseif l:cmd == 'vsplit'
        let s:shell_pop_option = 0x2
    elseif l:cmd == 'split'
        let s:shell_pop_option  = 0x1
    elseif l:cmd == 'tabedit'
        let s:shell_pop_option  = 0x4
    endif
    if len(s:key_text)
        for l:t in s:key_text
            call te#terminal#send_key(str2nr(s:buf), l:t."\r")
        endfor
    endif
    call timer_start(100, function('<SID>open_shell'), {'repeat': 1})
endfunction

function! te#fzf#terminal#start(text) abort
    let s:key_text = a:text
    let l:run_dict = {
                \ 'source': <SID>get_terminal_list(),
                \ 'sink*': function('<SID>edit_file'),
                \ 'options' : ' --ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : '.
                \              '-m --prompt "Term> "',
                \ 'dir': g:fzf_history_dir,
                \ 'placeholder': '{1}',
                \ }
    call fzf#run(fzf#wrap(fzf#vim#with_preview(l:run_dict)))
endfunction
