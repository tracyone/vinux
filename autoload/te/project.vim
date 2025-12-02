" project and session stuff

function! te#project#clang_format(A,L,P) abort
    let l:temp=a:A.a:L.a:P
    return ["llvm", "gnu", "google", "chromium", "microsoft", "mozilla", "webkit", "linux"]
endfunction

function! te#project#set_indent_options(coding_style)
    let g:vinux_coding_style.cur_val = a:coding_style
    set textwidth=160
    if a:coding_style ==# 'linux'
        let g:vinux_tabwidth=8
        set textwidth=80
        set noexpandtab
        set nosmarttab
    elseif a:coding_style ==# 'mozilla'
        let g:vinux_tabwidth=4
    elseif a:coding_style ==# 'google'
        let g:vinux_tabwidth=2
    elseif a:coding_style ==# 'llvm'
        let g:vinux_tabwidth=4
    elseif a:coding_style ==# 'chromium'
        let g:vinux_tabwidth=2
    else
        let g:vinux_tabwidth=4
    endif
    execute 'silent! set tabstop='.g:vinux_tabwidth
    execute 'silent! set shiftwidth='.g:vinux_tabwidth
    if &expandtab == 1
        execute 'silent! set softtabstop='.g:vinux_tabwidth
    else
        set softtabstop=0
    endif
    execute 'set colorcolumn='.(&textwidth + 1)
endfunction

"create a project
"1. session
"2. compile flag info
"3. coding style format
"4. cscope info
"g:vinux_project.dir: root directory of project:
"g:vinux_project.name: name of project
"g:vinux_project.type type of project, 1 for project, 2 for session
"g:vinux_project.cmd build cmd for project
function! te#project#create_project() abort
    let l:project_exist = 0
    let l:default_name=fnamemodify(getcwd(), ':t')
    let g:vinux_project=get(g:, 'vinux_project', {'dir':'', 'name':'', 'type':0})
    if len(g:vinux_project.name)
        let l:default_name=g:vinux_project.name
        let l:project_exist = 1
        let l:name = input("Rename or save current project:", l:default_name)
    else
        let l:name = input("Please input the new project name:", l:default_name)
    endif
    if !strlen(l:name)
        return
    endif
    if !isdirectory($VIMFILES.'/sessions')
        call mkdir($VIMFILES.'/sessions', 'p')
    endif

    "close unlisted buffer
    for l:b in te#utils#get_buf_info(2)
        execute ':bdelete '.l:b
    endfor
    let l:project_name=$VIMFILES.'/.project/'.l:name.'/'
    if l:project_exist == 1 
        if l:name != g:vinux_project.name
            "Delete session then renmae .project/
            if exists(":SDelete") == 2
                execute ':SDelete! '.g:vinux_project.name
            elseif exists(":DeleteSession") == 2
                execute ':DeleteSession! '.g:vinux_project.name
            endif
            if g:vinux_project.type == 1
                call rename($VIMFILES.'/.project/'.g:vinux_project.name.'/', l:project_name)
            endif
        endif
        if g:vinux_project.type == 2
            let g:vinux_project.name = l:name
            let g:vinux_project.dir = getcwd()
            execute ':SSave '.l:name
            return
        endif
        if g:vinux_project.dir != getcwd()
            "working directory is changed
            "clean original working directory files...
            call te#file#delete(g:vinux_project.dir.'/.ycm_extra_conf.py', 0)
            call te#file#delete(g:vinux_project.dir.'/.clang-format', 0)
            call te#file#delete(g:vinux_project.dir.'/.love.vim', 0)
            call te#file#delete(g:vinux_project.dir.'/compile_commands.json', 0)
            call te#file#delete(g:vinux_project.dir.'/compile_flags.txt', 0)
            call te#file#delete(g:vinux_project.dir.'/.csdb', 0)
            let g:vinux_project.dir = getcwd()
            call te#file#copy_file(l:project_name.'/.ycm_extra_conf.py', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_name.'/.clang-format', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_name.'/.love.vim', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_name.'/compile_commands.json', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_name.'/compile_flags.txt', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_name.'/.csdb', g:vinux_project.dir, 0)
        endif
    else
        let l:type=confirm("Create a project or session?[P/S]", "&Project\n&Session")
        let g:vinux_project.type = l:type
        if l:type == 2
            let g:vinux_project.name = l:name
            let g:vinux_project.dir = getcwd()
            execute ':SSave '.l:name
            call te#utils#EchoWarning("Create session ".l:name.' finish!')
            return
        endif
    endif

    if isdirectory(l:project_name)
        call te#utils#EchoWarning(l:project_name.' is already exists!')
    else
        call mkdir(l:project_name, 'p')
        if !isdirectory(l:project_name)
            call te#utils#EchoWarning('Create '.l:project_name.' fail')
            return -1
        endif
    endif
    "complete flag
    if get(g:, 'feat_enable_complete')
        if g:complete_plugin_type.cur_val ==# 'YouCompleteMe'
            if filereadable('.ycm_extra_conf.py')
                let l:ret = te#file#copy_file('.ycm_extra_conf.py', l:project_name.'.ycm_extra_conf.py', 0)
            else
                execute 'cd '.$VIMFILES.'/rc/ycm_conf/'
                let l:ycm_path = input('Please select ycm conf:','','file')
                let l:ret = te#file#copy_file(l:ycm_path, l:project_name.'.ycm_extra_conf.py')
                cd -
                let l:ret = te#file#copy_file(l:project_name.'.ycm_extra_conf.py', './.ycm_extra_conf.py')
            endif
        endif
    endif

    let g:vinux_project.cmd = input('Please input build command:', get(g:vinux_project, 'cmd', './build.sh && ./build.sh pack'))
    let g:vinux_project.build_root_dir = input('Please input root dir of build:', get(g:vinux_project, 'build_root_dir', getcwd()))

    if get(g:, 'feat_enable_lsp')
        "bear --output compile_commands.json  -- make
        if filereadable('compile_commands.json')
            let l:ret = te#file#copy_file('compile_commands.json', l:project_name.'compile_commands.json', 0)
        else
            call te#utils#EchoWarning("bear --output compile_commands.json  -- build command")
            if filereadable('compile_flags.txt')
                let l:ret = te#file#copy_file('compile_flags.txt', l:project_name.'compile_flags.txt', 0)
            else
                call te#utils#EchoWarning("No compile_commands.json or compile_flags.txt found!")
            endif
        endif
    endif
    "coding style select
    if te#env#Executable('clang-format')
        if !filereadable('.clang-format')
            let l:coding_style = input('Please select coding style template: ','','customlist,te#project#clang_format')
            if strlen(l:coding_style)
                if l:coding_style ==# 'linux'
                    call te#file#copy_file($VIMFILES.'/format/clang-format-linux', l:project_name.'.clang-format')
                    call te#file#copy_file($VIMFILES.'/format/clang-format-linux', '.clang-format')
                else
                    let l:clang_fomat_cmd = 'clang-format -style="{BasedOnStyle: '.l:coding_style
                    let l:result = te#utils#confirm("Use Tab?", ['Always', 'false'],'')
                    let l:clang_fomat_cmd .= ', UseTab: '.l:result
                    let &expandtab = (l:result !=# 'Always')
                    let &smarttab = (l:result !=# 'Always')
                    let l:result = input("Input the width of indent: ", 4)
                    let l:clang_fomat_cmd .= ', IndentWidth: '.l:result
                    let l:clang_fomat_cmd .= ', TabWidth: '.l:result
                    let l:clang_fomat_cmd .= ', ConstructorInitializerIndentWidth: '.l:result
                    let l:clang_fomat_cmd .= ', ContinuationIndentWidth: '.l:result
                    let l:clang_fomat_cmd .= '}" -dump-config > .clang-format'
                    call te#utils#run_command(l:clang_fomat_cmd, function('te#file#copy_file'), ['.clang-format', l:project_name.'.clang-format'])
                endif
                call te#project#set_indent_options(l:coding_style)
            endif
        else
            let l:ret = te#file#copy_file('.clang-format', l:project_name.'.clang-format', 0)
        endif
    endif

    ".love.vim
    if exists(":Love") == 2
        silent! execute ':Love 1'
    endif
    if filereadable('.love.vim')
        call writefile(['let g:vinux_coding_style.cur_val='.string(g:vinux_coding_style.cur_val)], ".love.vim", "a")
        call writefile(['set backupdir='.l:project_name], ".love.vim", "a")
        let l:ret = te#file#copy_file('.love.vim', l:project_name.'.love.vim', 0)
    endif

    ".csdb
    if filereadable('.csdb')
        let l:ret = te#file#copy_file('.csdb', l:project_name, 0)
    else
        call writefile([getcwd()], ".csdb", "a")
        let l:ret = te#file#copy_file('.csdb', l:project_name)
    endif
    "session
    let g:vinux_project.name = l:name
    let g:vinux_project.dir = getcwd()
    if exists(":SSave") == 2
        execute ":SSave ".l:name
    elseif exists(":SaveSession") == 2
        execute ":SaveSession ".l:name
    endif
    if te#env#IsTmux()
        :call te#tmux#rename_win(l:name)
    endif
    call te#pg#start_gen_cs_tags_threads()
    call te#terminal#shell_pop({'opener':0x2, 'title': "build"})
    call te#terminal#hide_popup()
    return 0
endfunction

"edit project file and update 
function! te#project#edit_project() abort
    let l:project_root=$VIMFILES.'/.project/'
    let l:old_pwd = getcwd()
    if isdirectory(l:project_root)
        execute 'cd '.l:project_root
    else
        call te#utils#EchoWarning(l:project_root." is not exist")
        return
    endif
    let l:project = input('Please select project: ','','dir')
    execute 'cd '.l:project_root.'/'.l:project
    let l:file_to_open=['.ycm_extra_conf.py', '.clang-format', '.love.vim', 'compile_commands.json', 'compile_flags.txt', '.csdb']
    for l:file in l:file_to_open
        if filereadable(l:file)
            execute ':tabnew '.l:file
        endif
    endfor
    execute 'cd '.l:old_pwd
endfunction

function! te#project#load_project(project_info) abort
    "Let user choose exist project from
    let l:project_root=$VIMFILES.'/.project/'
    if !isdirectory(l:project_root)
        call te#utils#EchoWarning(l:project_root.' is not exists')
        return
    endif
    if !len(a:project_info)
        execute 'cd '.l:project_root
        let l:project = input('Please select project: ','','dir')
        cd -
    else
        if a:project_info.type == 2
            return
        endif
        let l:project = a:project_info.name
    endif
    if strlen(l:project)
        if isdirectory(l:project_root.l:project)
            "session
            let g:copilot_workspace_folders = readfile(l:project_root.l:project.'/.csdb')
            if !len(a:project_info)
                let l:session_name = matchstr(l:project, '.*\(/\)\@=')
                if exists(":SLoad") == 2
                    execute ":SLoad ".l:session_name
                elseif exists(":OpenSession") == 2
                    execute ":OpenSession ".l:session_name
                endif
            endif
            call te#file#copy_file(l:project_root.l:project.'/.ycm_extra_conf.py', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_root.l:project.'/.clang-format', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_root.l:project.'/.love.vim', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_root.l:project.'/compile_commands.json', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_root.l:project.'/compile_flags.txt', g:vinux_project.dir, 0)
            call te#file#copy_file(l:project_root.l:project.'/.csdb', g:vinux_project.dir, 0)
            call love#Apply()
            call te#feat#source_rc('colors.vim')
            call te#utils#close_all_echo_win()
            call te#project#set_indent_options(g:vinux_coding_style.cur_val)
            call te#pg#start_gen_cs_tags_threads()
            if te#env#IsTmux()
                :call te#tmux#rename_win(a:project_info.name)
            endif
        else
            call te#utils#EchoWarning(l:project." is not a directory")
        endif
    endif
    call te#terminal#shell_pop({'opener':0x2, 'title': "build"})
    call te#terminal#hide_popup()
endfunction

function! te#project#delete_project() abort
    let l:sessions_root=$VIMFILES.'/sessions/'
    let l:project_root=$VIMFILES.'/.project/'
    if !isdirectory(l:project_root)
        call te#utils#EchoWarning(l:project_root.' is not exists')
        return
    endif
    execute 'cd '.l:sessions_root
    let l:project_name = input('Please select project: ','','file')
    if strlen(l:project_name)
        if filereadable(l:project_name)
            execute 'cd '.l:project_root
            "read project  root directory
            let l:file_to_delete=['.ycm_extra_conf.py', '.clang-format', '.love.vim', 'compile_commands.json', 'compile_flags.txt', '.csdb']
            if filereadable(l:project_name.'/.csdb')
                let l:project_dir_list = readfile(l:project_name.'/.csdb')
                for l:dir in l:project_dir_list
                    for l:file in l:file_to_delete
                        call te#file#delete(l:dir.'/'.l:file, 0)
                    endfor
                endfor
            endif
            let l:ret = te#file#delete(l:project_root.l:project_name, 1)
            call te#utils#EchoWarning("Delete session ". l:project_name)
            if exists(":SDelete") == 2
                execute ':SDelete! '.l:project_name
            elseif exists(":DeleteSession") == 2
                execute ':DeleteSession! '.l:project_name
            endif
        else
            let l:ret=-1
        endif
    else
            let l:ret=-1
    endif
    cd -
    if !l:ret
        call te#utils#EchoWarning("Delete project:".l:project_name." successfully")
    else
        call te#utils#EchoWarning("Delete project:".l:project_name." fail")
    endif
endfunction

function! s:select_dir(result) abort
    call chdir(s:project_dir_list[a:result - 1])
    call te#utils#EchoWarning('Change to direcory:'.s:project_dir_list[a:result - 1])
endfunction

function! te#project#select_dir() abort
    if exists('g:vinux_project.dir') && filereadable(g:vinux_project.dir.'/.csdb')
        let s:project_dir_list = readfile(g:vinux_project.dir.'/.csdb')
        call te#utils#confirm("Select dir", s:project_dir_list, function('<SID>select_dir'))
    else
        call te#utils#EchoWarning('Can not find .csdb')
    endif
endfunction

function! s:hide_popup_timer(timer) abort
    call te#terminal#hide_popup()
endfunction

function! te#project#build_project(in_term) abort
    if !exists('g:vinux_project')
        call te#utils#EchoWarning("Not a project!")
        return
    endif
    if has_key(g:vinux_project, 'cmd')
        if a:in_term == 1
            let l:build_terminal_buf = te#terminal#get_term_buf_by_title('build')
            if l:build_terminal_buf >= 0
                if has_key(g:vinux_project, 'build_root_dir') && isdirectory(g:vinux_project.build_root_dir)
                    let l:cd_cmd = 'cd '.g:vinux_project.build_root_dir
                endif
                call te#terminal#send_key(l:build_terminal_buf, l:cd_cmd."\r")
                call te#terminal#send_key(l:build_terminal_buf, g:vinux_project.cmd."\r")
                if !len(win_findbuf(l:build_terminal_buf))
                    call te#terminal#open_term({'bufnr':l:build_terminal_buf})
                    call timer_start(str2nr(2000), function('<SID>hide_popup_timer'), {'repeat': 1})
                endif
            else
                call te#utils#EchoWarning("Please create a terminal with title name build!")
            endif
        else
            if has_key(g:vinux_project, 'build_root_dir') && isdirectory(g:vinux_project.build_root_dir)
                execute 'cd '.g:vinux_project.build_root_dir
            endif
            call te#utils#run_command(g:vinux_project.cmd, 1)
            execute 'cd '.g:vinux_project.dir
        endif
    endif
endfunction
