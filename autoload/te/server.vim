"=============================================================================
" server.vim --- server manager
"=============================================================================

" This function should not be called twice!

let s:flag = 0
function! te#server#connect()
  if s:flag == 0
    if empty($TVIM_SERVER_ADDRESS)
      let $TVIM_SERVER_ADDRESS = fnamemodify('/tmp/' . (has('nvim') ? 'nvim_' : 'vim_') . 'server', ':p')
    endif
    if has('nvim')
      try
        call serverstart($TVIM_SERVER_ADDRESS)
      catch
      endtry
    elseif has('clientserver') && exists('*remote_startserver')
      if index(split(serverlist(), "\n"), $TVIM_SERVER_ADDRESS) == -1
        try
          call remote_startserver($TVIM_SERVER_ADDRESS)
        catch
        endtry
      endif
    endif
    let s:flag = 1
  endif
endfunction


function! te#server#export_server()
  if executable('export')
    call system('export $TEST_SPACEVIM="test"') 
  endif
endfunction

function! te#server#terminate()

endfunction

function! te#server#list()
  if has('nvim')
    return join(serverlist(), "\n")
  else
  endif
endfunction



