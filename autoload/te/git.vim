" Get git repo local branch name
" return a string which is the name of local branch name
" return a space if no local branch found
function! te#git#get_cur_br_name() abort
    let l:br=te#compatiable#systemlist('git branch')
    if type(l:br) == g:t_number
        return ''
    endif
    if type(l:br) == g:t_number
        call te#utils#EchoWarning("Get current branch name fail!",'err')
        return ''
    endif
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
    if type(l:st) == g:t_number
        return ''
    endif
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
        let l:temp=' '.l:result.untracked.l:result.modify.l:result.staged
    endif
    return l:temp
endfunction

function! s:get_remote_name() abort
    let l:remote_name=te#compatiable#systemlist('git remote')
    if type(l:remote_name) == g:t_number
        return ''
    endif
    if v:shell_error || type(l:remote_name) == g:t_number
        call te#utils#EchoWarning('Git remote name failed!')
        return 1
    endif
    return l:remote_name[0]
endfunction

function! te#git#get_remote_name(A, L, P) abort
    let l:remote_name=te#compatiable#systemlist('git remote')
    if type(l:remote_name) == g:t_number
        return ''
    endif
    if v:shell_error || len(l:remote_name) == 0
        call te#utils#EchoWarning('Git remote name failed!')
        return ''
    endif
    let l:result=''
    for l:str in l:remote_name
        let l:result.=l:str..nr2char(10)
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
    if type(l:all_remote_name) == g:t_number
        return ''
    endif
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
    if type(g:log) == g:t_number
        return ''
    endif
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
    if te#env#SupportTerminal()
        :tabnew
        if te#env#IsNvim() != 0
            :terminal tig
        else
            hi Terminal ctermbg=black ctermfg=white guibg=black guifg=white
            :terminal ++curwin ++close tig
        endif
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
    endif

    cd -
    call te#utils#EchoWarning('Oooo somthing is wrong with your vim!', 'err')
    return 1
endfunction

function! te#git#get_url() abort
    let l:remote_name=s:get_remote_name()
    if type(l:remote_name) != g:t_string
        return ""
    endif
    let l:remote_url=te#compatiable#systemlist('git remote get-url '.l:remote_name)
    if type(l:remote_url) == g:t_number
        return ''
    endif
    if matchstr(l:remote_url[0], '\v(https?://|ftp://|file:/{3}|www\.)(\w|[.-])+(:\d+)?(/(\w|[~@#$%^&+=/.?:-])+)?') !=# ''
        return substitute(l:remote_url[0],'\.git$','','')
    else
        let l:wrong_url = matchstr(l:remote_url[0], 'git@\zs.*\ze:.*')
        if l:wrong_url !=# '' 
            let l:wrong_url_reset = matchstr(l:remote_url[0], ':\zs.*\ze$')
            if l:wrong_url_reset !=# ''
                return substitute('https://'.l:wrong_url.'/'.l:wrong_url_reset,'\.git$','','')
            endif
        endif
        let l:wrong_url = matchstr(l:remote_url[0], '\v(git://|ssh://)\zs.*\ze.*')
        if l:wrong_url !=# ''
            return substitute('https://'.l:wrong_url,'\.git$','','')
        endif
    endif
    call te#utils#EchoWarning('Can not recognize url', l:remote_url[0])
    return ""
endfunction

function! te#git#is_git_repo() abort
    silent! call te#compatiable#systemlist('git rev-parse --is-inside-work-tree')
    return v:shell_error
endfunction

"action:
"0x1:open url using default browser
"0x2:visual mode
function! te#git#browse_file(action) abort
    if te#git#is_git_repo() != 0
        call te#utils#goto_cur_file(2)
    endif
    let l:git_url = te#git#get_url()
    let l:branch_name=te#git#get_cur_br_name()
    if matchstr(l:branch_name,'HEAD detached at') !=# ''
        let l:temp=te#compatiable#systemlist("git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/".s:get_remote_name()."/@@'")
        if type(l:temp) == g:t_number
            let l:branch_name="master"
        else
            let l:branch_name=l:temp[0]
        endif
    endif
    let l:relative_dir = te#compatiable#systemlist('git rev-parse --show-toplevel')
    if type(l:relative_dir) == g:t_number
        call te#utils#EchoWarning("Get git root dir fail!")
        return
    endif
    let l:relative_dir[0] = substitute(expand('%:p'),l:relative_dir[0],'','')
    if l:git_url !=# '' && type(l:branch_name) == g:t_string
        if and(a:action,0x2) == 0x2
            let l:line='#L'.line("'<").'-L'.line("'>")
        else
            let l:line='#L'.line(".")
        endif
        let l:final_url = l:git_url.'/blob/'.l:branch_name.l:relative_dir[0].l:line
        if and(a:action,0x1) == 1
            call te#utils#open_url(l:final_url)
        else
            let @+=l:final_url
            call te#utils#EchoWarning('Copy url '.l:final_url.' to system clipboard successfully')
        endif
    endif
endfunction

function! te#git#git_browse() abort
    let l:git_url = te#git#get_url()
    if l:git_url !=# ''
        call te#utils#open_url(l:git_url)
    endif
endfunction
