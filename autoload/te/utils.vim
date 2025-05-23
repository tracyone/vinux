scriptencoding utf-8

let s:ctx = {}

function! ConfirmResult(id, result) abort
    if te#env#IsNvim() != 0
        call nvim_win_close(0, v:true)
    endif
    if has_key(s:ctx, a:id)
        let l:confirm_obj = s:ctx[a:id]
        if type(l:confirm_obj.callback) == g:t_list
            if type(l:confirm_obj.callback[a:result - 1]) == g:t_string
                execute l:confirm_obj.callback[a:result - 1]
            elseif type(l:confirm_obj.callback[a:result - 1]) == g:t_dict
                let l:act_func = l:confirm_obj.callback[a:result -1 ]
                call call(l:act_func.func, l:act_func.arg)
            endif
        elseif type(l:confirm_obj.callback) == g:t_func
            call call(l:confirm_obj.callback, [a:result])
        elseif type(l:confirm_obj.callback) == g:t_dict
            let l:act_func = l:confirm_obj.callback
            call add(l:act_func.arg, a:result)
            call call(l:act_func.func, l:act_func.arg)
        endif
        call remove(s:ctx, a:id)
    else
        call te#utils#EchoWarning(a:id.' object not found')
    endif
    return l:confirm_obj.menu_list[a:result - 1]
endfunction

function! te#utils#confirm_filter(id, key) abort
    if has_key(s:ctx, a:id)
        let l:confirm_obj = s:ctx[a:id]
        let l:index = 1
        for l:needle in l:confirm_obj.menu_list
            if string(a:key) =~? '[jk]'
                continue
            endif
            if string(a:key) ==? string(l:needle[0])
                call popup_close(a:id, l:index)
                return 1
            endif
            let l:index += 1
        endfor
        return popup_filter_menu(a:id, a:key)
    else
        call te#utils#EchoWarning(a:id.' object not found')
    endif
    return 0
endfunction

function! NvimConfirmResult()
    let l:win_id = win_getid()
    call ConfirmResult(l:win_id, line('.'))
endfunction

function! te#utils#confirm(str, menu_list, action) abort
    let l:confirm_obj = {}
    let l:block_vim = 1
    if type(a:action) == g:t_list || type(a:action) == g:t_func
                \ || type(a:action) == g:t_dict
        let l:confirm_obj.callback = a:action
        let l:block_vim = 0
    else
        let l:confirm_obj.callback = ''
    endif

    let l:confirm_obj.menu_list = a:menu_list
    let l:confirm_obj.prompt_str = " ".a:str

    if te#env#IsNvim() >= 0.5 && l:block_vim  == 0
        let l:bufnr = nvim_create_buf(v:false, v:false)
        call nvim_buf_set_keymap(l:bufnr, 'n', '<CR>', ':call NvimConfirmResult()<cr>', {'silent':v:true })
        call nvim_buf_set_keymap(l:bufnr, 'n', '<C-c>', ':call nvim_win_close(0, v:true)<cr>', {'silent':v:true })
        call nvim_buf_set_keymap(l:bufnr, 'n', 'y', '/\c^y<cr><cr>', {'silent':v:true })
        call nvim_buf_set_keymap(l:bufnr, 'n', 'n', '/\c^n<cr><cr>', {'silent':v:true })
        let l:opts = {'relative': 'editor', 'width': &columns/6, 'height': len(a:menu_list), 'col': &columns/2-len(l:confirm_obj.prompt_str)/2,
                    \ 'row': &lines/2 - len(a:menu_list)/2, 'anchor': 'NW', 'border': 'single', 'style': 'minimal',
                    \ 'zindex': len(s:ctx) + 1, 'title':l:confirm_obj.prompt_str, 'focusable': v:true}
        let l:confirm_obj.win_id=nvim_open_win(l:bufnr, v:false,l:opts)
        let l:len = 0
        for l:str in a:menu_list
            call nvim_buf_set_lines(l:bufnr, l:len, -1, v:false, [l:str])
            let l:len += 1
        endfor
        let l:buf_opt = {'buftype':'nofile', 'buflisted':v:false, 'bufhidden':'wipe',
                    \ 'undolevels':-1, 'textwidth':0, 'swapfile':v:false,
                    \  'filetype':'vim-plug', 'modifiable':v:false,
                    \ }
        for [k,v] in items(l:buf_opt)
            call nvim_buf_set_option(l:bufnr, k, v)
        endfor
        call nvim_win_set_option(l:confirm_obj.win_id, 'cursorline', v:true)
        call nvim_win_set_option(l:confirm_obj.win_id, 'winhl', 
                    \ 'Normal:WarningMsg,FloatBorder:vinux_warn,CursorLine:vinux_sel,FloatTitle:vinux_warn')
        call nvim_win_set_option(l:confirm_obj.win_id, 'winblend', 50)
        call nvim_set_current_win(l:confirm_obj.win_id)
    elseif te#env#IsVim8() && l:block_vim  == 0
        let l:confirm_obj.win_id = popup_menu(a:menu_list, #{
                    \ callback: 'ConfirmResult',
                    \ border: [],
                    \ filter: 'te#utils#confirm_filter',
                    \ title: l:confirm_obj.prompt_str,
                    \ tab: -1,
                    \ hidden: 1,
                    \ zindex: len(s:ctx),
                    \ highlight: 'WarningMsg',
                    \ minwidth: &columns/6,
                    \ borderchars:['─', '│', '─', '│', '┌', '┐', '┘', '└'],
                    \ borderhighlight:['vinux_warn'],
                    \ })

    else
        let l:choices = ""
        for l:needle in a:menu_list
            let l:choices .= "&".l:needle."\n"
        endfor
        let l:confirm_obj.win_id = 0
        let l:result = confirm(l:confirm_obj.prompt_str, l:choices, 1)
        let s:ctx[l:confirm_obj.win_id] = l:confirm_obj
        return ConfirmResult(l:confirm_obj.win_id, l:result)
    endif
    let s:ctx[l:confirm_obj.win_id] = l:confirm_obj
    if te#env#IsVim8()
        call popup_show(l:confirm_obj.win_id)
    endif
    redraw
    return 0
endfunction
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

let s:win_list=[]
let s:global_echo_str=[]

function! te#utils#close_all_echo_win() abort
    for l:needle in s:win_list
        try
            if te#env#IsNvim() == 0
                call popup_close(l:needle.id)
            else
                call nvim_win_close(l:needle.id, v:true)
            endif
        catch
        endtry
    endfor
    let s:win_list=[]
endfunction

function! te#utils#close_win(winid, result) abort
    let l:index = 0
    for l:win in s:win_list
        if l:win.id == a:winid
            call remove(s:win_list, l:index)
        endif
        let l:index += 1
    endfor
endfunction

function! s:nvim_close_win(timer) abort
    call timer_info(a:timer)
    let l:flag=0
    if empty(s:win_list)
        return
    endif
    try
        call nvim_win_close(s:win_list[0].id, v:true)
    catch
        call remove(s:win_list, 0)
        let l:flag=1
    endtry
    if !empty(s:win_list) && l:flag == 0
        call remove(s:win_list, 0)
    endif
endfunction


"echo warning messag
"a:1-->err or warn or info,default is warn
function! te#utils#EchoWarning(str, ...) abort
    let l:level = 'vinux_warn'
    " Process optional arguments to determine message level
    if a:0 > 0
        for l:needle in a:000
            if type(l:needle) == v:t_string
                if l:needle ==? 'err'
                    let l:level = 'WarningMsg'
                elseif l:needle ==? 'warn'
                    let l:level = 'vinux_warn'
                elseif l:needle ==? 'info'
                    let l:level = 'vinux_info'
                endif
            endif
        endfor
    endif

    " Handle early startup case
    if has('vim_starting')
        call add(s:global_echo_str, a:str)
        return
    endif

    " Immediate display if no delay
    if g:message_delay_time.cur_val == '0'
        redraw!
        execute 'echohl' l:level | echom ' ' . a:str | echohl None
        return
    endif

    " Neovim floating window implementation
    if te#env#IsNvim() > 0 && te#env#SupportFloatingWindows() == 2
        let l:str = ' ' . a:str
        let l:str_len = strlen(l:str)
        let l:max_width = &columns / 3
        let l:win = {}

        " Calculate dimensions using ceiling division
        let l:win.str_width = (l:str_len + l:max_width - 1) / l:max_width
        let l:opts_width = l:str_len > l:max_width ? l:max_width : l:str_len

        " Window position calculation
        let l:win.line = empty(s:win_list) ? 3 : s:win_list[-1].line + 2 + s:win_list[-1].str_width

        " Window configuration
        let l:bufnr = nvim_create_buf(v:false, v:false)
        let l:opts = {
            \ 'relative': 'editor',
            \ 'width': l:opts_width,
            \ 'height': l:win.str_width,
            \ 'col': &columns,
            \ 'row': l:win.line,
            \ 'anchor': 'NW',
            \ 'border': 'single',
            \ 'style': 'minimal',
            \ 'zindex': 200}

        " Create and configure window
        let l:win.id = nvim_open_win(l:bufnr, v:false, l:opts)
        call nvim_buf_set_lines(l:bufnr, 0, -1, v:false, [l:str])
        call nvim_set_option_value('winhl','Normal:'.l:level.',FloatBorder:vinux_border', {'win': l:win.id})
        call nvim_set_option_value('buftype','nofile', {'buf': l:bufnr})
        call nvim_set_option_value('winblend', 30, {'win': l:win.id})

        call add(s:win_list, l:win)
        call timer_start(str2nr(g:message_delay_time.cur_val), function('<SID>nvim_close_win'), {'repeat': 1})

    " Vim popup implementation
    elseif te#env#SupportFloatingWindows() == 1
        let l:str = ' ' . a:str
        let l:str_len = strlen(l:str)
        let l:max_width = &columns / 3
        let l:win = {}

        " Calculate dimensions using ceiling division
        let l:win.str_width = (l:str_len + l:max_width - 1) / l:max_width
        let l:str_len = l:str_len > l:max_width ? l:max_width : l:str_len

        " Window position calculation
        let l:win.line = empty(s:win_list) ? 3 : s:win_list[-1].line + 2 + s:win_list[-1].str_width

        " Create popup with unified configuration
        let l:win.id = popup_create(l:str, {
            \ 'line': l:win.line,
            \ 'col': &columns - l:str_len - 3,
            \ 'time': str2nr(g:message_delay_time.cur_val),
            \ 'tab': -1,
            \ 'zindex': 200,
            \ 'highlight': l:level,
            \ 'maxwidth': l:max_width,
            \ 'border': [],
            \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
            \ 'borderhighlight': ['vinux_border'],
            \ 'callback': 'te#utils#close_win'})

        call add(s:win_list, l:win)

    " Fallback to simple echo
    else
        redraw!
        execute 'echohl' l:level | echom ' ' . a:str | echohl None
    endif
endfunction

function! te#utils#echo_info_after() abort
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
        execute 'cd '. fnamemodify(resolve(expand('%')), ':p:h')
    else
        execute 'lcd %:h'
    endif
    call te#utils#EchoWarning(getcwd())
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
    if a:url ==# ''
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
    "open help in vim
    let l:cur_word=expand('<cword>')
    if &filetype == 'vim'
        execute 'silent! help '.l:cur_word
        return 0
    endif
    let l:man_cmd=':Man'
    if !exists(l:man_cmd)
        call te#utils#EchoWarning('You must install lambdalisue/vim-manpager first!')
        return -1
    endif
    if &filetype =~# '\<sh\>\|\<cpp\>'
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
endfunction

let s:lastopen_tab=1
augroup Tabpage
    autocmd!
    autocmd TabLeave * let s:lastopen_tab=tabpagenr()
augroup end

"Return the total number of listed buffers
"opt:
"0:get all listed buffers
"1:get listed buffers of current tabpage
"2:get unlisted buffer of current tabpage
function! te#utils#get_buf_info(opt) abort
    let l:buf_list = []
    if a:opt == 0
        if te#env#SupportAsync()
            let l:temp_list = getbufinfo({'buflisted':1})
        else
            let l:temp_list = filter(range(1, bufnr('$')), 'buflisted(v:val)')
        endif
        for l:i in l:temp_list
            call add(l:buf_list, l:i.bufnr)
        endfor
    elseif a:opt == 1
        for l:i in tabpagebuflist()
            if buflisted(l:i)
                call add(l:buf_list, l:i)
            endif
        endfor
    elseif a:opt == 2
        for l:i in tabpagebuflist()
            if !buflisted(l:i)
                call add(l:buf_list, l:i)
            endif
        endfor
    elseif a:opt == 3
        if te#env#SupportAsync()
            let l:temp_list = getbufinfo()
        else
            let l:temp_list = filter(range(1, bufnr('$')), '!buflisted(v:val)')
        endif
        for l:i in l:temp_list
            if !buflisted(l:i.bufnr)
                call add(l:buf_list, l:i.bufnr)
            endif
        endfor
    endif
    return l:buf_list
endfunction

"Detect whether current buffer is listed or not
function! te#utils#is_listed_buffer() abort
    return buflisted(bufnr('%'))
endfunction

" quit current split windows
function! te#utils#quit_win(all) abort
    if a:all == 1
        if len(te#terminal#get_buf_list())
            call te#utils#EchoWarning("There are terminals not closed!")
            call te#terminal#jump_to_floating_win(-4)
            return
        endif
        call te#utils#confirm('Quit Vim Vim Vim Vim Vim ?', ['Yes', 'No'], ["wqa!", ""])
        return
    endif
    if te#env#IsNvim() > 0
        for l:win in nvim_tabpage_list_wins(0)
            let l:config = nvim_win_get_config(l:win)
            " close all Floating window
            if !empty(l:config.relative)
                call nvim_win_close(l:win, v:true)
            endif
        endfor
    endif

    " 0 or 1 listed buffer
    let l:cur_buf = bufnr()
    if !buflisted(l:cur_buf)
        :quit
        return
    endif

    let l:no_of_listed_buffer=len(te#utils#get_buf_info(0))
    if l:no_of_listed_buffer == 1 && winnr('$') == 1
        if len(te#terminal#get_buf_list())
            call te#utils#EchoWarning("There are terminals not closed!")
            call te#terminal#jump_to_floating_win(-4)
            return
        endif
        call te#utils#confirm('Quit Vim Vim Vim Vim Vim ?', ['Yes', 'No'], ["qall", ""])
    else
        let l:list1=te#utils#get_buf_info(2)
        let l:no_of_listed=len(te#utils#get_buf_info(1))
        if l:no_of_listed == 1
            if len(l:list1)
                for l:b in l:list1
                    call win_gotoid(win_findbuf(l:b)[0])
                    :quit
                endfor
            endif
            :bdelete
        else
            :quit
        endif
    endif
endfunction

"0:previous tab or buffer
"-1:next tab or buffer
"-2:lastopen tab or buffer
"1~9:tab 1~9 or buffer 1~9
function! te#utils#tab_buf_switch(num) abort
    if a:num == 0 || a:num == -1
        if len(te#utils#get_buf_info(0)) <= 1
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
                :update
                :b#
            endif
        else
            if tabpagenr('$') != 1 && a:num > tabpagenr('$')
                return
            endif
            execute 'normal '."\<Plug>AirlineSelectTab".a:num
        endif
    else
        if exists(':BufferGoto')
            :update
            if a:num == 0
                :BufferPrevious
            elseif a:num == -1
                :BufferNext
            elseif a:num == -2
                :b#
            elseif a:num == -3
                :BufferPick
            else
                execute ':BufferGoto '.a:num
            endif
        elseif exists( '*tabpagenr' ) && tabpagenr('$') != 1
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
            :update
            if a:num == 0
                :bprev
            elseif a:num == -1
                :bnext
            elseif a:num == -2
                :b#
            else
                execute 'normal '."\<Plug>BufTabLine.Go(".a:num.')'
            endif
        else
            :update
            if a:num == 0
                :bprev
                return
            elseif a:num == -1
                :bnext
                return
            elseif a:num == -2
                :b#
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
        set nonumber
        set norelativenumber
        set signcolumn=no
        let g:buftabline_show=0
    else
        if te#env#IsTmux()
            call system('tmux set -g status on')
        endif
        set laststatus=2
        set showtabline=1
        set number
        set relativenumber
        set signcolumn=yes
        let g:buftabline_show=1
    endif
endfunction

function! te#utils#check_health() abort
    if buflisted('[health]')
        call te#utils#EchoWarning("health buffer is already exist!")
        execute ':b '.bufnr("[health]")
        return
    endif
    tabnew
    nnoremap  <silent><buffer> q :call te#utils#quit_win(0)<cr>
    setlocal wrap
    setlocal filetype=health
    setlocal conceallevel=2 concealcursor=nc
    setlocal keywordprg=:help iskeyword=@,48-57,_,192-255,-,#
    let l:output = [
                \ 'Vim health info',
                \ '============================================',
                \ printf("%s:\t", 'Vim version') . te#feat#get_vim_version()[0] . ' ' . te#feat#get_vim_version()[1] . ' OS: ' . (te#env#IsMac() ? 'MacOS' : te#env#IsUnix() ? 'Unix' : te#env#IsWin32() ? 'Windows x86' : te#env#IsWin64() ? 'Windows x86_64' : ''),
                \ '',
                \ printf("%26s:\t", 'vim >= 7.3.1058') . (te#env#check_requirement() ? 'Yes' : '[No]'),
                \ '--------------------------------------------'
                \ ]

    for needle in ['termguicolors', 'lua', 'perl', 'ruby', 'tcl', 'timers', 'python', 'python3', 'cscope', 'multi_byte', 'signs', 'clipboard', 'clientserver']
        call add(l:output, printf("%26s:\t%s", needle . ' support', te#env#SupportFeature(needle) ? 'Yes' : '[No]'))
        call add(l:output, '--------------------------------------------')
    endfor

    call add(l:output, printf("%26s:\t%s", 'terminal support', te#env#SupportTerminal() ? 'Yes' : '[No]'))
    call add(l:output, '--------------------------------------------')

    call add(l:output, printf("%26s:\t%s", 'job support', te#env#SupportAsync() ? 'Yes' : '[No]'))
    call add(l:output, '--------------------------------------------')

    call add(l:output, printf("%26s:\t%s", 'ycm support', te#env#SupportYcm() ? 'Yes' : '[No]'))
    call add(l:output, '--------------------------------------------')

    call add(l:output, printf("%26s:\t%s", 'Floating window support', te#env#SupportFloatingWindows() ? 'Yes' : '[No]'))
    call add(l:output, '--------------------------------------------')

    for needle in ['cscope', 'ctags', 'ag', 'rg', 'git', 'gtags', 'clang', 'curl', 'bear', 'pbcopy', 'xsel', 'xclip', 'nvr', 'yapf', 'autopep8', 'node']
        call add(l:output, printf("%26s:\t%s", needle . ' exist', te#env#Executable(needle) ? 'Yes' : '[No]'))
        call add(l:output, '--------------------------------------------')
    endfor

    call append('$', l:output)
    setlocal nomodified
    setlocal nomodifiable
    setlocal bufhidden=delete
    highlight health ctermbg=red guibg=red
    call matchadd('health', '.*No.*')
    :f [Health]
endfunction

"te#utils#run_command (command [, callback] [,arglist] [, flag)
function! te#utils#run_command(command,...) abort
    if a:command =~# '^\s*$'
        let l:command = input('Run command:','','customlist,te#bashcomplete#cmd_complete')
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
        "TODO support call back?
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
    if type(l:dir) == g:t_number
        call te#utils#EchoWarning("List dir fail!", 'err')
        return ''
    endif
    for l:str in l:dir
        let l:result.=l:str.nr2char(10)
    endfor
    return l:result
endfunction

function! te#utils#cd_to_plugin(path) abort
    execute 'cd '.a:path
    let l:plugin_name = input('Please input the direcory name: ','','custom,te#utils#get_plugin_name')
    if !isdirectory(l:plugin_name)
        call te#utils#EchoWarning(l:plugin_name.' not found','err')
        cd -
        return
    endif
    execute 'cd '.l:plugin_name 
endfunction

function! s:pedit(line)
    setlocal nofoldenable
    execute a:line
    call matchaddpos('mypre', [a:line])
endfunction

function! te#utils#pedit()
    if &buftype != 'quickfix'
        call te#utils#EchoWarning('Not quickfix window')
        return
    endif
    let l:list_index=line(".")-1
    let l:list=getqflist()
    if len(l:list)
        let l:list = l:list[l:list_index]
        execute ':pedit +call\ s:pedit('.l:list.lnum.')'." ".bufname(l:list.bufnr)
    endif
endfunction

function! te#utils#get_reg()
    let l:result_list = []
    let l:regs = map(range(0, 127),'nr2char(v:val)')

    for i in l:regs
        let l:tmp_str = getreg(i)
        if !empty(l:tmp_str)
            call add(l:result_list, i.":".l:tmp_str)
        endif
    endfor
    return l:result_list
endfunction
