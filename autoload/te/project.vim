" project and session stuff

function! te#project#clang_format(A,L,P) abort
    let l:temp=a:A.a:L.a:P
    return ["LLVM", "GNU", "Google", "Chromium", "Microsoft", "Mozilla", "WebKit", "Linux"]
endfunction

"create a project
"1. session
"2. compile flag info
"3. coding style format
"4. cscope info
function! te#project#create_project() abort
    let l:file_to_open = []
    let l:name = input("Please input project name:", fnamemodify(getcwd(), ':t'))
    if !strlen(l:name)
        return
    endif

    let l:project_name=$VIMFILES.'/.project/'.l:name.'/'
    if isdirectory(l:project_name)
        call te#utils#EchoWarning(l:project_name.' is already exists!')
    else
        call mkdir(l:project_name, 'p')
        if !isdirectory(l:project_name)
            call te#utils#EchoWarning('Create '.l:projjct_name.' fail')
            return -1
        endif
    endif
    "session
    if exists(":SSave") == 2
        execute ":SSave ".l:name
    elseif exists(":SaveSession") == 2
        execute ":SaveSession ".l:name
    endif
    "complete flag
    if get(g:, 'feat_enable_complete')
        if g:complete_plugin_type.cur_val ==# 'YouCompleteMe'
            if filereadable('.ycm_extra_conf.py')
                let l:ret = te#file#copy_file('.ycm_extra_conf.py', l:project_name.'.ycm_extra_conf.py')
            else
                let l:ret = te#file#copy_file(g:ycm_global_ycm_extra_conf, l:project_name.'.ycm_extra_conf.py')
            endif
            call add(l:file_to_open, l:project_name.'.ycm_extra_conf.py')
        endif
    endif

    if get(g:, 'feat_enable_lsp')
        "bear --output compile_commands.json  -- make
        if filereadable('compile_commands.json')
            let l:ret = te#file#copy_file('compile_commands.json', l:project_name.'compile_commands.json')
            call add(l:file_to_open, l:project_name.'compile_commands.json')
        else
            call te#utils#EchoWarning("bear --output compile_commands.json  -- build command")
            if filereadable('compile_flags.txt')
                let l:ret = te#file#copy_file('compile_flags.txt', l:project_name.'compile_flags.txt')
            else
                call te#utils#EchoWarning("No compile_commands.json or compile_flags.txt found!")
            endif
            call add(l:file_to_open, l:project_name.'compile_flags.txt')
        endif
    endif
    "coding style select
    if te#env#Executable('clang-format')
        if !filereadable('.clang-format')
            let l:coding_style = input('Please select coding style template: ','','customlist,te#project#clang_format')
            if strlen(l:coding_style)
                if l:coding_style ==# 'Linux'
                    let l:ret = te#file#copy_file($VIMFILES.'/format/clang-format-linux', l:project_name.'.clang-format')
                else
                    call te#utils#run_command('clang-format -style='.l:coding_style.' -dump-config > .clang-format', function('te#file#copy_file'), ['.clang-format', l:project_name.'.clang-format'])
                endif
            endif
        else
            let l:ret = te#file#copy_file('.clang-format', l:project_name.'.clang-format')
        endif
        call add(l:file_to_open, l:project_name.'.clang-format')
    endif

    ".love.vim
    if exists(":Love") == 2
        execute ':Love 1'
    endif
    if filereadable('.love.vim')
        let l:ret = te#file#copy_file('.love.vim', l:project_name.'.love.vim')
    endif
    call add(l:file_to_open, l:project_name.'.love.vim')

    ".csdb
    if filereadable('.csdb')
        let l:ret = te#file#copy_file('.csdb', l:project_name)
    else
        call writefile([getcwd()], ".csdb", "a")
        let l:ret = te#file#copy_file('.csdb', l:project_name)
    endif
    call add(l:file_to_open, l:project_name.'.csdb')

    for l:file in l:file_to_open
        execute ':tabnew '.l:file
    endfor
    return 0
endfunction

function! te#project#load_project() abort
    "Let user choose exist project from
    let l:project_root=$VIMFILES.'/.project/'
    if !isdirectory(l:project_root)
        call te#utils#EchoWarning(l:project_root.' is not exists')
        return
    endif
    execute 'cd '.l:project_root
    let l:project = input('Please select project: ','','dir')
    if strlen(l:project)
        if isdirectory(l:project)
            "session
            let l:session_name = matchstr(l:project, '.*\(/\)\@=')
            if exists(":SLoad") == 2
                execute ":SLoad ".l:session_name
            elseif exists(":OpenSession") == 2
                execute ":OpenSession ".l:session_name
            endif
            let l:old_dir = getcwd()
            call te#file#copy_file(l:project_root.l:project.'.ycm_extra_conf.py', l:old_dir)
            call te#file#copy_file(l:project_root.l:project.'.clang-format', l:old_dir)
            call te#file#copy_file(l:project_root.l:project.'.love.vim', l:old_dir)
            call te#file#copy_file(l:project_root.l:project.'compile_commands.json', l:old_dir)
            call te#file#copy_file(l:project_root.l:project.'compile_flags.txt', l:old_dir)
            call love#Apply()
            call te#feat#source_rc('colors.vim')
            call te#utils#close_all_echo_win()
        else
            call te#utils#EchoWarning(l:project." is not a directory")
        endif
    endif
endfunction

function! te#project#delete_project() abort
    let l:project_root=$VIMFILES.'/.project/'
    if !isdirectory(l:project_root)
        call te#utils#EchoWarning(l:project_root.' is not exists')
        return
    endif
    execute 'cd '.l:project_root
    let l:project = input('Please select project: ','','dir')
    if strlen(l:project)
        if isdirectory(l:project)
            let l:ret = te#file#delete(l:project_root.l:project)
            let l:session_name = matchstr(l:project, '.*\(/\)\@=')
            call te#utils#EchoWarning("Delete session ". l:session_name)
            if exists(":SDelete") == 2
                execute ':SDelete! '.l:session_name
            elseif exists(":DeleteSession") == 2
                execute ':DeleteSession! '.l:session_name
            endif
        else
            let l:ret=-1
        endif
    else
            let l:ret=-1
    endif
    if !l:ret
        call te#utils#EchoWarning("Delete project:".l:project." successfully")
    else
        call te#utils#EchoWarning("Delete project:".l:project." fail")
    endif
endfunction
