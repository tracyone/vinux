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

