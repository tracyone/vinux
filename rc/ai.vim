let s:ai_plugin_name = te#feat#get_key_value('g:ai_plugin_name', 'cur_val')
let s:ai_plugin_setupt_func = []
let s:ai_plugins = []

let s:llm_url_mapping = {
            \  'ernie-speed-128k': "https://qianfan.baidubce.com/v2/chat/completions",
            \  'deepseek-r1-distill-llama-8b': "https://qianfan.baidubce.com/v2/chat/completions",
            \  'qwq-32b': "https://qianfan.baidubce.com/v2/chat/completions",
            \ }

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
    else
        if te#env#SupportPy3()
            "require python 3.10 or newer
            "pip3 install numpy cffi unwrap
            "store your api-key to ~/.config/openai.token
            Plug 'madox2/vim-ai', {'on': []}

            function! s:vim_ai_chat_buffer_mapping() abort
                inoremap <silent><buffer> <C-s> <C-o>:AIChat<CR>
                inoremap <silent><buffer> <C-c> <C-o>:q<CR>
                nnoremap <silent><buffer> q :q<cr>
            endfunction

            function! s:ai_translater()
                let l:range = 0
                let l:prompt = "Translate following sentence to Chinese without any comment:\n\n"
                " Save the current register and selection type
                let l:save_reg = @"
                let l:save_regtype = getregtype('"')
                " Get the visually selected text
                normal! gv"zy
                let l:prompt .= @z

                let l:config = {
                            \  "engine": "chat",
                            \  "options": {
                            \    "max_tokens": 0,
                            \    "max_completion_tokens": 0,
                            \    "model": te#feat#get_key_value('g:ai_llm_model_name', 'cur_val'),
                            \    "endpoint_url": s:llm_url_mapping[te#feat#get_key_value('g:ai_llm_model_name', 'cur_val')],
                            \    "temperature": 1,
                            \    "request_timeout": 20,
                            \    "stream": 1,
                            \    "enable_auth": 1,
                            \    "token_file_path": "",
                            \    "selection_boundary": "",
                            \    "initial_prompt": ">>> system\nYou are a AI Translation assistant.",
                            \  "ui": {
                            \    "populate_options": 0,
                            \    "scratch_buffer_keep_open": 0,
                            \    "paste_mode": 1,
                            \  },
                            \  },
                            \}
                call vim_ai#AIChatRun(l:range, l:config, l:prompt)
            endfunction
            function! s:generate_git_commit_message()
                let l:range = 0
                let l:diff = system('git diff --staged')
                let l:prompt = "Write commit message (English) with commitizen convention without any comment. Keep the title under 50 characters and wrap message at 72 characters. Folllowing is the diff:\n\n" . l:diff
                let l:config = {
                            \  "engine": "chat",
                            \  "options": {
                            \    "max_tokens": 0,
                            \    "max_completion_tokens": 0,
                            \    "model": te#feat#get_key_value('g:ai_llm_model_name', 'cur_val'),
                            \    "endpoint_url": s:llm_url_mapping[te#feat#get_key_value('g:ai_llm_model_name', 'cur_val')],
                            \    "temperature": 1,
                            \    "request_timeout": 20,
                            \    "stream": 1,
                            \    "enable_auth": 1,
                            \    "token_file_path": "",
                            \    "selection_boundary": "",
                            \    "initial_prompt": ">>> system\nyou are a code assistant",
                            \  "ui": {
                            \    "paste_mode": 1,
                            \    "scratch_buffer_keep_open": 0,
                            \  },
                            \  },
                            \}
                call vim_ai#AIRun(l:range, l:config, l:prompt)
            endfunction

            function! s:ai_setup() abort
                let s:initial_chat_prompt =<< trim END
                    >>> system

                    You are a general assistant.
                    If you attach a code block add syntax type after ``` to enable syntax highlighting.
                END

                let g:vim_ai_chat = {
                            \  "options": {
                            \    "max_tokens": 0,
                            \    "max_completion_tokens": 0,
                            \    "model": te#feat#get_key_value('g:ai_llm_model_name', 'cur_val'),
                            \    "endpoint_url": s:llm_url_mapping[te#feat#get_key_value('g:ai_llm_model_name', 'cur_val')],
                            \    "temperature": 1,
                            \    "request_timeout": 20,
                            \    "stream": 1,
                            \    "enable_auth": 1,
                            \    "token_file_path": "",
                            \    "selection_boundary": "",
                            \    "initial_prompt": s:initial_chat_prompt,
                            \  },
                            \  "ui": {
                            \    "code_syntax_enabled": 1,
                            \    "populate_options": 0,
                            \    "open_chat_command": "preset_below",
                            \    "scratch_buffer_keep_open": 0,
                            \    "paste_mode": 1,
                            \  },
                            \}
                xnoremap <silent> <leader>au :call <SID>ai_translater()<CR>
                nmap <leader>ai :AIChat<CR>
                autocmd filetype_group FileType aichat call <SID>vim_ai_chat_buffer_mapping()
                autocmd filetype_group FileType gitcommit nnoremap <leader>cm :call <SID>generate_git_commit_message()<cr>
            endfunction


            call add(s:ai_plugin_setupt_func, function('<SID>ai_setup'))
            call add(s:ai_plugins, "vim-ai")
        endif
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

