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
        call writefile(l:content, g:clap_cache_directory.'/'.l:buf)
        call add(l:result_list, l:buf.':'.te#terminal#get_title(l:buf))
    endfor
    return l:result_list
endfunction

function! s:open_shell(timer)
    let l:buf = str2nr(s:buf)
    call te#terminal#open_term({'opener':str2nr(s:shell_pop_option), 'bufnr':l:buf})
    let l:buf_list = te#terminal#get_buf_list()
    for l:buf in l:buf_list
        call delete(g:clap_cache_directory.'/'.l:buf)
    endfor
endfunction

function! s:sink_func(item) abort
    if has_key(g:clap, 'open_action')
        call <SID>edit_file(a:item, g:clap.open_action)
    else
        call <SID>edit_file(a:item, 'e')
    endif
endfunction

function! s:edit_file(item, cmd) abort
    let s:buf =  a:item
    if a:cmd == 'e'
        let s:shell_pop_option = 0x0
    elseif a:cmd == 'vsplit'
        let s:shell_pop_option = 0x2
    elseif a:cmd == 'split'
        let s:shell_pop_option  = 0x1
    elseif a:cmd == 'tab split'
        let s:shell_pop_option  = 0x4
    endif
    if len(s:key_text)
        for l:t in s:key_text
            call te#terminal#send_key(str2nr(s:buf), l:t."\r")
        endfor
    endif
    call timer_start(100, function('<SID>open_shell'), {'repeat': 1})
endfunction

function! s:on_move() abort
  let curline = g:clap.display.getcurline()
  let l:buf = str2nr(matchstr(curline, '\S'))
  let lines = readfile(g:clap_cache_directory.'/'.l:buf)
  call g:clap.preview.show(lines)
endfunction

function! te#clap#terminal#start(text) abort
    let s:key_text = a:text
    let l:run_dict = {
                \ 'source': <SID>get_terminal_list(),
                \ 'sink': function('<SID>sink_func'),
                \ 'on_move_async': function('<SID>on_move'),
                \ 'support_open_action': v:true,
                \ 'id': 'terminal',
                \ }
    
    let l:run_dict.action = {
                \ 'OpenInSplitWin': { -> clap#selection#try_open('ctrl-x') },
                \ 'OpenInNew&Tab': { -> clap#selection#try_open('ctrl-t') },
                \ 'Open&Vertically': { -> clap#selection#try_open('ctrl-v') },
                \ }

    if !exists('g:clap')
        call clap#init#()
    endif
    call clap#run(l:run_dict)
endfunction
