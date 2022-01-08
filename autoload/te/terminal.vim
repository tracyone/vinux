function! te#terminal#get_buf_list()
    let l:last_buffer = bufnr('$')
	let l:n = 1
    let l:result_list = []
	while l:n <= l:last_buffer
        let l:name=bufname(l:n)
        if strlen(matchstr(l:name, 'term://'))
            call add(l:result_list, l:n)
        elseif getbufvar(l:n, '&buftype', 'ERROR') ==# 'terminal'
            call add(l:result_list, l:n)
        endif
        let l:n = l:n+1
    endwhile
    return l:result_list
endfunction

function! te#terminal#get_index(bufno)
    let l:term_list = te#terminal#get_buf_list()
    let l:index = 0
    for l:i in l:term_list
        if l:i == a:bufno
            break
        endif
        let l:index += 1
    endfor
    if l:index >= len(l:term_list)
        return -1
    endif
    return l:index
endfunction

function! te#terminal#is_term_buf(bufno)
    let l:name=bufname(a:bufno)
    if strlen(matchstr(l:name, 'term://'))
        return v:true
    elseif getbufvar(a:bufno, '&buftype', 'ERROR') ==# 'terminal'
        return v:true
    else
        return v:false
    endif
endfunction

function! te#terminal#open_term(...)
    let l:buf = a:1
    let l:option = a:2
    if len(win_findbuf(l:buf))
        if te#env#IsNvim() != 0
            call nvim_set_current_win(win_findbuf(l:buf)[0])
        else
            call win_gotoid(win_findbuf(l:buf)[0])
        endif
    else
        call te#terminal#shell_pop(l:option, l:buf)
    endif
    if te#env#IsNvim() != 0
        startinsert
    else
        if mode() != 't'
            call feedkeys('a')
        endif
    endif
endfunction

"num can be following value:
"-1:previous terminal
"-2:next terminal
"-3:lastopen terminal
"-4:select terminal in fzf
"0~9:0~9 terminal
function! te#terminal#jump_to_floating_win(num) abort
    let l:term_list = te#terminal#get_buf_list()
    let l:no_of_term = len(l:term_list)
    let l:current_term_buf = -1
    if l:no_of_term == 0
        call te#utils#EchoWarning("No terminal window found! Try to create a new one!")
        call te#terminal#shell_pop(0x2)
    elseif l:no_of_term == 1 && a:num != -5
        call te#terminal#open_term(l:term_list[0], 0x2)
    else
        if te#terminal#is_term_buf(bufnr('%')) == v:true
            let l:current_term_buf = bufnr('%')
            let l:last_close_bufnr = s:last_close_bufnr
            call te#terminal#hide_popup()
        endif
        if a:num == -4
            "in terminal or out out terminal
            call te#fzf#terminal#start()
        elseif a:num >= 0
            "in terminal or out out terminal
            if a:num < l:no_of_term
                call te#terminal#open_term(l:term_list[a:num], 0x2)
            else
                call te#utils#EchoWarning("Out of range ".a:num.' number of terminal: '.l:no_of_term)
            endif
        elseif a:num == -1 || a:num == -2
            "in terminal only
            if l:current_term_buf < 0
                call te#utils#EchoWarning("Only support in terminal")
                return
            endif
            let l:cur_index = te#terminal#get_index(l:current_term_buf)
            if a:num == -1
                if l:cur_index > 0
                    call te#terminal#open_term(l:term_list[l:cur_index - 1], 0x2)
                else
                    let l:cur_index = l:no_of_term
                    call te#terminal#open_term(l:term_list[l:cur_index - 1], 0x2)
                endif
            endif
            if a:num == -2
                if l:cur_index + 1 < l:no_of_term
                    call te#terminal#open_term(l:term_list[l:cur_index + 1], 0x2)
                else
                    let l:cur_index = 0
                    call te#terminal#open_term(l:term_list[0], 0x2)
                endif
            endif
        elseif a:num == -3
            if l:current_term_buf < 0
                call te#utils#EchoWarning("Only support in terminal")
                return
            endif
            call te#terminal#open_term(l:last_close_bufnr, 0x2)
        elseif a:num == -5
            if l:current_term_buf < 0
                call te#utils#EchoWarning("Only support in terminal")
                return
            endif
            call te#terminal#shell_pop(0x2)
        else
            call te#utils#EchoWarning("Wrong option: ".a:num)
        endif
    endif
endfunction

let s:last_close_bufnr = -1
function! te#terminal#hide_popup()
    let l:win_id = win_getid()
    let s:last_close_bufnr = bufnr('%')
    if te#env#IsNvim() != 0
        call nvim_win_close(l:win_id, v:true)
    else
        if win_gettype() != 'popup'
            :hide
        else
            call popup_close(l:win_id)
        endif
    endif
endfunction

fun! s:OnExit(job_id, code, event)
    if a:code == 0
        close
    endif
endfun

"pop vimshell
"option:0x04 open terminal in a new tab
"option:0x01 open terminal in a split window
"option:0x02 open terminal in a vsplit window
function! te#terminal#shell_pop(option,...) abort
    " 38% height of current window
    if a:0 > 1
        call te#utils#EchoWarning("Error argument!")
        return
    endif
    call te#server#connect()
    if te#env#IsGui() && te#env#IsUnix()
        let l:shell='bash'
    else
        let l:shell=&shell
    endif
    if !te#env#IsTmux() || te#env#SupportTerminal()
        if and(a:option, 0x04)
            :tabnew
        endif
        if te#env#SupportFloatingWindows() == 2 && !and(a:option, 0x04)
            let l:line=(38*&lines)/100
            if  l:line < 10 | let l:line = 10 |endif
            if and(a:option, 0x01)
                let l:row=&lines-l:line
                let l:width=&columns
            elseif and(a:option, 0x02)
                let l:row=1
                let l:width=&columns/2
            endif
            let l:opts = {'relative': 'editor', 'width': l:width, 'height': l:line, 'col': &columns/2-1,
                        \ 'row': l:row, 'anchor': 'NW', 'border': 'rounded', 'focusable': v:true, 'style': 'minimal', 'zindex': 1}
            if a:0 == 0
                let l:buf = nvim_create_buf(v:false, v:true)
                call nvim_buf_set_option(l:buf, 'buftype', 'nofile')
                call nvim_buf_set_option(l:buf, 'buflisted', v:false)
                call nvim_buf_set_option(l:buf, 'bufhidden', 'hide')
            else
                let l:buf = a:1
            endif
            let l:win_id=nvim_open_win(l:buf, v:true, l:opts)
            call nvim_win_set_option(l:win_id, 'winhl', 'FloatBorder:vinux_border')
            call nvim_win_set_option(l:win_id, 'winblend', 30)
            if a:0 == 0
                call termopen(l:shell, {'on_exit': function('<SID>OnExit')})
            endif
            return
        else
            if bufexists(expand('%')) && &filetype !=# 'startify'
                let l:fullbuffer=0
                let l:title = ' Terminal'
                let l:line=(38*&lines)/100
                if  l:line < 10 | let l:line = 10 |endif
                let l:term_list = te#terminal#get_buf_list()
                if and(a:option, 0x01)
                    let l:fullbuffer=1
                    execute 'rightbelow '.l:line.'split'
                elseif and(a:option, 0x02)
                    if a:0 == 0
                        let l:buf = term_start(l:shell, #{hidden: 1, term_finish: 'close'})
                        call setbufvar(l:buf, '&buflisted', 0)
                        let l:no_of_term = len(l:term_list) + 1
                        let l:title .= '['.l:no_of_term.'/'.l:no_of_term.']'
                    else
                        let l:buf = a:1
                        let l:cur_index = te#terminal#get_index(l:buf) + 1
                        let l:title .= '['.l:cur_index.'/'.len(l:term_list).']'
                    endif
                    let l:win_id = popup_create(l:buf, {
                                \ 'line': 2,
                                \ 'col': &columns/2 - 1,
                                \ 'title': l:title,
                                \ 'zindex': 200,
                                \ 'minwidth': &columns/2,
                                \ 'minheight': l:line,
                                \ 'maxwidth': &columns/2,
                                \ 'maxheight': l:line,
                                \ 'border': [],
                                \ 'borderchars':['─', '│', '─', '│', '┌', '┐', '┘', '└'],
                                \ 'borderhighlight':['vinux_border'],
                                \ 'drag': 1,
                                \ 'close': 'button',
                                \ })
                    "call setwinvar(l:win_id, '&wincolor', 'Pmenu')
                    return
                    ":botright vsplit
                endif
            endif
        endif
    endif
    if a:0 != 0
        execute ':buf '.a:1
        return
    endif

    if te#env#SupportTerminal()  && te#env#IsVim8()
        execute ':terminal ++close ++curwin '.l:shell
        "call setwinvar(win_getid(), '&wincolor', 'Pmenu')
        call setbufvar(bufnr('%'), '&buflisted', 0)
    elseif te#env#IsTmux()
        call te#tmux#run_command(&shell, a:option)
    else 
        execute 'VimShell' 
    endif
endfunction
