"fzf feature for vinux
"author:<tracyone tracyone@live.cn>

let s:text = []
let s:enable_flag= 0

function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:str = a:item[pos+1:-1]
    call te#feat#feature_enable(s:enable_flag, l:str)
endfunction

function! te#fzf#feat#start(en) abort
    let s:text = []
    for l:key in keys(te#feat#get_feature_dict())
        call add(s:text, l:key)
    endfor
    call add(s:text, 'all')
    let s:enable_flag=a:en
    let l:run_dict = {
                    \ 'source': s:text, 
                    \ 'sink': function('<SID>edit_file'),
                    \ 'options' : '-m --prompt "Feat> "',
                    \ }
     call fzf#run(fzf#wrap(l:run_dict))
endfunction
