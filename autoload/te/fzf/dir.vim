"fzf dir
"author:<tracyone tracyone@live.cn>

function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:file_path = a:item[pos+1:-1]
    if isdirectory(l:file_path)
        call te#utils#EchoWarning('Cd to '.fnamemodify(l:file_path, ":p:h"))
        :redraw!
        execute 'cd 'l:file_path
        :call fzf#run({
                    \ 'source': 'ls -a -F', 
                    \ 'sink': function('<SID>edit_file'),
                    \ 'down':'40%' ,
                    \ 'window':'call FloatingFZF()'
                    \ })
        :redraw!
    else
        execute 'silent e' l:file_path
    endif
endfunction

function! te#fzf#dir#start() abort
    call fzf#run({
                \ 'source': 'ls -a -F', 
                \ 'sink': function('<SID>edit_file'),
                \ 'down':'40%' ,
                \ 'window':'call FloatingFZF()'
                \ })
endfunction
