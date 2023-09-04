"Clap feature for vinux
"author:<tracyone tracyone@live.cn>

let s:text = []
let s:enable_flag= 0

function! s:edit_file(item)
    let l:str = a:item
    if s:enable_flag == 1
        let l:enable='Enable'
    else
        let l:enable='Disable'
    endif
    call te#feat#feature_enable(s:enable_flag, l:str)
endfunction

function! te#clap#feat#start(en) abort
    let s:text = []
    for l:key in keys(te#feat#get_feature_dict())
        call add(s:text, l:key)
    endfor
    call add(s:text, 'all')
    let s:enable_flag=a:en
    if a:en == 1
        let l:id = 'feat_en'
    else
        let l:id = 'feat_dis'
    endif
    let l:run_dict = {
                    \ 'source': s:text, 
                    \ 'sink': function('<SID>edit_file'),
                    \ 'id': l:id,
                    \ }
    if !exists('g:clap')
        call clap#init#()
    endif
    call clap#run(l:run_dict)
endfunction
