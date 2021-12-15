if(!te#env#IsWindows())
    if te#env#IsTmux()
        Plug 'christoomey/vim-tmux-navigator', {'on': []}
        if g:fuzzysearcher_plugin_name.cur_val ==# 'ctrlp'
            Plug 'lucidstack/ctrlp-tmux.vim',{'on': 'CtrlPTmux'}
            "CtrlP tmux window
            nnoremap  <silent><Leader>uu :CtrlPTmux w<cr>
            "CtrlP tmux buffer
            nnoremap  <silent><Leader>uf :CtrlPTmux b<cr>
            "CtrlP tmux session
            nnoremap  <silent><Leader>um :CtrlPTmux<cr>
            "CtrlP tmux command
            nnoremap  <silent><Leader>uc :CtrlPTmux c<cr>
            "CtrlP tmux command interactively
            nnoremap  <silent><Leader>ui :CtrlPTmux ci<cr>
        endif
        let g:tmux_navigator_no_mappings = 1
        function! s:tmux_setting()
            if !te#env#IsDisplay() || !te#env#SupportFeature('clipboard')
                vnoremap  <silent><C-C> y:call te#tmux#reg2tmux()<cr>
                inoremap  <silent><c-v>	<C-o>:call te#tmux#tmux2reg()<cr><C-o>p
            endif
            call te#meta#map('nnoremap <silent> ','l',':TmuxNavigateRight<cr>')
            call te#meta#map('nnoremap <silent> ','h',':TmuxNavigateLeft<cr>')
            call te#meta#map('nnoremap <silent> ','j',':TmuxNavigateDown<cr>')
            call te#meta#map('nnoremap <silent> ','k',':TmuxNavigateUp<cr>')
            call te#meta#map('nnoremap <silent> ','w',':TmuxNavigatePrevious<cr>')
            "rename windows
            nnoremap <Leader>uw :call te#tmux#rename_win('')<cr>
        endfunction
        call te#feat#register_vim_enter_setting2([function('<SID>tmux_setting')], ['vim-tmux-navigator'])
    endif
endif
