"ctrlp git
"author:tracyone@live.cn

function! s:git_show_diff(mode, commid_id) abort
    if get(g:,'feat_enable_git') == 1 && g:git_plugin_name.cur_val ==# 'vim-fugitive'
        if a:mode ==# 't'
            execute 'Gtabedit '.a:commid_id
        elseif a:mode ==# 'h'
            execute 'Gpedit '.a:commid_id
        elseif a:mode ==# 'v'
            execute 'Gvsplit '.a:commid_id
        else
            execute 'Gsplit '.a:commid_id
        endif
    else
        if te#env#IsTmux()
            if te#env#Executable('tig')
                call te#tmux#run_command('tig show '.a:commid_id, 0x1)
            else
                call te#tmux#run_command('git show '.a:commid_id, 0x1)
            endif
        elseif te#env#SupportTerminal()
            if te#env#IsNvim()
                let l:termina='terminal'
            else
                hi Terminal ctermbg=black ctermfg=white guibg=black guifg=white
                let l:termina='terminal ++close'
            endif
            if te#env#Executable('tig')
                execute l:termina.' tig show '.a:commid_id
            else
                execute l:termina.' git show '.a:commid_id
            endif
        endif
    endif
endfunction

call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#git#init()',
      \ 'accept': 'te#ctrlp#git#accept',
      \ 'lname': 'git',
      \ 'sname': 'git',
      \ 'type': 'line',
      \ 'sort': 0,
      \ 'specinput': 0,
      \ })

let s:text = []
function! te#ctrlp#git#init() abort
  return s:text
endfunction

"press ctrl-v will not exit ctrlp
function! te#ctrlp#git#accept(mode, str) abort
    call ctrlp#exit()
    if s:git_command == 1 
        call te#utils#run_command('git checkout '.a:str)
    elseif s:git_command == 2
        call s:git_show_diff(a:mode, matchstr(a:str, '^*\s\zs\w\+\ze\s.*'))
    elseif s:git_command == 3
        call te#utils#run_command('git checkout '.matchstr(a:str, '^*\s\zs\w\+\ze\s.*'))
    elseif s:git_command == 4
        call te#utils#run_command('git checkout '.matchstr(a:str, '\/\zs.*\ze'))
    endif
endfunction


let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! te#ctrlp#git#id() abort
  return s:id
endfunction

"arg:
"1:branch
"2:log
"3:log checkout
"4:remote branch
function! te#ctrlp#git#start(arg) abort
    let s:git_command=a:arg
    if a:arg == 1
        let s:text = te#compatiable#systemlist("git for-each-ref --format='%(refname:short)' refs/heads/")
    elseif a:arg == 2 ||  a:arg == 3
        let s:text = te#compatiable#systemlist("git log --encoding=UTF-8 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) 
                    \ %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative")
    elseif a:arg == 4 
        let s:text = te#compatiable#systemlist("git for-each-ref --format='%(refname:short)' refs/remotes/")
    endif
    call ctrlp#init(te#ctrlp#git#id()) 
endfunction
