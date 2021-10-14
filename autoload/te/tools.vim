function! te#tools#jump_to_floating_win() abort
    let l:last_buffer = bufnr('$')
	let l:n = 1

	while l:n <= l:last_buffer
        if buflisted(l:n)
            let l:name=bufname(l:n)
            if strlen(matchstr(l:name, 'term://'))
                call nvim_set_current_win(win_findbuf(l:n)[0])
                startinsert
                break
            elseif getbufvar(l:n, '&buftype', 'ERROR') ==# 'terminal'
                call win_gotoid(win_findbuf(l:n)[0])
                if mode() != 't'
                    call feedkeys('a')
                endif
                break
            endif
        endif
        let l:n = l:n+1
    endwhile
    if l:n > l:last_buffer
        call te#utils#EchoWarning("No terminal window found!")
    endif

endfunction
"pop vimshell
"option:0x04 open terminal in a new tab
"option:0x01 open terminal in a split window
"option:0x02 open terminal in a vsplit window
function! te#tools#shell_pop(option) abort
    " 38% height of current window
    call te#server#connect()
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
                let l:row=0
                let l:width=&columns/2
            endif
            let l:opts = {'relative': 'editor', 'width': l:width, 'height': l:line, 'col': &columns/2-1,
                        \ 'row': l:row, 'anchor': 'NW'}
            let l:win_id=nvim_open_win(winbufnr(0), v:true, l:opts)
            call nvim_win_set_option(l:win_id, 'winblend', 30)
        else
            if bufexists(expand('%')) && &filetype !=# 'startify'
                let l:fullbuffer=0
                if and(a:option, 0x01)
                    let l:line=(38*&lines)/100
                    if  l:line < 10 | let l:line = 10 |endif
                    let l:fullbuffer=1
                    execute 'rightbelow '.l:line.'split'
                elseif and(a:option, 0x02)
                    :botright vsplit
                endif
            endif
        endif
    endif

    if te#env#IsGui() && te#env#IsUnix()
        let l:shell='bash'
    else
        let l:shell=&shell
    endif
    if te#env#SupportTerminal()  && te#env#IsVim8()
        execute ':terminal ++close ++curwin '.l:shell
    elseif te#env#SupportTerminal() && te#env#IsNvim() != 0
        :terminal
    elseif te#env#IsTmux()
        call te#tmux#run_command(&shell, a:option)
    else 
        execute 'VimShell' 
    endif
endfunction
"put message from vim command to + register
function! te#tools#vim_get_message() abort
    let l:command=input('Input command: ')
    if l:command !=# ''
        execute ':redir @+> | silent '.l:command.' | redir END'
    else
        call te#utils#EchoWarning('Empty command is not allowed!', 'err')
    endif
endfunction

"update latest stable t_vim
function! te#tools#update_vinux() abort
    if isdirectory('.git') && te#env#Executable('git')
        call te#utils#EchoWarning('Updating ...')
        let l:temp1=te#compatiable#systemlist('git rev-list --tags --max-count=1')
        if type(l:temp1) == g:t_number
            call te#utils#EchoWarning('git rev-list --tags --max-count=1 fail','err')
            return ''
        endif
        let l:temp2=te#compatiable#systemlist('git describe --tags '.l:temp1[0])
        if type(l:temp2) == g:t_number
            call te#utils#EchoWarning('git describe --tags '.l:temp1[0],'err')
            return ''
        endif
        call te#utils#run_command('git checkout '.l:temp2[0], function('te#feat#gen_feature_vim'), [0])
    else
        call te#utils#EchoWarning('Not a git repository or git not found!', 'err')
    endif
endfunction


let s:max_flag=0
function! te#tools#max_win() abort
    if s:max_flag == 0
        if te#env#IsMacVim()
            set fullscreen
        elseif te#env#IsUnix()
            :win 1999 1999
            silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
        elseif te#env#IsWindows()
            :simalt~x "maximize window
        else
            :win 1999 1999
        endif
        let s:max_flag=1
    else
        let s:max_flag=0
        if te#env#IsMacVim()
            set nofullscreen
        endif
        :win 80 25
    endif
endfunction

function! te#tools#buf_only(buffer, bang) abort
	if a:buffer ==# ''
		" No l:buffer provided, use the current l:buffer.
		let l:buffer = bufnr('%')
	elseif (a:buffer + 0) > 0
		" A l:buffer number was provided.
		let l:buffer = bufnr(a:buffer + 0)
	else
		" A l:buffer name was provided.
		let l:buffer = bufnr(a:buffer)
	endif

	if l:buffer == -1
        call te#utils#EchoWarning('No matching l:buffer for '.a:buffer, 'err')
		return
	endif

	let l:last_buffer = bufnr('$')

	let l:delete_count = 0
	let l:n = 1
	while l:n <= l:last_buffer
		if l:n != l:buffer && buflisted(l:n)
			if a:bang ==# '' && getbufvar(l:n, '&modified')
                call te#utils#EchoWarning('No write since last change for l:buffer (add ! to override)', 'err')
			else
				silent exe 'bdel' . a:bang . ' ' . l:n
				if ! buflisted(l:n)
					let l:delete_count = l:delete_count+1
				endif
			endif
		endif
		let l:n = l:n+1
	endwhile

    call te#utils#EchoWarning(l:delete_count.' buffers deleted')
endfunction

" 0:up, 1:down, 2:pgup, 3:pgdown, 4:top, 5:bottom
function! te#tools#PreviousCursor(mode) abort
	if winnr('$') <= 1
		return
	endif
	noautocmd silent! wincmd p
	if a:mode == 0
		exec "normal! \<c-y>"
	elseif a:mode == 1
		exec "normal! \<c-e>"
	elseif a:mode == 2
		exec 'normal! '.winheight('.')."\<c-y>"
	elseif a:mode == 3
		exec 'normal! '.winheight('.')."\<c-e>"
	elseif a:mode == 4
		normal! gg
	elseif a:mode == 5
		normal! G
	elseif a:mode == 6
		exec "normal! \<c-u>"
	elseif a:mode == 7
		exec "normal! \<c-d>"
	elseif a:mode == 8
		exec 'normal! k'
	elseif a:mode == 9
		exec 'normal! j'
	endif
	noautocmd silent! wincmd p
endfunction

function! te#tools#get_enabler_linter() abort
    if exists('*neomake#makers#ft#'.&filetype.'#EnabledMakers()')
        execute 'echohl WarningMsg | echom "Available linter for ".&filetype.": ".string(neomake#makers#ft#'.&filetype.'#EnabledMakers()) | echohl None'
    else
        call te#utils#EchoWarning("Not support filetype: ".&filetype, 'err')
    endif
endfunction
