scriptencoding utf-8
" name :te#utils#GetError
" arg  :command,vim command(not shell command) that want to
"       test execute status
" arg   : err_str,error substring pattern that is expected
" return:return 0 if no error exist,return -1 else
function! te#utils#GetError(command,err_str) abort
    redir => l:msg
    silent! execute a:command
    redir END
    let l:rs=split(l:msg,'\r\n\|\n')
    if get(l:rs,-1,3) ==3  "no error exists
        return 0
    elseif l:rs[-1] =~# a:err_str
        return -1
    else
        return 0
    endif
endfunction


let s:global_echo_str=[]
"echo warning messag
"a:1-->err or warn or info,default is warn
"a:2-->flag of VimEnter,0 or 1
function! te#utils#EchoWarning(str,...) abort
    redraw!
    let l:level='WarningMsg'
    let l:prompt='warn'
    let l:flag=0
    if a:0 != 0
        for s:needle in a:000
            if type(s:needle) == g:t_string
                let l:prompt = s:needle
                if s:needle ==? 'err'
                    let l:level='ErrorMsg'
                elseif s:needle ==? 'warn'
                    let l:level='WarningMsg'
                elseif s:needle ==? 'info'
                    let l:level='None'
                endif
            elseif type(s:needle) == g:t_number
                let l:flag=s:needle
            endif
        endfor
    endif
    if l:flag == 0 || !has('vim_starting')
        execut 'echohl '.l:level | echom '['.l:prompt.'] '.a:str | echohl None
    else
        call add(s:global_echo_str, a:str)
    endif
endfunction

function! te#utils#echo_info_after()
    if !empty(s:global_echo_str)
        for l:needle in s:global_echo_str
            call te#utils#EchoWarning(l:needle, 'warn')
        endfor
        let s:global_echo_str=[]
    endif
endfunction
" save files in every condition
function! te#utils#SaveFiles() abort
    try 
        update
    catch /^Vim\%((\a\+)\)\=:E212/
        if exists(':SudoWrite')
            call te#utils#EchoWarning('sudo write,please input your password!')
            SudoWrite %
            return 0
        else
            :w !sudo tee %
        endif
    catch /^Vim\%((\a\+)\)\=:E32/   "no file name
        if te#env#IsGui()
            exec ':emenu File.Save'
            return 0
        endif
        let l:filename=input('NO FILE NAME!Please input the file name: ')
        if l:filename ==# ''
            call te#utils#EchoWarning('You just give a empty name!')
            return 3
        endif
        try 
            exec 'w '.l:filename
        catch /^Vim\%((\a\+)\)\=:E212/
            call te#utils#EchoWarning('sudo write,please input your password!')
            if exists(':SudoWrite')
                SudoWrite %
                return 0
            else
                :w !sudo tee %
            endif
        endtry
    endtry
endfunction

"opt_str can be vim option or variable's name(string)
"toggle list,length must 2
"eg. call te#utils#OptionToggle("background",["dark","light"]
function! te#utils#OptionToggle(opt_str,opt_list) abort
    let l:len=len(a:opt_list)
    if l:len != 2 
        call te#utils#EchoWarning('Invalid argument.','err')
        return 1
    endif
    if exists('&'.a:opt_str)
        let l:leed='&'
        let l:opt_val=eval('&'.a:opt_str)
    elseif exists(a:opt_str)
        let l:leed=''
        let l:opt_val=eval(a:opt_str)
    else
        call te#utils#EchoWarning(a:opt_str.' not found','err')
        return 2
    endif
    if l:opt_val == a:opt_list[0]
        execute 'let '.l:leed.a:opt_str.'='.'"'.a:opt_list[1].'"'
        call te#utils#EchoWarning('Change '.l:leed.a:opt_str.' from '.l:opt_val.' to '.a:opt_list[1])
    elseif l:opt_val == a:opt_list[1]
        execute 'let '.l:leed.a:opt_str.'='.'"'.a:opt_list[0].'"'
        call te#utils#EchoWarning('Change '.l:leed.a:opt_str.' from '.l:opt_val.' to '.a:opt_list[0])
    else
        execute 'let '.l:leed.a:opt_str.'='.'"'.a:opt_list[0].'"'
        call te#utils#EchoWarning('Change '.l:leed.a:opt_str.' from '.l:opt_val.' to '.a:opt_list[0])
    endif
    return 0
endfunction

function! te#utils#source_vimrc(path) abort
    let l:ft_orig=&filetype
    :call te#utils#EchoWarning('Sourcing '.a:path.' ...')
    execute ':source '.a:path
    :execute 'set ft='.l:ft_orig
    :call te#utils#EchoWarning(a:path.' has been sourced.')
endfunction


function! te#utils#goto_cur_file(option) abort
    if a:option == 1
        execute 'cd %:h'
    elseif a:option == 2
        execute 'cd '. fnamemodify(resolve(expand("%")), ':p:h')
    else
        execute 'lcd %:h'
    endif
    execute ':call te#utils#EchoWarning("cd to ".getcwd())'
endfunction

function! s:Get_pattern_at_cursor(pat) abort
    let l:col = col('.') - 1
    let l:line = getline('.')
    let l:ebeg = -1
    let l:cont = match(l:line, a:pat, 0)
    let l:elen = 0
    while (l:ebeg >= 0 || (0 <= l:cont) && (l:cont <= l:col))
        let l:contn = matchend(l:line, a:pat, l:cont)
        if (l:cont <= l:col) && (l:col < l:contn)
            let l:ebeg = match(l:line, a:pat, l:cont)
            let l:elen = l:contn - l:ebeg
            break
        else
            let l:cont = match(l:line, a:pat, l:contn)
        endif
    endwhile
    if l:ebeg >= 0
        return strpart(l:line, l:ebeg, l:elen)
    else
        return ''
    endif
endfunction

function! te#utils#open_url(url) abort
    if a:url ==# ""
        let l:url = s:Get_pattern_at_cursor('\v(https?://|ftp://|file:/{3}|www\.)(\w|[.-])+(:\d+)?(/(\w|[~@#$%^&+=/.?:-])+)?')
    else
        let l:url = a:url
    endif
    if l:url ==? ''
        call te#utils#EchoWarning('It is not a URL on current cursor！')
    else
        call te#utils#EchoWarning('Open URL：' . l:url)
        if te#env#IsWindows()
            call system('cmd /C start ' . l:url)
        elseif te#env#IsMac()
            call system("open '" . l:url . "'")
        else
            call system("xdg-open '" . l:url . "' &")
        endif
    endif
    unlet l:url
endfunction

" line number toggle
function! te#utils#nu_toggle() abort
    if &number && &relativenumber
        set nonumber norelativenumber
    elseif &number && !&relativenumber
        set relativenumber
    else
        set number
    endif
endfunction

function! te#utils#find_mannel() abort
    let l:man_cmd=':Man'
    if !exists(l:man_cmd)
        call te#utils#EchoWarning('You must install lambdalisue/vim-manpager first!')
        return -1
    endif
    let l:cur_word=expand('<cword>')
    if &ft ==# 'sh'
        let l:ret = te#utils#GetError(l:man_cmd.' '.l:cur_word,'\cno \(manual\|entry\).*')
    else
        let l:ret = te#utils#GetError(l:man_cmd.' 2 '.l:cur_word,'\cno \(manual\|entry\).*')
        if l:ret != 0
            "try in user library
            let l:ret = te#utils#GetError(l:man_cmd.' 3 '.l:cur_word,'\cno \(manual\|entry\).*')
            "try in kernel
            if l:ret != 0
                let l:ret = te#utils#GetError(l:man_cmd.' 9 '.l:cur_word,'\cno \(manual\|entry\).*')
            endif
        endif
    endif
    "open help in vim
    if l:ret != 0
        execute 'silent! help '.l:cur_word
    endif
endfunction

function! s:get_listed_buf_order_num() abort
    let l:i=1
	if te#env#SupportAsync()
		let l:ret = getbufinfo({'buflisted':1})
        for l:buf in l:ret
            if l:buf.name !=# expand('%:p')
                let l:i=l:i+1
            else
                break
            endif
        endfor
	else
		let l:ret = filter(range(1, bufnr('$')), 'buflisted(v:val)')
        for l:buf in l:ret
            if bufname(l:buf) !=# expand('%:p')
                let l:i=l:i+1
            else
                break
            endif
        endfor
	endif
    return l:i
endfunction

let s:lastopen_tab=1
let s:lastopen_buf=1
augroup Tabpage
    autocmd!
    autocmd TabLeave * let s:lastopen_tab=tabpagenr()
    autocmd BufLeave * let s:lastopen_buf=s:get_listed_buf_order_num()
augroup end

"Return the total number of listed buffers
function! te#utils#has_listed_buffer() abort
    if te#env#SupportAsync()
        let l:ret = len(getbufinfo({'buflisted':1}))
    else
        let l:ret = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    endif
    return l:ret
endfunction

"Detect whether current buffer is listed or not
function! te#utils#is_listed_buffer()
    return buflisted(bufnr('%'))
endfunction

" quit current split windows
function! te#utils#quit_win(all)
    if a:all == 1
        if (confirm("Quit Vim Vim Vim Vim Vim ?", "&Yes\n&No", 2)==1)
            :qa
        endif
        return
    endif
    "multiple tab
    if tabpagenr('$') != 1
        :quit
    else
        " 0 or 1 listed buffer
        let l:no_of_listed_buffer=te#utils#has_listed_buffer()
        if l:no_of_listed_buffer <= 1 && winnr('$') <= 1
            if !te#utils#is_listed_buffer() && l:no_of_listed_buffer == 1
                :bdelete
            else
                if (confirm("Quit Vim Vim Vim Vim Vim ?", "&Yes\n&No", 2)==1)
                    :quit
                endif
            endif
        else
            if !te#utils#is_listed_buffer() || winnr('$') <= 1
                :bdelete
            else 
                :quit
            endif
        endif
    endif
endfunction

"0:previous tab or buffer
"-1:next tab or buffer
"-2:lastopen tab or buffer
"1~9:tab 1~9 or buffer 1~9
function! te#utils#tab_buf_switch(num) abort
    if a:num == 0 || a:num == -1
        if te#utils#has_listed_buffer() <= 1
            return
        endif
    endif
    if get(g:, 'feat_enable_airline') == 1
        if a:num == 0
            execute 'normal '."\<Plug>AirlineSelectPrevTab"
        elseif a:num == -1
            execute 'normal '."\<Plug>AirlineSelectNextTab"
        elseif a:num == -2
            if exists( '*tabpagenr' ) && tabpagenr('$') != 1
                execute 'normal '."\<Plug>AirlineSelectTab".s:lastopen_tab
            else
                execute 'normal '."\<Plug>AirlineSelectTab".s:lastopen_buf
            endif
        else
            if tabpagenr('$') != 1 && a:num > tabpagenr('$')
                return
            endif
            execute 'normal '."\<Plug>AirlineSelectTab".a:num
        endif
    else
        if exists( '*tabpagenr' ) && tabpagenr('$') != 1
            " Tab support && tabs open
            if a:num == 0
                :tabprev
            elseif a:num == -1
                :tabnext
            elseif a:num == -2
                execute 'normal '.s:lastopen_tab.'gt'
            else
                execute 'normal '.a:num.'gt'
            endif
        elseif exists('g:buftabline_numbers') && g:buftabline_numbers == 2
            if a:num == 0
                :bprev
            elseif a:num == -1
                :bnext
            elseif a:num == -2
                execute 'normal '."\<Plug>BufTabLine.Go(".s:lastopen_buf.')'
            else
                execute 'normal '."\<Plug>BufTabLine.Go(".a:num.')'
            endif
        else
            if a:num == 0
                :bprev
                return
            elseif a:num == -1
                :bnext
                return
            endif
        endif
    endif
endfunction

function! te#utils#focus_coding() abort
    if &laststatus != 0
        if te#env#IsTmux()
            call system('tmux set -g status off')
        endif
        set laststatus=0
        set showtabline=0
        set nonu
        set nornu
        set signcolumn=no
        let g:buftabline_show=0
    else
        if te#env#IsTmux()
            call system('tmux set -g status on')
        endif
        set laststatus=2
        set showtabline=1
        set nu
        set rnu
        set signcolumn=yes
        let g:buftabline_show=1
    endif
endfunction

function! te#utils#check_health() abort
    tabnew
    nnoremap <buffer> q :call te#utils#quit_win(0)<cr>
    setlocal wrap
    setlocal filetype=health
    setlocal conceallevel=2 concealcursor=nc
    setlocal keywordprg=:help iskeyword=@,48-57,_,192-255,-,#
    let l:output=[]
    call add(l:output, 'Vim health info')
    call add(l:output, '============================================')
    let l:i=2
    call add(l:output, printf("%s:\t",'Vim version'))
    let l:temp=te#feat#get_vim_version()
    let l:output[l:i].=l:temp[0].' '.l:temp[1]
    let l:output[l:i].=" OS: "
    if te#env#IsMac()
        let l:output[l:i].='MacOS'
    elseif te#env#IsUnix()
        let l:output[l:i].='Unix'
    elseif te#env#IsWin32()
        let l:output[l:i].='Windows x86'
    elseif te#env#IsWin64()
        let l:output[l:i].='Windows x86_64'
    endif

    call add(l:output, '')
    let l:i=l:i + 1

    call add(l:output, printf("%26s:\t", "vim >= 7.3.1058"))
    let l:i=l:i + 1
    if te#env#check_requirement()
        let l:output[l:i].='Yes'
    else
        let l:output[l:i].='[No]'
    endif
    call add(l:output, printf("%26s", "--------------------------------------------"))
    let l:i=l:i + 1


    for needle in ['termguicolors', 'lua', 'perl', 'ruby', 'tcl', 
                \ 'timers', 'python', 'python3', 'cscope', 
                \'multi_byte', 'signs', 'clipboard', 'clientserver']
        call add(l:output, printf("%26s:\t", ''.needle.''.' support'))
        let l:i=l:i + 1
        if te#env#SupportFeature(needle)
            let l:output[l:i].='Yes'
        else
            let l:output[l:i].='[No]'
        endif
        call add(l:output, printf("%26s", "--------------------------------------------"))
        let l:i=l:i + 1
    endfor

    call add(l:output, printf("%26s:\t",'terminal support'))
    let l:i=l:i + 1
    if te#env#SupportTerminal()
        let l:output[l:i].='Yes'
    else
        let l:output[l:i].='[No]'
    endif
    call add(l:output, printf("%26s", "--------------------------------------------"))
    let l:i=l:i + 1

    call add(l:output, printf("%26s:\t",'job support'))
    let l:i=l:i + 1
    if te#env#SupportAsync()
        let l:output[l:i].='Yes'
    else
        let l:output[l:i].='[No]'
    endif
    call add(l:output, printf("%26s", "--------------------------------------------"))
    let l:i=l:i + 1


    call add(l:output, printf("%26s:\t",'ycm support'))
    let l:i=l:i + 1
    if te#env#SupportYcm()
        let l:output[l:i].='Yes'
    else
        let l:output[l:i].='[No]'
    endif
    call add(l:output, printf("%26s", "--------------------------------------------"))
    let l:i=l:i + 1

    for needle in ['cscope', 'ctags', 'ag', 'rg', 'git', 
                \ 'clang', 'curl', 'bear', 'pbcopy', 'xsel', 'xclip', 'nvr']
        call add(l:output, printf("%26s:\t", ''.needle.''.' exist'))
        let l:i=l:i + 1
        if te#env#Executable(needle)
            let l:output[l:i].='Yes'
        else
            let l:output[l:i].='[No]'
        endif
        call add(l:output, printf("%26s", "--------------------------------------------"))
        let l:i=l:i + 1
    endfor

    call append('$', l:output)
    setlocal nomodified
    setlocal nomodifiable
    setlocal bufhidden=delete
    highlight health ctermbg=red guibg=red
    call matchadd("health", ".*No.*")
    :f [Health]
endfunction

"te#utils#run_command (command [, callback] [,arglist] [, flag)
function! te#utils#run_command(command,...) abort
    if a:command =~# '^\s*$'
        let l:command = input("Run command:",'','customlist,te#bashcomplete#cmd_complete')
    else
        let l:command=a:command
    endif
    call te#utils#EchoWarning(l:command)
    if exists(':NeomakeSh')
        if a:0 == 0
            call neomakemp#run_command(l:command)
        elseif a:0 == 1
            call neomakemp#run_command(l:command, a:1)
        elseif a:0 == 2
            call neomakemp#run_command(l:command, a:1, a:2)
        elseif a:0 == 3
            call neomakemp#run_command(l:command, a:1, a:2, a:3)
        else
            call te#utils#EchoWarning('Wrong argument', 'err')
        endif
    elseif te#env#IsTmux()
        call te#tmux#run_command(l:command, 0x0c)
    else
        let l:job_info={}
        let l:job_info.callback=''
        let l:job_info.args=[]
        let l:job_info.flag=0
        for s:needle in a:000
            if type(s:needle) == g:t_func
                let l:job_info.callback=s:needle
            elseif type(s:needle) == g:t_list
                let l:job_info.args=s:needle
            elseif type(s:needle) == g:t_number
                let l:job_info.flag=s:needle
            else
                call te#utils#EchoWarning('Wrong argument', 'err')
                return 0
            endif 
            unlet s:needle
        endfor
        exec '!'.l:command
        try
            call call(l:job_info.callback, l:job_info.args)
        catch /^Vim\%((\a\+)\)\=:E117/
        endtry
    endif
endfunction

function! te#utils#get_plugin_name(A,L,P) abort
    let l:temp=a:A.a:L.a:P
    let l:result=l:temp 
    let l:result=''
    if te#env#IsWindows()
        let l:dir = te#compatiable#systemlist('dir /b /d')
    else
        let l:dir = te#compatiable#systemlist('find * -maxdepth 0 -type d')
    endif
    for l:str in l:dir
        let l:result.=l:str.nr2char(10)
    endfor
    return l:result
endfunction

function! te#utils#cd_to_plugin(path)
    execute 'cd '.a:path
    let l:plugin_name = input('Please input the direcory name: ','','custom,te#utils#get_plugin_name')
    if !isdirectory(l:plugin_name)
        call te#utils#EchoWarning(l:plugin_name.' not found','err')
        cd -
        return
    endif
    execute 'cd '.l:plugin_name 
    call te#utils#EchoWarning('cd to '.l:plugin_name)
endfunction
