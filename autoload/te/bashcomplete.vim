let s:self = {}

let s:completer = $VIMFILES . '/bin/get_complete '

" this is for vim command completion 

function! s:self.complete(ArgLead, CmdLine, CursorPos) abort
    if a:CmdLine =~ '^\s\{0,\}\w\+$'
        return te#compatiable#systemlist('compgen -c ' . a:CmdLine)
    endif
    let result = te#compatiable#systemlist(s:completer.a:CmdLine)
    return map(result, 'substitute(v:val, "[ ]*$", "", "g")')
endfunction


" this is for vim input()

function! s:self.complete_input(ArgLead, CmdLine, CursorPos) abort
    if a:CmdLine =~ '^\s\{0,\}\w\+$'
        return te#compatiable#systemlist('compgen -c ' . a:CmdLine)
    endif
    let result = te#compatiable#systemlist(s:completer.a:CmdLine)
    if a:ArgLead == ''
        let result = map(result, 'a:CmdLine . v:val')
    else
        let leader = substitute(a:CmdLine, '[^ ]*$', '', 'g')
        let result = map(result, 'leader . v:val')
    endif
    return result
endfunction

function! te#bashcomplete#cmd_complete(ArgLead, CmdLine, CursorPos)
    setlocal sh=bash
    return s:self.complete_input(a:ArgLead, a:CmdLine, a:CursorPos)
endfunction

let s:pos = 0

let s:str = ''

let s:base = ''


function! te#bashcomplete#omnicomplete(findstart, base) abort
    if a:findstart
        let str = getline('.')[:col('.') - 2]
        let s:str = substitute(str, '[^ ]*$', '' , 'g')
        let s:pos = len(s:str)
        let s:base = str[s:pos :]
        return s:pos
    else
        return s:self.complete(a:base, s:str . s:base, col('.'))
    endif
endfunction
