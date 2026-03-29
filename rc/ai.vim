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
endif

if s:ai_plugin_name ==# 'windsurf.vim'
    Plug 'Exafunction/windsurf.vim', {'on': [], 'branch': 'main' }

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
endif

if s:ai_plugin_name ==# 'copilot.vim'
    if te#env#IsNvim() > 0
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
    else
        Plug 'DanBradbury/copilot-chat.vim', {'on': []}
        call add(s:ai_plugins, "copilot-chat.vim")
        let g:copilot_chat_open_on_toggle=0
        let g:copilot_chat_disable_mappings = 1
        let g:copilot_chat_data_dir=$VIMFILES.'/.aichat/'
        nnoremap <silent> <leader>ct :CopilotChatOpen<CR>
        vnoremap <silent> <leader>ct <Plug>CopilotChatAddSelection
        function! s:copilot_chat_save_quit() abort
            let l:file_name=input("Please input a new filename: ", "")
            if !empty(l:file_name)
                execute 'CopilotChatSave '.l:file_name
            endif
            :q
        endfunction
        function! s:copilot_buffer_mapping() abort
            inoremap <silent><buffer> <C-j> <C-o>:CopilotChatSubmit<CR>
            inoremap <silent><buffer> q <C-o>:call te#utils#confirm('Save chat ?', ['Yes', 'No'], ["call <SID>copilot_chat_save_quit()", ":q"])<CR>
            nnoremap <silent><buffer> q <C-o>:call te#utils#confirm('Save chat ?', ['Yes', 'No'], ["call <SID>copilot_chat_save_quit()", ":q"])<CR>
        endfunction
        autocmd filetype_group FileType copilot_chat call <SID>copilot_buffer_mapping()
    endif
endif

if te#env#SupportPy3()
    "require python 3.10 or newer
    "pip3 install numpy cffi unwrap
    "store your api-key to ~/.config/openai.token
    Plug 'madox2/vim-ai', {'on': []}

    execute 'source '.$VIMFILES.'/rc/vim-ai.vim'
endif

if s:ai_plugin_name ==# 'vim-ollama'
    Plug 'gergap/vim-ollama'
endif

if s:ai_plugin_name ==# 'vim-llm-agent' 
    function! s:vim_llm_agent_setup() abort
        let $OPENAI_API_KEY=te#ai#get_api_key()
        let $OPENAI_API_BASE=te#ai#get_provider_url(te#feat#get_key_value('g:ai_provider_name', 'cur_val'))
        let g:llm_agent_provider = 'openai'
        let g:openai_api_key=te#ai#get_api_key()
        let g:openai_base_url=te#ai#get_provider_url(te#feat#get_key_value('g:ai_provider_name', 'cur_val'))
        let g:llm_agent_model=te#ai#get_model_name()
        let g:llm_agent_max_tokens=2000
        let g:llm_agent_session_mode=1
        let g:llm_agent_temperature = 0.7
        let g:llm_agent_lang = 'Chinese'
        let g:llm_agent_split_direction = 'vertical'
        let g:split_ratio=4
        let g:llm_agent_enable_tools=1
        let g:chat_persona='default'
        let g:llm_agent_log_level=2  " 0=off, 1=basic, 2=verbos
    endfunction
    Plug 'CoderCookE/vim-llm-agent', {'on': []}
    call add(s:ai_plugin_setupt_func, function('<SID>vim_llm_agent_setup'))
endif

call add(s:ai_plugins, s:ai_plugin_name)


call te#feat#register_vim_enter_setting2(s:ai_plugin_setupt_func, s:ai_plugins)

