function! s:HowToRunGit(command) abort
    call te#utils#EchoWarning(a:command)
    if exists(':AsyncRun')
        exec ':AsyncRun '.a:command
    elseif exists(':NeomakeSh')
        call neomakemp#run_command(a:command, 1)
    else
        exec '!'.a:command
    endif
endfunction

" Get git repo local branch name
" return a string which is the name of local branch name
" return a space if no local branch found
function! te#git#GitBranchName() abort
    if exists('*fugitive#head')
        return fugitive#head()
    endif
    if exists('*gita#statusline#format')
        return gita#statusline#format('%lb')
    endif
endfunction

function! s:get_remote_name()
    let l:remote_name=split(system('git remote'),'\n')
    if v:shell_error || len(l:remote_name) == 0
        call te#utils#EchoWarning('git remote failed')
        return 1
    endif
    return l:remote_name[0]
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
    if type(l:remote_name) != v:t_string
        return 2
    endif
    let l:branch_name = input('Please input the branch name: ','','custom,te#git#GetRemoteBr')
    call s:HowToRunGit('git push '.l:remote_name.' '.te#git#GitBranchName().':refs/'.a:push_type.'/'.l:branch_name)
    return 0
endfunction

" a complet function that is needed by input function
" get all the remote branch name into a string seperate by CR
function! te#git#GetRemoteBr(A,L,P) abort
    let l:temp=a:A.a:L.a:P
    let l:all_remote_name=systemlist('git branch -r')
    if empty(l:all_remote_name) == 1
        call te#utils#EchoWarning('No remote name found!')
        return 1
    endif
    " avoid warning..
    let l:result=l:temp 
    let l:result=''
    for l:str in l:all_remote_name
        let l:result.=substitute(l:str,'.*/','','')."\n"
    endfor
    return l:result
endfunction

function! te#git#git_rebase() abort
    let l:remote_name=s:get_remote_name()
    if type(l:remote_name) != v:t_string
        return 2
    endif
    let l:branch_name = input('Please input the branch name: ','','custom,te#git#GetRemoteBr')
    call s:HowToRunGit('git rebase '.l:remote_name.'/'.l:branch_name)
endfunction

function! te#git#git_merge() abort
    let l:remote_name=s:get_remote_name()
    if type(l:remote_name) != v:t_string
        return 2
    endif
    let l:branch_name = input('which branch do you want to merge: ','','custom,te#git#GetRemoteBr')
    call s:HowToRunGit('git fetch --all && git rebase '.l:remote_name.'/'.l:branch_name)
endfunction

