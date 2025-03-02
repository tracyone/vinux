let s:ai_plugin_name = te#feat#get_cur_val('g:ai_plugin_name')
let s:ai_plugin_setupt_func = [""]

if s:ai_plugin_name ==# 'copilot.vim'
    if g:complete_plugin_type.cur_val ==  'coc.nvim'
        Plug 'github/copilot.vim', {'on': [], 'do': ':CocInstall @hexuhua/coc-copilot'}
    else
        Plug 'github/copilot.vim', {'on': []}
    endif
    "<M-Right>               Accept the next word of the current suggestion.
    "<C-]>                   Dismiss the current suggestion
    "<M-]>                   Cycle to the next suggestion, if one is available.
    "<M-[>                   Cycle to the previous suggestion.
    function! s:copilot_setup() abort
        imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")
        let g:copilot_no_tab_map = v:true
        call te#meta#map('inoremap', ']', '<Plug>(copilot-next)')
        call te#meta#map('inoremap', '[', '<Plug>(copilot-previous)')
    endfunction
    let s:ai_plugin_setupt_func = [function('<SID>copilot_setup')]
endif


call te#feat#register_vim_enter_setting2(s:ai_plugin_setupt_func, [s:ai_plugin_name])

