"tmux function

function! s:run_tmux(args) abort
  let cmd = 'tmux ' . ' ' . a:args
  return system(cmd)
endfunction

function! s:reg2tmux(reg) abort
        let args = 'set-buffer "' . escape(a:reg, '"$\\') . '"'
        silent call s:run_tmux(args)
endfunction

function! s:tmux2reg() abort
        let args = "show-buffer"
        let @" = s:run_tmux(args)
endfunction

function! te#tmux#reg2tmux() abort
    :call <SID>reg2tmux(@")
endfunction

function! te#tmux#tmux2reg() abort
    :call <SID>tmux2reg()
endfunction

"flag
"0x1 hor split window
"0x2 vertical split window
"0x4 new window
"0x8 run command in background
function! te#tmux#run_command(cmd, flag) abort
    let l:action = 'split-window -p 38 '
    "split
    if and(a:flag, 0x1)
        let l:action = 'split-window -p 38 '
    elseif and(a:flag, 0x2)
        let l:action = 'split-window -h -p 50 '
    elseif and(a:flag, 0x4)
        let l:action = 'new-window '
    endif
    if and(a:flag, 0x8)
        let l:action .= ' -d '
    endif
    call system('tmux '.l:action.string(a:cmd))
endfunction

function! te#tmux#rename_win(name) abort
    if a:name !=# ''
        let l:name = a:name
    else
        let l:name=input("Input the name of current windows: ")
    endif
    call te#utils#run_command('tmux rename-window '.l:name)
endfunction
