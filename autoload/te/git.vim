" Get git repo local branch name
" return a string which is the name of local branch name
" return a space if no local branch found
function! te#git#get_cur_br_name() abort
    let l:br=te#compatiable#systemlist('git branch')
    for l:needle in l:br
        let l:needle=matchstr(needle, '^\*\s\+\zs.*\ze')
        if l:needle !=# ''
            return l:needle
        endif
    endfor
    return ''
endfunction

function! te#git#get_status() abort
    let l:result={}
    let l:result.staged=''
    let l:result.modify=''
    let l:result.untracked=''
    let l:st=te#compatiable#systemlist('git status -s')
    for l:i in l:st
        if matchstr(l:i, '^M') !=# ''
            let l:result.staged='S'
        endif
        if matchstr(l:i, '^[M ]M') !=# ''
            let l:result.modify='M'
        endif
        if matchstr(l:i, '^??') !=# ''
            let l:result.untracked='?'
        endif
    endfor
    let l:temp=l:result.untracked.l:result.modify.l:result.staged
    if !empty(l:temp)
        let l:temp=" ".l:result.untracked.l:result.modify.l:result.staged
    endif
    return l:temp
endfunction

function! s:get_remote_name() abort
    let l:remote_name=te#compatiable#systemlist('git remote')
    if v:shell_error || len(l:remote_name) == 0
        call te#utils#EchoWarning('Git remote name failed!')
        return 1
    endif
    return l:remote_name[0]
endfunction

function! te#git#get_remote_name(A, L, P) abort
    let l:remote_name=te#compatiable#systemlist('git remote')
    if v:shell_error || len(l:remote_name) == 0
        call te#utils#EchoWarning('Git remote name failed!')
        return ''
    endif
    let l:result=''
    for l:str in l:remote_name
        let l:result.=l:str
    endfor
    return l:result
endfunction

"git push operation.
"support complete remote branch name
"auto gain remote name
"auto gain local branch name
"arg:push_type is detemine weather push to gerrit or normal git server
"set to "head" to push to normal git server
"set to "for" to push to gerrit server
function! te#git#GitPush(push_type) abort
    if a:push_type !~# "\\vheads|for"
        :call te#utils#EchoWarning('Error argument','err')
        return 1
    endif
    let l:remote_name=s:get_remote_name()
    if type(l:remote_name) != g:t_string
        return 2
    endif
    let l:branch_name = input('Please input the branch name(master): ','master','custom,te#git#GetRemoteBr')
    let l:cur_br_name=te#git#get_cur_br_name()
    if a:push_type ==# 'for'
        let l:cur_br_name = input('Which commit do you to push(HEAD):','HEAD','custom,te#git#get_latest_sevral_commit')
        if l:cur_br_name !=# 'HEAD'
            let l:cur_br_name = matchstr(l:cur_br_name,'^\w\+\ze\s') 
        endif
    endif
    if type(l:cur_br_name) != g:t_string
        :call te#utils#EchoWarning('Get current branch name failed','err')
        return 3
    endif
    call te#utils#run_command('git push '.l:remote_name.' '.l:cur_br_name.':refs/'.a:push_type.'/'.l:branch_name)
    return 0
endfunction

" a complet function that is needed by input function
" get all the remote branch name into a string seperate by CR
function! te#git#GetRemoteBr(A,L,P) abort
    let l:all_remote_name=te#compatiable#systemlist('git branch -r')
    if empty(l:all_remote_name) == 1
        call te#utils#EchoWarning('No remote name found!')
        return 1
    endif
    let l:result=''
    for l:str in l:all_remote_name
        let l:result.=substitute(l:str,'.*/','','').nr2char(10)
    endfor
    return l:result
endfunction

function! te#git#get_latest_sevral_commit(A, L, P) abort
    let l:temp=a:A.a:L.a:P
    let g:log=te#compatiable#systemlist('git log --abbrev-commit -6 --pretty=oneline')
    if empty(g:log) == 1
        call te#utils#EchoWarning('git log failed')
        return 1
    endif
    " avoid warning..
    let l:result=l:temp 
    let l:result=''
    for l:str in g:log
        let l:result.=l:str."\n"
    endfor
    return l:result
endfunction

function! te#git#git_rebase() abort
    let l:remote_name=s:get_remote_name()
    if type(l:remote_name) != g:t_string
        return 2
    endif
    let l:branch_name = input('Please input the branch name: ','','custom,te#git#GetRemoteBr')
    call te#utils#run_command('git rebase '.l:remote_name.'/'.l:branch_name)
endfunction

function! te#git#git_merge() abort
    let l:remote_name=input('Which remote do you want to merge: ','origin','custom,te#git#get_remote_name')
    if type(l:remote_name) != g:t_string
        return 2
    endif
    let l:branch_name = input('which branch do you want to merge: ','master','custom,te#git#GetRemoteBr')
    call te#utils#run_command('git fetch --all && git rebase '.l:remote_name.'/'.l:branch_name)
endfunction

"archive my vim config using git archive.
function! te#git#archive_my_vim_cfg(git_dir, out_name) abort
    let l:cur_dir=getcwd()
    execute 'cd '.a:git_dir
    if !isdirectory('.git')
        call te#utils#EchoWarning('Not a git repo!', 'err')
        return
    endif
    if a:out_name ==# ''
        let l:out_name=fnamemodify(getcwd(), ':t').'.zip'
    else
        let l:out_name=a:out_name.'.zip'
    endif
    call te#utils#run_command('git archive --format=zip HEAD -o '.l:cur_dir.'/'.l:out_name)
    call te#utils#EchoWarning('Creating '.l:cur_dir.'/'.l:out_name.' ...')
endfunction

function! te#git#show_log(dir) abort
    execute 'cd '.a:dir
    if te#env#IsTmux() && te#env#Executable('tig') 
        call te#tmux#run_command('tig', 0x4)
        cd -
        return 0
    elseif exists(':Gitv')
        :Gitv
        cd -
        return 0
    elseif exists(':Gina')
        :tabnew
        :Gina log --max-count=300
        cd -
        return 0
    elseif te#env#SupportTerminal()
        :tabnew
        if te#env#IsNvim()
            :terminal tig
        else
            hi Terminal ctermbg=black ctermfg=white guibg=black guifg=white
            :terminal ++curwin ++close tig
        endif
        cd -
        return 0
    endif

    cd -
    call te#utils#EchoWarning('Oooo somthing is wrong with your vim!', 'err')
    return 1
endfunction

function! te#git#git_browse()
    let l:remote_name=s:get_remote_name()
    if type(l:remote_name) != g:t_string
        return
    endif
    let l:remote_url=te#compatiable#systemlist('git remote get-url '.l:remote_name)
    if matchstr(l:remote_url[0], '\v(https?://|ftp://|file:/{3}|www\.)(\w|[.-])+(:\d+)?(/(\w|[~@#$%^&+=/.?:-])+)?') !=# ''
        call te#utils#open_url(l:remote_url[0])
        return
    else
        let l:wrong_url = matchstr(l:remote_url[0], 'git@\zs.*\ze:.*')
        if l:wrong_url !=# '' 
            let l:wrong_url_reset = matchstr(l:remote_url[0], ':\zs.*\ze$')
            if l:wrong_url_reset !=# ""
                call te#utils#open_url("https://".l:wrong_url.'/'.l:wrong_url_reset)
                return
            endif
        endif
        let l:wrong_url = matchstr(l:remote_url[0], '\v(git://|ssh://)\zs.*\ze.*')
        if l:wrong_url !=# ''
            call te#utils#open_url("https://".l:wrong_url)
            return
        endif
        call te#utils#EchoWarning('Can not recognize url:', l:remote_url[0])
    endif
endfunction
