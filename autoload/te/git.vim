function! s:HowToRunGit()
    if exists(":AsyncRun")
        let l:cmdline=":AsyncRun git "
    elseif exists(":Git")
        let l:cmdline=":Git "
    else
        let l:cmdline="!git "
    endif
    return l:cmdline
endfunction

" Get git repo local branch name
" return a string which is the name of local branch name
" return a space if no local branch found
function! te#git#GitBranchName()
    if exists("*fugitive#head")
        return fugitive#head()
    else
        let l:br_name=system("git branch")[:-2]
        if v:shell_error
            return " "
        endif
        return substitute(l:br_name,"^\*\\s","","") 
    endif
endfunction

"git push operation.
"support complete remote branch name
"auto gain remote name
"auto gain local branch name
"arg:push_type is detemine weather push to gerrit or normal git server
"set to "head" to push to normal git server
"set to "for" to push to gerrit server
function! te#git#GitPush(push_type)
    if a:push_type !~ "\\vheads|for"
        :call te#utils#EchoWarning("Error argument")
        return 1
    endif
    let l:remote_name=system('git remote')[:-2]." "
    if v:shell_error || l:remote_name == " "
        call te#utils#EchoWarning("git remote failed")
        return 2
    endif
    let l:branch_name = input("Please input the branch name: ","","custom,te#git#GetRemoteBr")
    call te#utils#EchoWarning(s:HowToRunGit()."push ".l:remote_name.te#git#GitBranchName().":refs/".a:push_type."/".l:branch_name)
    :exec s:HowToRunGit()."push ".l:remote_name.te#git#GitBranchName().":refs/".a:push_type."/".l:branch_name
    return 0
endfunction

" a complet function that is needed by input function
" get all the remote branch name into a string seperate by CR
function! te#git#GetRemoteBr(A,L,P)
    let l:all_remote_name=systemlist("git branch -r")
    if empty(l:all_remote_name) == 1
        call te#utils#EchoWarning("No remote name found!")
        return 1
    endif
    let l:result=""
    for l:str in l:all_remote_name
        let l:result.=substitute(l:str,".*/","","")."\n"
    endfor
    return l:result
endfunction

