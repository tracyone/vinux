"environment check
let s:is_unix     = ( has('mac') + has('unix') )
let s:is_win      = has('win32') + has('win64')
let s:is_nvim     = has('nvim')
let s:is_gui      = has('gui_running') + has('gui_macvim')
let s:has_python  = has('python')
let s:has_python3 = has('python3')
let s:python_ver  = s:has_python+s:has_python3
let s:ycm_dependency = has('patch-7.4.143')
let s:is_tmux = empty($TMUX)

function! te#env#IsVim8() abort
    if v:version >= 800
        return 1
    else
        return 0
    endif
endfunction

function! te#env#IsMac() abort
    if s:is_unix == 2 | return 1 | endif
    return 0
endfunction

function! te#env#IsWindows() abort
    if s:is_win | return 1 | endif
    return 0
endfunction

function! te#env#IsWin64() abort
    if s:is_win == 2 | return 1 | endif
endfunction

function! te#env#IsWin32() abort
    if s:is_win == 1 | return 1 | endif
    return 0
endfunction

function! te#env#IsNvim()
    if s:is_nvim | return 1 | endif
    return 0
endfunction

function! te#env#IsGui()
    if s:is_gui | return 1 | endif
    return 0
endfunction

function! te#env#IsMacVim()
    if s:is_gui == 2 | return 1 | endif
    return 0
endfunction

function! te#env#SupportPy2()
    if s:has_python | return 1 |endif
    return 0
endfunction

function! te#env#SupportPy3()
    if s:has_python3 | return 1 |endif
    return 0
endfunction

function! te#env#SupportPy()
    if s:python_ver | return 1 | endif
    return 0
endfunction

function! te#env#SupportYcm()
    if s:ycm_dependency && s:python_ver | return 1 | endif
    return 0
endfunction

function! te#env#IsTmux()
    if  s:is_tmux
        return 0
    endif
    return 1
endfunction

function! te#env#IsUnix()
    if s:is_unix | return 1 | endif
    return 0
endfunction
