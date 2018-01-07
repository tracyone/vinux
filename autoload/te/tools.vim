"pop vimshell
"option:0x04 open terminal in a new tab
"option:0x01 open terminal in a split window
"option:0x02 open terminal in a vsplit window
function! te#tools#shell_pop(option) abort
    " 38% height of current window
    call te#server#connect()
    if and(a:option, 0x04)
        :tabnew
    endif
    "any list buffer exist or buffer is startify
    if bufexists(expand('%')) && &filetype !=# 'startify'
                \ && &modified == 0
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
    if te#env#IsGui() && te#env#IsUnix()
        let l:shell='bash'
    else
        let l:shell=&shell
    endif
    if te#env#SupportTerminal()  && te#env#IsVim8()
        execute ':terminal ++close ++curwin '.l:shell
    elseif te#env#SupportTerminal() && te#env#IsNvim()
        :terminal
    elseif te#env#IsTmux()
        if and(a:option, 0x04)
            :q
        endif
        call te#tmux#run_command(&shell, a:option)
    else 
        execute 'VimShell' 
    endif
endfunction
"put message from vim command to + register
function! te#tools#vim_get_message()
    let l:command=input('Input command: ')
    if l:command !=# ''
        execute ':redir @+> | silent '.l:command.' | redir END'
    else
        call te#utils#EchoWarning('Empty command is not allowed!', 'err')
    endif
endfunction

"update latest stable t_vim
function! te#tools#update_t_vim() abort
    if isdirectory('.git') && te#env#Executable('git')
        call te#utils#EchoWarning('Updating ...')
        let l:temp1=te#compatiable#systemlist('git rev-list --tags --max-count=1')
        let l:temp2=te#compatiable#systemlist('git describe --tags '.l:temp1[0])
        call te#utils#run_command('git checkout '.l:temp2[0], function('te#feat#gen_feature_vim'), [0])
    else
        call te#utils#EchoWarning('Not a git repository or git not found!', 'err')
    endif
endfunction


function! te#tools#max_win() abort
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
endfunction

function! te#tools#buf_only(buffer, bang) abort
	if a:buffer == ''
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
        call te#utils#EchoWarning("No matching l:buffer for" a:buffer, 'err')
		return
	endif

	let l:last_buffer = bufnr('$')

	let l:delete_count = 0
	let l:n = 1
	while l:n <= l:last_buffer
		if l:n != l:buffer && buflisted(l:n)
			if a:bang == '' && getbufvar(l:n, '&modified')
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

    call te#utils#EchoWarning(l:delete_count." buffers deleted")
endfunction
