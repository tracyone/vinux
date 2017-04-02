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


"echo warning messag
"a:0-->err or warn or info,default is warn
func! te#utils#EchoWarning(str,...) abort
    redraw!
    let l:level='WarningMsg'
    let l:prompt='warn'
    if a:0 == 1
        let l:prompt = a:1
        if a:1 ==? 'err'
            let l:level='ErrorMsg'
        elseif a:1 ==? 'warn'
            let l:level='WarningMsg'
        elseif a:1 ==? 'info'
            let l:level='None'
        endif
    endif
    execut 'echohl '.l:level | echo '['.l:prompt.'] '.a:str | echohl None
endfunc


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

function! te#utils#open_url() abort
    let s:url = s:Get_pattern_at_cursor('\v(https?://|ftp://|file:/{3}|www\.)(\w|[.-])+(:\d+)?(/(\w|[~@#$%^&+=/.?:-])+)?')
    if s:url ==? ''
        call te#utils#EchoWarning('It is not a URL on current cursor！')
    else
        echo 'Open URL：' . s:url
        if has('win32') || has('win64')
            call system('cmd /C start ' . s:url)
        elseif has('mac')
            call system("open '" . s:url . "'")
        else
            call system("xdg-open '" . s:url . "' &")
        endif
    endif
    unlet s:url
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
    let l:ret = te#utils#GetError(l:man_cmd.' 3 '.l:cur_word,'\cno \(manual\|entry\).*')
    "make sure index valid
    if l:ret != 0
        let l:ret = te#utils#GetError(l:man_cmd.' 2 '.l:cur_word,'\cno \(manual\|entry\).*')
        if l:ret != 0
            execute 'silent! help '.l:cur_word
        endif
    endif
endfunction

function! te#utils#coding_style_toggle() abort
    if &tabstop != 8
        set tabstop=8  
        set shiftwidth=8 
        set softtabstop=8 
        set noexpandtab
        set nosmarttab
        call te#utils#EchoWarning('change to linux kernel coding style ...')
    else
        set tabstop=4  
        set shiftwidth=4 
        set softtabstop=4 
        set expandtab
        set smarttab
        call te#utils#EchoWarning('Use space instead of tab ...')
    endif
endfunction

function! te#utils#tab_buf_switch(num) abort
    if exists('g:feat_enable_airline') && g:feat_enable_airline == 1
        if a:num == 0
            execute 'normal '."\<Plug>AirlineSelectPrevTab"
        elseif a:num == -1
            execute 'normal '."\<Plug>AirlineSelectNextTab"
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
            else
                execute 'normal '.a:num.'gt'
            endif
        elseif exists('g:buftabline_numbers') && g:buftabline_numbers == 2
            if a:num == 0
                :bprev
            elseif a:num == -1
                :bnext
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
            let l:temp=a:num
            let l:buf_index=a:num
            let l:buf_count=len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
            if l:temp > l:buf_count
                return
            endif
            while l:buf_index != 0
                while !buflisted(l:temp)
                    let l:temp += 1
                endw
                let l:buf_index -= 1
                if l:buf_index != 0
                    let l:temp += 1
                endif
            endw
            execute ':'.l:temp.'b'
        endif
    endif
endfunction

