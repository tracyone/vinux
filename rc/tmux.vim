if(!te#env#IsWindows())
    if te#env#IsTmux()
        function! s:rename_tmux_win()
            let l:name=input("Input the name of current windows: ")
            call te#utils#run_command('tmux rename-window '.l:name)
        endfunction
        Plug 'christoomey/vim-tmux-navigator'
        if get(g:, 'fuzzysearcher_plugin_name') ==# 'ctrlp'
            Plug 'lucidstack/ctrlp-tmux.vim',{'on': 'CtrlPTmux'}
            "CtrlP tmux window
            nnoremap <Leader>uu :CtrlPTmux w<cr>
            "CtrlP tmux buffer
            nnoremap <Leader>uf :CtrlPTmux b<cr>
            "CtrlP tmux session
            nnoremap <Leader>um :CtrlPTmux<cr>
            "CtrlP tmux command
            nnoremap <Leader>uc :CtrlPTmux c<cr>
            "CtrlP tmux command interactively
            nnoremap <Leader>ui :CtrlPTmux ci<cr>
        endif
        Plug 'jebaum/vim-tmuxify'
        if !te#env#IsDisplay() || !te#env#SupportFeature('clipboard')
            Plug 'kurtenbachkyle/vim-tmux-buffet',{'on': ['TmuxBuffetRegisterToTmux', 'TmuxBuffetCopyToUnnamed']}
            vnoremap <C-C> y:TmuxBuffetRegisterToTmux<cr>
            inoremap <c-v>	<C-o>:TmuxBuffetCopyToUnnamed<cr><C-o>p
        endif
        let g:tmux_navigator_no_mappings = 1
        call te#meta#map('nnoremap <silent>','l',':TmuxNavigateRight<cr>')
        call te#meta#map('nnoremap <silent>','h',':TmuxNavigateLeft<cr>')
        call te#meta#map('nnoremap <silent>','j',':TmuxNavigateDown<cr>')
        call te#meta#map('nnoremap <silent>','k',':TmuxNavigateUp<cr>')
        call te#meta#map('nnoremap <silent>','w',':TmuxNavigatePrevious<cr>')
        "rename windows
        nnoremap <Leader>uw :call <SID>rename_tmux_win()<cr>
        let g:tmuxify_custom_command = 'tmux split-window -p 38'
        let g:tmuxify_map_prefix = '<leader>u'
    endif
endif
