"some programming function
"
function! te#pg#start_gen_cs_tags_threads() abort
    if !exists('s:vinux_auto_gen_cscope') 
        if filereadable('.csdb') || te#pg#top_of_kernel_tree(getcwd()) 
                    \ || te#pg#top_of_uboot_tree()
            let s:vinux_auto_gen_cscope=1
            if te#env#SupportTimer()
                call timer_start(3000, 'te#pg#gen_cs_tags')
                call timer_start(600000, 'te#pg#gen_cs_tags', {'repeat': -1})
            elseif filereadable('.csdb')
                call te#pg#gen_cs_tags(0)
            endif
        endif
    endif
endfunction

" add cscope database
" a:1:read path from .csdb or pwd
" a:2:use gtags or not
function! te#pg#add_cscope_out(path) abort
    if &cscopeprg == 'gtags-cscope'
        let l:cscope_db_name='GTAGS'
    else
        let l:cscope_db_name='cscope.out'
    endif
    if filereadable(a:path.'/'.l:cscope_db_name)
        "gtags require change to GTAGS's path before add it
        execute 'cd '. a:path
        silent! execute 'cs kill '.a:path.'/'.l:cscope_db_name
        silent! exec 'cs add '.a:path.'/'.l:cscope_db_name." ".a:path
        cd -
    endif
endfunction

let s:extra_tags_list = []
function! te#pg#add_tags(tag_path) abort
    if filereadable(a:tag_path."/.temptags")
        let l:ret = rename(a:tag_path."/.temptags", a:tag_path."/tags")
        if l:ret != 0
            call te#utils#EchoWarning("Fail to rename .temptags")
        endif
    endif
    if filereadable(a:tag_path.'/tags')
        execute 'set tags+='.a:tag_path.'/tags'
        for l:needle in s:extra_tags_list
            if l:needle == a:tag_path.'/tags'
                return
            endif
        endfor
        call add(s:extra_tags_list, a:tag_path.'/tags')
    endif
endfunction

function! te#pg#get_tags_number(sep) abort
    if len(s:extra_tags_list)
        return 'tags['.len(s:extra_tags_list).']'.a:sep
    else
        return ""
    endif
endfunction

function! te#pg#top_of_uboot_tree() abort
    let l:tree_check= ['include/asm-generic/u-boot.h', 'CREDITS', 'Kbuild', 'Makefile',
                \ 'README', 'arch', 'include', 'drivers',
                \ 'fs','lib', 'scripts']
    for l:needle in l:tree_check
        if !isdirectory(l:needle) && !filereadable(l:needle)
            return 0
        endif
    endfor
    return 1
endfunction

function! te#pg#top_of_kernel_tree(path) abort
    if !isdirectory(a:path)
        return 0
    endif
    let l:tree_check= ['COPYING', 'CREDITS', 'Kbuild', 'MAINTAINERS', 'Makefile',
                \ 'README', 'Documentation', 'arch', 'include', 'drivers',
                \ 'fs', 'init', 'ipc', 'kernel', 'lib', 'scripts']
    for l:needle in l:tree_check
        if !isdirectory(a:path.'/'.l:needle) && !filereadable(a:path.'/'.l:needle)
            return 0
        endif
    endfor
    return 1
endfunction

function! s:gen_kernel_cscope(path) abort
    :silent! call delete('cctree.out')
    let l:ret = 0
    if te#env#SupportCscope()
        call te#utils#run_command('make O=. ARCH=arm SUBARCH=sunxi COMPILED_SOURCE=1 '.g:tagging_program.cur_val, function('te#pg#add_cscope_out'),[a:path])
        if filereadable('.temptags')
            let l:ret = te#file#delete('.temptags', 0)
        endif
        if l:ret == 0
            call te#utils#run_command('ctags -f .temptags --languages=C --langmap=c:+.h --c-kinds=+px --fields=+aiKSz -R . ', function('te#pg#add_tags'), [a:path])
        endif
        :call te#utils#EchoWarning('Generating cscope database and tag file for linux kernel ...')
    else
        if filereadable('.temptags')
            let l:ret = te#file#delete('.temptags', 0)
        endif
        if l:ret == 0
            call te#utils#run_command('ctags -f .temptags --languages=C --langmap=c:+.h --c-kinds=+px --fields=+aiKSz -R . ', function('te#pg#add_tags'), [a:path])
        endif
        :call te#utils#EchoWarning('Generating tag file for linux kernel ...')
    endif

endfunction

function! te#pg#gen_cs_tags(timerid) abort
    if te#env#SupportCscope()
        let l:option=0x03
    else
        let l:option=0x01
    endif
    let l:old_pwd=getcwd()
    if exists('g:vinux_working_directory') && isdirectory(g:vinux_working_directory)
        let l:old_pwd=g:vinux_working_directory
    endif
    execute 'cd '.l:old_pwd
    if filereadable('.csdb')
        for l:line in readfile('.csdb', '')
            call te#pg#add_tags(l:line)
            if te#env#SupportCscope()
                call te#pg#add_cscope_out(l:line)
            endif
            if te#pg#top_of_kernel_tree(l:line)
                execute 'cd '.l:line
                :call <SID>gen_kernel_cscope(l:line)
                execute 'cd '.l:old_pwd
            else
                call te#pg#do_cs_tags(l:line, l:option)
            endif
        endfor
    else
        if te#pg#top_of_kernel_tree(getcwd())
            :call <SID>gen_kernel_cscope(getcwd())
        else
            call te#pg#do_cs_tags(getcwd(), l:option)
        endif
    endif
endfunction

function! te#pg#cctree() abort
    if filereadable('cctree.out')
        :CCTreeLoadXRefDB cctree.out
    else
        if filereadable('cscope.out')
            call te#utils#run_command('vim +"set ft=c" +"CCTreeLoadDB cscope.out" +"CCTreeSaveXRefDB cctree.out" +qa' 
                        \,function('neomakemp#SampleCallBack'),['CCTreeLoadXRefDB cctree.out'])
        else
            :call te#utils#EchoWarning('No cscope.out!Please generate cscope first.')
        endif
    endif
endfunction

"option: 0x01-->generate tags only
"        0x02-->generate cscope only
"        0x03-->generate cscope and tags
function! te#pg#do_cs_tags(dir, option) abort
    let l:ret = 0
    if(te#env#IsWindows())
        let l:tagfile=a:dir.'\\'.'tags'
        let l:cscopefiles=a:dir.'\\'.'cscope.files'
        let l:cscopeout=a:dir.'\\'.'cscope.out'
        let l:cctreeout=a:dir.'\\'.'cctree.out'
    else
        let l:tagfile=a:dir.'/tags'
        let l:cscopefiles=a:dir.'/cscope.files'
        let l:cscopeout=a:dir.'/cscope.out'
        let l:cctreeout=a:dir.'/cctree.out'
    endif
    if type(a:option) != g:t_number
        call te#utils#EchoWarning('Wrong argument! Option must be a number', 'err')
        return
    endif
    :silent! call delete(l:cctreeout)
    if and(a:option, 0x01)
        if filereadable('tags')
            let tagsdeleted=delete(l:tagfile)
            if(tagsdeleted!=0)
                :call te#utils#EchoWarning('Fail to do tags! I cannot delete the tags')
                return
            endif
        endif
        if(executable('ctags'))
            let l:cmd_str = 'ctags -f '.a:dir.'/.temptags '
            if filereadable(a:dir.'/.temptags')
                let l:ret = te#file#delete(a:dir.'/.temptags', 0)
            endif
            if l:ret == 0
                if &filetype ==# 'cpp'
                    call te#utils#run_command(l:cmd_str.'-R --languages=C++ --langmap=c++:+.inl.h.cc --c++-kinds=+px --fields=+aiKSz --extra=+q .', function('te#pg#add_tags'), [a:dir])
                elseif &filetype ==# 'c'
                    call te#utils#run_command(l:cmd_str.'--languages=C --langmap=c:+.h --c-kinds=+px --fields=+aiKSz -R .', function('te#pg#add_tags'), [a:dir])
                else
                    call te#utils#run_command(l:cmd_str.'-R .', function('te#pg#add_tags'), [a:dir])
                endif
            endif
        endif
    endif
    if !te#env#SupportCscope() || !and(a:option, 0x02)
        return
    endif
    if filereadable(l:cscopefiles)
        let csfilesdeleted=delete(l:cscopefiles)
        if(csfilesdeleted!=0)
            :call te#utils#EchoWarning('Fail to do cscope! I cannot delete the cscope.files')
            return
        endif
    endif

    if te#git#is_git_repo()
        let l:generate_cscopefiles='git ls-files > '  . l:cscopefiles
    else
        if !te#env#IsWindows()
            let l:generate_cscopefiles='find ' .a:dir. ' -name "*.[chsS]" -o -name "*.cpp"  -o -name "*.java"  -o -name "*.vim" > '  . l:cscopefiles
        else
            let l:generate_cscopefiles='dir /s/b *.c,*.cpp,*.h,*.java,*.cs,*.s,*.asm > '.l:cscopefiles
        endif
    endif
    let l:old_pwd=getcwd()
    exec 'cd '.a:dir
    if &cscopeprg ==# 'gtags-cscope'
        if exists('$GTAGSLABEL')
            let l:gtagslabel=' --gtagslabel='.$GTAGSLABEL
        else
            let l:gtagslabel=''
        endif
        call te#utils#run_command(l:generate_cscopefiles.' && gtags -i -f '.l:cscopefiles.' '.l:gtagslabel.' '.a:dir, function('te#pg#add_cscope_out'),[a:dir])
        return 0
    endif
    call te#utils#run_command(l:generate_cscopefiles.' && cscope -Rbkq -i '.l:cscopefiles, function('te#pg#add_cscope_out'),[a:dir])
    execute 'cd ' .l:old_pwd
    execute 'normal :'
    execute 'redraw!'
endfunction

"make 
function! te#pg#do_make() abort
    :call te#utils#EchoWarning('making ...')
    :wa
    if !filereadable('makefile') && !filereadable('Makefile')
        let l:cc = 'gcc '
        if &ft == 'cpp'
            let l:cc = 'g++ --std=c++14 '
        endif
        if te#env#IsWindows()
            :call te#utils#run_command(l:cc.expand('%').' -o'.fnamemodify(expand('%'),':r').' && '
                        \.fnamemodify(expand('%'),':r'),1)
        else
            :call te#utils#run_command(l:cc.expand('%').' -o'.fnamemodify(expand('%'),':r').' && ./'
                        \.fnamemodify(expand('%'),':r'),1)
        endif
    else
        if get(g:,'feat_enable_basic') && te#env#SupportAsync()
            :call te#utils#run_command("make", 1)
        else
            :make
            :botright copen
        endif
    endif
endfunction
