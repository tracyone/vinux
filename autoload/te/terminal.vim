let s:term_obj = {}

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

function! te#terminal#get_title(buf)
    if has_key(s:term_obj,a:buf)
        return s:term_obj[a:buf].title
    endif
endfunction

function! te#terminal#get_option(buf)
    if has_key(s:term_obj,a:buf)
        return s:term_obj[a:buf].option
    endif
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

function! te#terminal#rename()
    let l:buf = bufnr('%')
    let l:win_id = win_getid()
    if te#terminal#is_term_buf(l:buf) == v:true
        if l:win_id != 0
            let l:user_input = ' '
            let l:user_input .= input('Please input a new name: ')
            let s:term_obj[l:buf].title = l:user_input
            if te#env#IsNvim() == 0
                let l:origin_opt = popup_getoptions(l:win_id)
                let l:user_input .= matchstr(l:origin_opt.title, "[\\d/\\d\\]")
                call popup_setoptions(l:win_id, {'title':l:user_input})
            endif
        else
            call te#utils#EchoWarning("Can not find window id for ".l:buf)
        endif
    else
        call te#utils#EchoWarning("Not a terminal buffer!")
    endif
    if te#env#IsNvim() != 0
        startinsert
    else
        if mode() != 't'
            call feedkeys('a')
        endif
    endif
endfunction

function! te#terminal#open_term(...)
    if a:0 > 2 || a:0 == 0
        call te#utils#EchoWarning("Error argument!")
        return
    endif
    let l:buf = a:1

    if len(win_findbuf(l:buf))
        if te#env#IsNvim() != 0
            call nvim_set_current_win(win_findbuf(l:buf)[0])
        else
            call win_gotoid(win_findbuf(l:buf)[0])
        endif
    else
        if a:0 == 2
            call te#terminal#shell_pop(a:2, l:buf)
        else
            call te#terminal#shell_pop(0, l:buf)
        endif
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
        call te#terminal#open_term(l:term_list[0])
    else
        let l:last_close_bufnr = s:last_close_bufnr
        if te#terminal#is_term_buf(bufnr('%')) == v:true
            let l:current_term_buf = bufnr('%')
            call te#terminal#hide_popup()
        endif
        if a:num == -4
            "in terminal or out out terminal
            if g:fuzzysearcher_plugin_name.cur_val == 'fzf'
                call te#fzf#terminal#start()
            elseif g:fuzzysearcher_plugin_name.cur_val == 'leaderf'
                :Leaderf term
            elseif g:fuzzysearcher_plugin_name.cur_val == 'ctrlp'
                :call te#ctrlp#term#start()
            else
                call te#terminal#open_term(l:last_close_bufnr)
            endif
        elseif a:num >= 0
            "in terminal or out out terminal
            if a:num < l:no_of_term
                call te#terminal#open_term(l:term_list[a:num])
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
                    call te#terminal#open_term(l:term_list[l:cur_index - 1])
                else
                    let l:cur_index = l:no_of_term
                    call te#terminal#open_term(l:term_list[l:cur_index - 1])
                endif
            endif
            if a:num == -2
                if l:cur_index + 1 < l:no_of_term
                    call te#terminal#open_term(l:term_list[l:cur_index + 1])
                else
                    let l:cur_index = 0
                    call te#terminal#open_term(l:term_list[0])
                endif
            endif
        elseif a:num == -3
            call te#terminal#open_term(l:last_close_bufnr)
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
    try
        if te#env#IsNvim() != 0
            call nvim_win_close(l:win_id, v:true)
        else
            if win_gettype() != 'popup'
                :hide
            else
                call popup_close(l:win_id)
            endif
        endif
    catch /last/
        call te#utils#EchoWarning("Can not close last window")
    endtry
endfunction

fun! s:OnExit(job_id, code, event)
    if a:code == 0
        call remove(s:term_obj, bufnr("%"))
        :bd
    endif
endfun

func s:JobExit(job, status)
    call remove(s:term_obj, bufnr("%"))
    close
endfunc

"pop vimshell
"option:0x04 open terminal in a new tab
"option:0x01 open terminal in a split window
"option:0x02 open terminal in a vsplit window
"option:0x0 use second arg buf's option,s:term_obj
function! te#terminal#shell_pop(option,...) abort
    " 38% height of current window
    let l:term_obj = {}
    if a:0 > 1
        call te#utils#EchoWarning("Error argument!")
        return
    endif
    if a:option == 0 && a:0 == 1
        let l:option = te#terminal#get_option(a:1)
    else
        let l:option = a:option
    endif
    call te#server#connect()
    if te#env#IsGui() && te#env#IsUnix()
        let l:shell='bash'
    else
        let l:shell=&shell
    endif
    let l:title = ' Terminal'
    if te#env#SupportTerminal()
        let l:line=(38*&lines)/100
        if  l:line < 10 | let l:line = 10 |endif
        if and(l:option, 0x04)
            :tabnew
        elseif and(l:option, 0x01)
            execute 'rightbelow '.l:line.'split'
        endif
        if te#env#SupportFloatingWindows() == 2
            let l:row=1
            let l:width=&columns/2
            if a:0 == 1
                let l:buf = a:1
                let l:term_obj.title = te#terminal#get_title(l:buf)
            else
                let l:buf = nvim_create_buf(v:false, v:true)
                let l:term_obj.title = l:title
                call nvim_buf_set_option(l:buf, 'buftype', 'nofile')
                call nvim_buf_set_option(l:buf, 'buflisted', v:false)
                call nvim_buf_set_option(l:buf, 'bufhidden', 'hide')
            endif
            let l:term_obj.option = l:option
            let s:term_obj[l:buf] = l:term_obj
            if and(l:option, 0x02)
                let l:opts = {'relative': 'editor', 'width': l:width, 'height': l:line, 'col': &columns/2-1,
                            \ 'row': l:row, 'anchor': 'NW', 'border': 'rounded', 'focusable': v:true, 'style': 'minimal', 'zindex': 1}
                let l:win_id=nvim_open_win(l:buf, v:true, l:opts)
                call nvim_win_set_option(l:win_id, 'winhl', 'FloatBorder:vinux_border')
                call nvim_win_set_option(l:win_id, 'winblend', 30)
            else
                execute ':buf '.l:buf
            endif
            if a:0 == 0
                call termopen(l:shell, {'on_exit': function('<SID>OnExit')})
            endif
            return
        elseif te#env#SupportFloatingWindows()
            let l:term_list = te#terminal#get_buf_list()
            if a:0 == 0
                let l:buf = term_start(l:shell, #{hidden: 1, exit_cb:function('<SID>JobExit')})
                call setbufvar(l:buf, '&buflisted', 0)
                let l:no_of_term = len(l:term_list) + 1
                let l:term_obj.title = l:title
                let l:title .= '['.l:no_of_term.'/'.l:no_of_term.']'
            else
                let l:buf = a:1
                let l:cur_index = te#terminal#get_index(l:buf) + 1
                let l:title = te#terminal#get_title(l:buf)
                let l:term_obj.title = l:title
                let l:title .= '['.l:cur_index.'/'.len(l:term_list).']'
            endif
            let l:term_obj.option = l:option
            let s:term_obj[l:buf] = l:term_obj
            if  and(l:option, 0x02)
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
            else
                execute ':buf '.l:buf
            endif
            return
        endif
    endif

    if te#env#IsTmux()
        call te#tmux#run_command(&shell, l:option)
    else 
        execute 'VimShell' 
    endif
endfunction
