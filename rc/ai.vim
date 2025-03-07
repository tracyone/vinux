let s:ai_plugin_name = te#feat#get_key_value('g:ai_plugin_name', 'cur_val')
let s:ai_plugin_setupt_func = []
let s:ai_plugins = []

if s:ai_plugin_name ==# 'copilot.vim'
    if te#feat#get_key_value('g:complete_plugin_type', 'cur_val') ==  'coc.nvim'
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
        imap <c-l> <Plug>(copilot-accept-line)
        imap <c-]> <Plug>(copilot-accept-word)
    endfunction
    call add(s:ai_plugin_setupt_func, function('<SID>copilot_setup'))
    call add(s:ai_plugins, s:ai_plugin_name)
    if te#env#IsNvim() > 0
        Plug 'CopilotC-Nvim/CopilotChat.nvim', {'on': [], 'do':'make tiktoken'}
        call add(s:ai_plugins, "CopilotChat.nvim")
        call add(s:ai_plugin_setupt_func, 'call te#feat#load_lua_modlue("copilot_chat_setup")')
        nnoremap <silent> <leader>ai :CopilotChat<CR>
        vnoremap <silent> <leader>ai :CopilotChat<CR>
        vnoremap <silent> <leader>au :CopilotChat Translate to Chinese or English according to the detection<CR>
    endif
endif

if s:ai_plugin_name ==# 'codeium.vim'
    Plug 'Exafunction/codeium.vim', {'on': []}

    function! s:codeium_setup() abort
        let g:codeium_disable_bindings = 1
        let g:codeium_enabled = v:true
        imap <script><silent><nowait><expr> <C-a> codeium#Accept()
        imap <script><silent><nowait><expr> <C-]> codeium#AcceptNextWord()
        imap <script><silent><nowait><expr> <C-l> codeium#AcceptNextLine()
        call te#meta#map('inoremap', ']', '<Cmd>call codeium#CycleCompletions(1)<CR>')
        call te#meta#map('inoremap', '[', '<Cmd>call codeium#CycleCompletions(-1)<CR>')
        nnoremap <silent> <leader>ai :Codeium Chat<CR>
    endfunction

    call add(s:ai_plugin_setupt_func, function('<SID>codeium_setup'))
    call add(s:ai_plugins, s:ai_plugin_name)
endif

call te#feat#register_vim_enter_setting2(s:ai_plugin_setupt_func, s:ai_plugins)

