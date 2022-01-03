

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
