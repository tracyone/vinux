if(!te#env#IsWindows())
    if te#env#IsTmux()
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'lucidstack/ctrlp-tmux.vim',{'on': 'CtrlPTmux'}
        Plug 'jebaum/vim-tmuxify'
        Plug 'wellle/tmux-complete.vim'
        let g:tmux_navigator_no_mappings = 1
        call te#meta#map('nnoremap <silent>','l',':TmuxNavigateRight<cr>')
        call te#meta#map('nnoremap <silent>','h',':TmuxNavigateLeft<cr>')
        call te#meta#map('nnoremap <silent>','j',':TmuxNavigateDown<cr>')
        call te#meta#map('nnoremap <silent>','k',':TmuxNavigateUp<cr>')
        call te#meta#map('nnoremap <silent>','w',':TmuxNavigatePrevious<cr>')
        "CtrlP tmux window
        nnoremap <Leader>uu :CtrlPTmux w<cr>
        "CtrlP tmux buffer
        nnoremap <Leader>uf :CtrlPTmux b<cr>
        "CtrlP tmux session
        nnoremap <Leader>um :CtrlPTmux<cr>
        "CtrlP tmux command
        nnoremap <Leader>ud :CtrlPTmux c<cr>
        "CtrlP tmux command interactively
        nnoremap <Leader>ui :CtrlPTmux ci<cr>
        "let g:tmuxify_custom_command = 'tmux split-window -p 20'
        let g:tmuxify_map_prefix = '<leader>u'
        if g:complete_plugin_type ==# 'ycm' 
            let g:tmuxcomplete#trigger = 'omnifunc'
        endif
    endif
endif
