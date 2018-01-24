"=============================================================================
" server.vim --- server manager
"=============================================================================

" This function should not be called twice!

let s:flag = 0
function! te#server#connect()
    "start server one time
    "no need to start server in gvim
    if s:flag == 0 && !te#env#IsGui()
        if empty($TVIM_SERVER_ADDRESS)
            let $TVIM_SERVER_ADDRESS = fnamemodify('/tmp/' . (has('nvim') ? 'nvim_' : 'vim_') . 'server', ':p')
        endif
        if te#env#IsNvim()
            let $IN_VIM='nvim'
            try
                call serverstart($TVIM_SERVER_ADDRESS)
            catch
            endtry
            if !te#env#Executable('nvr')
                let $VIM_REMOTE=''
            else
                let $VIM_REMOTE='nvr --servername /tmp/nvim_server '
            endif
        elseif has('clientserver') && exists('*remote_startserver') && te#env#IsDisplay()
            let $IN_VIM='vim'
            if index(split(serverlist(), "\n"), $TVIM_SERVER_ADDRESS) == -1
                let $VIM_REMOTE='vim --servername /tmp/vim_server '
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
        let $IN_VIM='mvim'
        let $VIM_REMOTE='/Applications/MacVim.app/Contents/bin/mvim '
    elseif te#env#IsGui()
        let $IN_VIM='gvim'
        let $VIM_REMOTE='gvim '
    endif
endfunction

function! te#server#list()
    if has('nvim')
        return join(serverlist(), "\n")
    else
    endif
endfunction



