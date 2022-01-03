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

function! te#terminal#open_term(buf, option)
    if len(win_findbuf(a:buf))
        if te#env#IsNvim() != 0
            call nvim_set_current_win(win_findbuf(a:buf)[0])
        else
            call win_gotoid(win_findbuf(a:buf)[0])
        endif
    else
        call te#terminal#shell_pop(a:option, a:buf)
    endif
    if te#env#IsNvim() != 0
        startinsert
    else
        if mode() != 't'
            call feedkeys('a')
        endif
    endif
endfunction

function! te#terminal#jump_to_floating_win() abort
    let l:term_list = te#terminal#get_buf_list()
    let l:no_of_term = len(l:term_list)
    if l:no_of_term == 0
        call te#utils#EchoWarning("No terminal window found!")
    elseif l:no_of_term == 1
        call te#terminal#open_term(l:term_list[0], 0x2)
    else
        call te#fzf#terminal#start()
    endif
endfunction

function! te#terminal#hide_popup()
    let l:win_id = win_getid()
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
                        \ 'row': l:row, 'anchor': 'NW', 'border': 'rounded', 'focusable': v:true, 'style': 'minimal'}
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
                call termopen(l:shell)
            endif
            return
        else
            if bufexists(expand('%')) && &filetype !=# 'startify'
                let l:fullbuffer=0
                let l:line=(38*&lines)/100
                if  l:line < 10 | let l:line = 10 |endif
                if and(a:option, 0x01)
                    let l:fullbuffer=1
                    execute 'rightbelow '.l:line.'split'
                elseif and(a:option, 0x02)
                    if a:0 == 0
                        let l:buf = term_start(l:shell, #{hidden: 1, term_finish: 'close'})
                        call setbufvar(l:buf, '&buflisted', 0)
                    else
                        let l:buf = a:1
                    endif
                    let l:win_id = popup_create(l:buf, {
                                \ 'line': 2,
                                \ 'col': &columns/2 - 1,
                                \ 'title': " Terminal",
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
                    call setwinvar(l:win_id, '&wincolor', 'Pmenu')
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
        call setwinvar(win_getid(), '&wincolor', 'Pmenu')
        call setbufvar(bufnr('%'), '&buflisted', 0)
    elseif te#env#IsTmux()
        call te#tmux#run_command(&shell, a:option)
    else 
        execute 'VimShell' 
    endif
endfunction
