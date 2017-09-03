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

function! te#tmux#run_command(cmd, option) abort
    let l:action = ''
    "split
    if and(a:option, 0x1)
        let l:action = 'split-window -p 38 '
    elseif and(a:option, 0x2)
        let l:action = 'split-window -h -p 50 '
    elseif and(a:option, 0x4)
        let l:action = 'new-window '
    endif
    call system('tmux '.l:action.a:cmd)
endfunction
