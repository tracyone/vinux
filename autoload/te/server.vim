"=============================================================================
" server.vim --- server manager
"=============================================================================

" This function should not be called twice!

let s:flag = 0
function! te#server#connect()
    if s:flag == 0
        let $IN_VIM='vim'
        if empty($TVIM_SERVER_ADDRESS)
            let $TVIM_SERVER_ADDRESS = fnamemodify('/tmp/' . (has('nvim') ? 'nvim_' : 'vim_') . 'server', ':p')
        endif
        if te#env#IsNvim()
            try
                call serverstart($TVIM_SERVER_ADDRESS)
            catch
            endtry
            if !te#env#Executable('nvr')
                let $VIM_REMOTE=''
            else
                let $VIM_REMOTE='nvr --servername /tmp/nvim_server --remote-tab-silent '
            endif
        elseif has('clientserver') && exists('*remote_startserver') && te#env#IsDisplay()
            if index(split(serverlist(), "\n"), $TVIM_SERVER_ADDRESS) == -1
                let $VIM_REMOTE='vim --servername /tmp/vim_server --remote-silent-tab '
                try
                    call remote_startserver($TVIM_SERVER_ADDRESS)
                catch
                endtry
            endif
        else
            let $VIM_REMOTE=''
        endif
        let s:flag = 1
    endif
    if te#env#IsMacVim()
        let $VIM_REMOTE='/Applications/MacVim.app/Contents/bin/mvim --remote-tab-silent '
    elseif te#env#IsGui()
        let $VIM_REMOTE='gvim --remote-tab-silent '
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



