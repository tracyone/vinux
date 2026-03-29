
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
    inoremap <silent><buffer> <C-j> <C-o>:AIChat<CR>
    inoremap <silent><buffer> <C-k> <C-o>:AIStopChat<cr>

    inoremap <silent><buffer> <C-i> <C-o>:call <SID>ai_include_file()<CR>
    nnoremap <silent><buffer> <C-i> <C-o>:call <SID>ai_include_file()<CR>

    nnoremap <silent><buffer> q :call <SID>save_chat_file()<CR>
    nnoremap <silent><buffer> <C-c> :call <SID>save_chat_file()<CR>
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
                \    "initial_prompt": ">>> system\nYou are a AI Translation assistant.",
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
                \    "initial_prompt": ">>> system\nyou are a code assistant",
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
                \    "model": te#ai#get_model_name(),
                \    "endpoint_url": te#ai#get_provider_url(te#feat#get_key_value('g:ai_provider_name', 'cur_val')).'chat/completions',
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
                \    "endpoint_url": te#ai#get_provider_url(te#feat#get_key_value('g:ai_provider_name', 'cur_val')).'chat/completions',
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
    nnoremap <leader>ai :AIChat<CR>:startinsert<cr>
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
