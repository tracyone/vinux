"fzf dir
"author:<tracyone tracyone@live.cn>
"

function! s:start_fzf_dir(timer) abort
    :call te#fzf#dir#start()
    :redraw!
endfunction

function! s:edit_file(item) abort
    if len(a:item) < 2 | return | endif
    let l:pos = stridx(a:item[1], ' ')
    let l:file_path = a:item[1][pos+1:-1]
    let l:cmd = get({'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit',
                \ 'ctrl-t': 'tabedit'}, a:item[0], 'e')
    if isdirectory(l:file_path)
        call te#utils#EchoWarning('Cd to '.fnamemodify(l:file_path, ":p:h"))
        :redraw!
        execute 'cd 'l:file_path
        if te#env#SupportFeature('timers')
            let l:id = timer_start(20, function('<SID>start_fzf_dir'))
        else
            let l:run_dict = {
                        \ 'source': 'ls -a -F', 
                        \ 'sink*': function('<SID>edit_file'),
                        \ 'down':'40%' ,
                        \ 'options' : ' --ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : '.
                        \              '-m --prompt "Dir> "',
                        \ }
            if te#env#IsNvim() != 0
                :call extend(l:run_dict, {'window':'call FloatingFZF()'})
            else
                :call extend(l:run_dict, g:fzf_layout)
            endif
            call fzf#run(l:run_dict)
            :redraw!
        endif
    else
        execute 'silent  '.l:cmd.' ' . l:file_path
    endif
endfunction

function! te#fzf#dir#start() abort
        let l:run_dict = {
                    \ 'source': 'ls -a -F', 
                    \ 'sink*': function('<SID>edit_file'),
                    \ 'down':'40%' ,
                    \ 'options' : ' --ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : '.
                    \              '-m --prompt "Dir> "',
                    \ }
        if te#env#IsNvim() != 0
            :call extend(l:run_dict, {'window':'call FloatingFZF()'})
        else
            :call extend(l:run_dict, g:fzf_layout)
        endif
        call fzf#run(l:run_dict)
endfunction
