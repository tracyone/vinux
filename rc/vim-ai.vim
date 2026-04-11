
function! s:ai_include_file() abort
    " Save cursor position
    let l:save_pos = getpos('.')

    let l:include_files = []
    let l:current_bufnr = bufnr('%')

    for l:buf in getbufinfo({'buflisted': 1})
        if l:buf.bufnr == l:current_bufnr
            continue
        endif

        if empty(l:buf.name)
            continue
        endif

        let l:buftype = getbufvar(l:buf.bufnr, '&buftype', '')
        if !empty(l:buftype) && l:buftype !=# ''
            continue
        endif

        let l:filetype = getbufvar(l:buf.bufnr, '&filetype', '')
        if l:filetype ==# 'aichat'
            continue
        endif

        if !filereadable(l:buf.name)
            continue
        endif

        call add(l:include_files, fnamemodify(l:buf.name, ':p'))
    endfor

    if empty(l:include_files)
        call te#utils#EchoWarning('No editable buffers found to include.')
        " Restore cursor position even on early return
        call setpos('.', l:save_pos)
        return
    endif

    normal! G

    call append('$', '')
    call append('$', '>>> include')

    for l:file_path in l:include_files
        call append('$', l:file_path)
    endfor

    " Restore cursor position
    call setpos('.', l:save_pos)
endfunction

function! s:save_chat_file() abort
    try
        stopinsert
        let content = join(getline(2, '$'), '')
        let cleaned = substitute(content, '^[\p{Zs}\t]*', '', '')

        " Generate filename components
        let filename_part = !empty(cleaned) ? 
                    \ strcharpart(cleaned, 0, 10) : 'untitled'

        " Check if project is loaded
        if exists('g:vinux_project') && has_key(g:vinux_project, 'name') && len(g:vinux_project.name)
            " Save to project directory with project name as filename
            let dir_path=$VIMFILES.'/.project/'.g:vinux_project.name.'/'
            let file_path = dir_path.'/'.g:vinux_project.name.'.aichat'
        else
            " No project loaded, save to default .aichat directory
            let dir_path = $VIMFILES.'/.aichat'
            if !isdirectory(dir_path)
                call mkdir(dir_path, 'p')
            endif
            let file_path = dir_path.'/'.filename_part.'.aichat'
        endif

        " Attempt to write file
        execute 'write! '.fnameescape(file_path)

        call te#utils#EchoWarning('Chat saved to: '.file_path)

        " Close buffer
        if winnr('$') > 1
            hide
        else
            :bnext
        endif
    catch /E/
        " Error handling
        call te#utils#EchoWarning('Save failed: '.v:exception)
    endtry
endfunction

function! s:vim_ai_chat_buffer_mapping() abort
    setlocal statusline=AI:[%{te#ai#get_provider_name()}/%{te#ai#get_model_name()}]\ %p%%[%l,%v]
    if get(g:, 'feat_enable_airline') == 1
        let g:airline_section_c.="AI:[%{te#ai#get_provider_name()}/%{te#ai#get_model_name()}]".g:airline_section_c_sep
    endif
    inoremap <silent><buffer> <C-j> <C-o>:AIChat<CR>
    inoremap <silent><buffer> <C-k> <C-o>:AIStopChat<cr>

    inoremap <silent><buffer> <C-i> <C-o>:call <SID>ai_include_file()<CR>
    nnoremap <silent><buffer> <C-i> <C-o>:call <SID>ai_include_file()<CR>

    nnoremap <silent><buffer> q :call <SID>save_chat_file()<CR>
    nnoremap <silent><buffer> <C-c> :call <SID>save_chat_file()<CR>
endfunction

function! s:ai_translater() abort
    let l:range = 0
    let l:text = ""
    let l:prompt = "Translate following selected text to Chinese without any comment:\n\n"
    let l:system_prompt=""

    if !empty(visualmode())
        let l:save_reg = @"
        let l:save_regtype = getregtype('"')
        normal! gv"zy
        let l:text = @z
        call setreg('"', l:save_reg, l:save_regtype)

        if empty(l:text)
            call te#utils#EchoWarning('No text selected to translate.')
            return
        endif

        let l:prompt .= l:text

    else
        let l:file_path = expand('%:p')
        
        if l:file_path ==# '' || !filereadable(l:file_path)
            call te#utils#EchoWarning('Cannot translate: Buffer is not a readable file.')
            return
        endif

        let l:system_prompt=">>> include\n".l:file_path

    endif

    let l:config = {
                \  "options": {
                \    "initial_prompt": ">>> system\nYou are a AI Translation assistant.\n".l:system_prompt
                \  },
                \}
    
    call vim_ai#AIChatRun(l:range, l:config, l:prompt)
endfunction

function! s:generate_git_commit_message()
    let l:range = 0
    let l:diff = system('git diff --staged')
    if empty(l:diff)
        let l:diff = system('git diff HEAD~1 HEAD')
    endif
    let l:prompt = "Write commit message (English) with commitizen convention without any comment. Keep the title under 50 characters and wrap message at 72 characters do not wrap it in markdown code block. Folllowing is the diff:\n\n" . l:diff
    let l:config = {
                \  "options": {
                \    "initial_prompt": ">>> system\nyou are a code assistant",
                \  },
                \}
    call vim_ai#AIEditRun(l:range, l:config, l:prompt)
endfunction

" Open project aichat file or create new AI chat
function! s:open_ai_chat() abort
    " Check if project is loaded and has a name
    if exists('g:vinux_project') && has_key(g:vinux_project, 'name') && len(g:vinux_project.name)
        let l:project_name=$VIMFILES.'/.project/'.g:vinux_project.name.'/'
        let l:aichat_filename = g:vinux_project.name.'.aichat'
        let l:project_aichat_path = l:project_name.'/'.l:aichat_filename
        
        " Check if project aichat file exists in project directory
        if filereadable(l:project_aichat_path)
            execute 'edit '.fnameescape(l:project_aichat_path)
            setlocal filetype=aichat
            normal! G
            startinsert!
            return
        endif
        
        " Check if project aichat file exists in .project directory
        let l:project_root = $VIMFILES.'/.project/'.g:vinux_project.name.'/'
        let l:stored_aichat_path = l:project_root.l:aichat_filename
        if filereadable(l:stored_aichat_path)
            " Copy to project directory and open
            call te#file#copy_file(l:stored_aichat_path, g:vinux_project.dir, 0)
            execute 'edit '.fnameescape(l:project_aichat_path)
            setlocal filetype=aichat
            normal! G
            startinsert!
            return
        endif
    endif
    
    " No project loaded or no aichat file found, create new AI chat
    :AIChat
    :startinsert
endfunction

function! s:ai_setup() abort
    let s:initial_chat_prompt =<< trim END
        >>> system

        You are a general assistant.
        If you attach a code block add syntax type after ``` to enable syntax highlighting.
    END
    let g:vim_ai_token_file_path = '~/.config/'.te#feat#get_key_value('g:ai_provider_name', 'cur_val').'.token'

    if !filereadable(g:vim_ai_token_file_path)
        if (writefile(["YOUR_API_KEY"], fnamemodify(g:vim_ai_token_file_path, ':p')))
            call te#utils#EchoWarning("Write file fail")
    endif

    if te#ai#get_provider_name() =~# 'llama\|ollama'
        let l:provider_url = te#ai#get_provider_url().'/v1/chat/completions'
    else
        let l:provider_url = te#ai#get_provider_url().'chat/completions'
    endif

    call mkdir($VIMFILES.'/.aichat/', 'p')

    let g:vim_ai_chat = {
                \  "options": {
                \    "max_tokens": 0,
                \    "max_completion_tokens": 0,
                \    "model": te#ai#get_model_name(),
                \    "endpoint_url": l:provider_url,
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
                \    "scratch_buffer_keep_open": 1,
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
                \    "model": te#ai#get_model_name(),
                \    "endpoint_url": l:provider_url,
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
    nnoremap <silent> <leader>au :call <SID>ai_translater()<CR>
    nnoremap <leader>ai :call <SID>open_ai_chat()<CR>
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

call te#feat#register_vim_enter_setting2([function('<SID>ai_setup')], ['vim-ai'])
