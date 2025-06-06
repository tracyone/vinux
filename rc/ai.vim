let s:ai_plugin_name = te#feat#get_key_value('g:ai_plugin_name', 'cur_val')
let s:ai_plugin_setupt_func = []
let s:ai_plugins = []

let s:provider_url_mapping = {
            \  'baidu': "https://qianfan.baidubce.com/v2/chat/completions",
            \  'aliyun': "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
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

if te#env#IsNvim() > 0 && s:ai_plugin_name ==# 'copilot.vim'
    Plug 'CopilotC-Nvim/CopilotChat.nvim', {'on': [], 'do':'make tiktoken'}
    call add(s:ai_plugins, "CopilotChat.nvim")
    call add(s:ai_plugin_setupt_func, 'call te#feat#load_lua_modlue("copilot_chat_setup")')
    nnoremap <silent> <leader>ct :CopilotChat<CR>
    vnoremap <silent> <leader>ct :CopilotChat<CR>

    nnoremap <silent> <Leader>ce :CopilotChatExplain<CR>
    vnoremap <silent> <Leader>ce :CopilotChatExplain<CR>

    nnoremap <silent> <Leader>co :CopilotChatOptimize<CR>
    vnoremap <silent> <Leader>co :CopilotChatOptimize<CR>

    nnoremap <silent> <Leader>cr :CopilotChatReview<CR>
    vnoremap <silent> <Leader>cr :CopilotChatReview<CR>

    nnoremap <silent> <Leader>cg :CopilotChatTests<CR>
    vnoremap <silent> <Leader>cg :CopilotChatTests<CR>
endif

if te#env#SupportPy3()
    "require python 3.10 or newer
    "pip3 install numpy cffi unwrap
    "store your api-key to ~/.config/openai.token
    Plug 'madox2/vim-ai', {'on': []}


    function! s:save_chat_file() abort
        try
            " Get content and clean
            let content = join(getline(2, '$'), '')
            let cleaned = substitute(content, '^[\p{Zs}\t]*', '', '')

            " Generate filename components
            let filename_part = !empty(cleaned) ? 
                        \ strcharpart(cleaned, 0, 10) : 'untitled'

            " Set up paths
            let dir_path = $VIMFILES.'/.aichat'
            if !isdirectory(dir_path)
                call mkdir(dir_path, 'p')
            endif
            let file_path = dir_path.'/'.filename_part.'.aichat'

            " Attempt to write file
            execute 'write! '.fnameescape(file_path)

            call te#utils#EchoWarning('Chat saved to: '.file_path)

            " Close buffer
            :bdelete

        catch /E/
            " Error handling
            call te#utils#EchoWarning('Save failed: '.v:exception)
        endtry
    endfunction

    function! s:vim_ai_chat_buffer_mapping() abort
        inoremap <silent><buffer> <C-s> <C-o>:AIChat<CR>
        inoremap <silent><buffer> <C-c> <C-o>:call <SID>save_chat_file()<CR>
        nnoremap <silent><buffer> <C-c> :call <SID>save_chat_file()<CR>
        nnoremap <silent><buffer> q :call <SID>save_chat_file()<CR>
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
                    \  "options": {
                    \    "max_tokens": 0,
                    \    "max_completion_tokens": 0,
                    \    "model": te#feat#get_key_value('g:ai_llm_model_name', 'cur_val'),
                    \    "endpoint_url": s:provider_url_mapping[te#feat#get_key_value('g:ai_provider_name', 'cur_val')],
                    \    "temperature": 0.1,
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
                    \  "options": {
                    \    "max_tokens": 0,
                    \    "max_completion_tokens": 0,
                    \    "model": te#feat#get_key_value('g:ai_llm_model_name', 'cur_val'),
                    \    "endpoint_url": s:provider_url_mapping[te#feat#get_key_value('g:ai_provider_name', 'cur_val')],
                    \    "temperature": 0.1,
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
        call vim_ai#AIEditRun(l:range, l:config, l:prompt)
    endfunction

    function! s:ai_setup() abort
        let s:initial_chat_prompt =<< trim END
            >>> system

            You are a general assistant.
            If you attach a code block add syntax type after ``` to enable syntax highlighting.
        END

        call mkdir($VIMFILES.'/.aichat/', 'p')

        let g:vim_ai_token_file_path = '~/.config/'.te#feat#get_key_value('g:ai_provider_name', 'cur_val').'.token'
        let g:vim_ai_chat = {
                    \  "options": {
                    \    "max_tokens": 0,
                    \    "max_completion_tokens": 0,
                    \    "model": te#feat#get_key_value('g:ai_llm_model_name', 'cur_val'),
                    \    "endpoint_url": s:provider_url_mapping[te#feat#get_key_value('g:ai_provider_name', 'cur_val')],
                    \    "temperature": 0.1,
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


        let s:initial_complete_prompt =<< trim END
            >>> system

            You are a general assistant.
            Answer shortly, consisely and only what you are asked.
            Do not provide any explanantion or comments if not requested.
            If you answer in a code, do not wrap it in markdown code block.
        END

        let g:vim_ai_edit = {
                    \  "options": {
                    \    "max_tokens": 0,
                    \    "max_completion_tokens": 0,
                    \    "model": te#feat#get_key_value('g:ai_llm_model_name', 'cur_val'),
                    \    "endpoint_url": s:provider_url_mapping[te#feat#get_key_value('g:ai_provider_name', 'cur_val')],
                    \    "temperature": 0.1,
                    \    "request_timeout": 20,
                    \    "stream": 1,
                    \    "enable_auth": 1,
                    \    "token_file_path": "",
                    \    "selection_boundary": "#####",
                    \    "initial_prompt": s:initial_complete_prompt,
                    \  },
                    \  "ui": {
                    \    "paste_mode": 1,
                    \  },
                    \}
        xnoremap <silent> <leader>au :call <SID>ai_translater()<CR>
        nmap <leader>ai :AIChat<CR>
        xnoremap <leader>ai :AIEdit 
        if te#feat#get_key_value('g:fuzzysearcher_plugin_name', 'cur_val') ==# 'fzf'
            nnoremap <leader>ah :execute "Files ".$VIMFILES."/.aichat/"<CR>
        else
            nnoremap <leader>ah :execute "CtrlP ".$VIMFILES."/.aichat/"<CR>
        endif
        autocmd filetype_group FileType aichat call <SID>vim_ai_chat_buffer_mapping()
        autocmd filetype_group FileType gitcommit nnoremap <buffer><leader>cm :call <SID>generate_git_commit_message()<cr>

        if te#env#IsNvim() == 0
            " Code Explanation (e.g. CCExplain)
            command! -range=% Explain :<line1>,<line2>AIChat "Explain how the following code works.："
            " Code Refactoring (e.g.: CCRefactor)
            command! -range=% Refactor :<line1>,<line2>AIChat "Refactor this code while maintaining existing functionality?："
            " generate unit tests (e.g.: CCGenerateTest)
            command! -range=% GenerateTest :<line1>,<line2>AIChat "Generate unit tests for the following code?："
            " Code Optimization (e.g.: CCOptimize)
            command! -range=% Optimize :<line1>,<line2>AIChat "Please optimize this code and provide modification suggestions.："
            nnoremap <silent> <Leader>ce :Explain<CR>
            vnoremap <silent> <Leader>ce :Explain<CR>

            nnoremap <silent> <Leader>co :Optimize<CR>
            vnoremap <silent> <Leader>co :Optimize<CR>

            nnoremap <silent> <Leader>cr :Refactor<CR>
            vnoremap <silent> <Leader>cr :Refactor<CR>

            nnoremap <silent> <Leader>cg :GenerateTest<CR>
            vnoremap <silent> <Leader>cg :GenerateTest<CR>
        endif
    endfunction


    call add(s:ai_plugin_setupt_func, function('<SID>ai_setup'))
    call add(s:ai_plugins, "vim-ai")
endif

call te#feat#register_vim_enter_setting2(s:ai_plugin_setupt_func, s:ai_plugins)

