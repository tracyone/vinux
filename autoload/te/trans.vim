
let s:base_cmd = 'trans -no-ansi -no-auto -no-warn -brief'

function! te#trans#translate(source_target) abort
    if !s:check_executable() | return | endif
    call te#utils#run_command(s:base_cmd . ' ' . a:source_target.' -i '.expand('%:p'),1)
endfunction

function! te#trans#replace(source_target) abort
    if !s:check_executable() | return | endif
    silent! normal! gv"ay
    let l:cmd = s:base_cmd . ' ' . a:source_target . ' ' . shellescape(@a)
    call te#utils#run_command(l:cmd,1)
endfunction

function! s:check_executable() abort
    if !te#env#Executable('trans') 
        call te#utils#EchoWarning('translate-shell not found. wget git.io/trans!')
        call te#utils#run_command('wget git.io/trans -O '.$VIMFILES.'/bin/trans && chmod a+x '.$VIMFILES.'/bin/trans',1)
        return 0
    endif
    if !te#env#Executable('gawk')
        call te#utils#EchoWarning('gawk not found. Please install it!')
        return 0
    endif
    return 1
endfunction


