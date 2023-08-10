"some programming function

" add cscope database
" a:1:read path from .csdb or pwd
" a:2:use gtags or not
function! te#pg#add_cscope_out(read_project,...) abort
    if a:0 == 2 && a:2 == 1
        let l:cscope_db_name='GTAGS'
    else
        let l:cscope_db_name='cscope.out'
    endif
    if a:read_project == 1
        if !filereadable('.csdb')
            silent! execute 'cs kill '.l:cscope_db_name
            silent! exec 'cs add '.l:cscope_db_name
        else
            for s:line in readfile('.csdb', '')
                silent! exec 'cs add '.s:line.'/'.l:cscope_db_name
                if filereadable(s:line.'/tags')
                    execute 'set tags+='.s:line.'/tags'
                endif
            endfor
        endif
    else
        if a:0 >= 1
            silent! execute 'cs kill '.a:1.'/'.l:cscope_db_name
            silent! exec 'cs add '.a:1.'/'.l:cscope_db_name
        else
            silent! execute 'cs kill '.l:cscope_db_name
            silent! exec 'cs add '.l:cscope_db_name
        endif
    endif
endfunction

function! te#pg#add_tags(tag_path) abort
    let l:ret = rename(a:tag_path."/.temptags", a:tag_path."/tags")
    if l:ret != 0
        call te#utils#EchoWarning("Fail to rename .temptags")
    endif
    execute 'set tags+='.a:tag_path.'/tags'
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

function! s:gen_kernel_cscope(read_csdb) abort
    :silent! call delete('cctree.out')
    let l:cur_path = getcwd()
    let l:ret = 0
    if te#env#SupportCscope()
        if &cscopeprg ==# 'gtags-cscope'
            call te#utils#run_command('make O=. ARCH=arm SUBARCH=sunxi COMPILED_SOURCE=1 gtags', function('te#pg#add_cscope_out'),[a:read_csdb,'.',1])
        else
            call te#utils#run_command('make O=. ARCH=arm SUBARCH=sunxi COMPILED_SOURCE=1 cscope', function('te#pg#add_cscope_out'),[a:read_csdb])
            if filereadable('.temptags')
                let l:ret = te#file#delete('.temptags')
            endif
            if l:ret == 0
                call te#utils#run_command('ctags -f .temptags --languages=C --langmap=c:+.h --c-kinds=+px --fields=+aiKSz -R . ', function('te#pg#add_tags'), [l:cur_path])
            endif
        endif
        :call te#utils#EchoWarning('Generating cscope database and tag file for linux kernel ...')
    else
        if filereadable('.temptags')
            let l:ret = te#file#delete('.temptags')
        endif
        if l:ret == 0
            call te#utils#run_command('ctags -f .temptags --languages=C --langmap=c:+.h --c-kinds=+px --fields=+aiKSz -R . ', function('te#pg#add_tags'), [l:cur_path])
        endif
        :call te#utils#EchoWarning('Generating tag file for linux kernel ...')
    endif

endfunction

function! te#pg#gen_cscope_kernel(timerid) abort
    if te#env#SupportCscope()
        if &cscopeprg ==# 'gtags-cscope'
            let l:option=0x04
        else
            let l:option=0x03
        endif
    else
        let l:option=0x01
    endif
    if filereadable('.csdb')
        for l:line in readfile('.csdb', '')
            if te#pg#top_of_kernel_tree(l:line)
                execute 'cd '.l:line
                :call <SID>gen_kernel_cscope(1)
                cd -
            else
                call te#pg#do_cs_tags(l:line, l:option)
            endif
        endfor
    else
        if te#pg#top_of_kernel_tree(getcwd())
            :call <SID>gen_kernel_cscope(0)
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
"        0x04-->generate gtags
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
                let l:ret = te#file#delete(a:dir.'/.temptags')
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
    if and(a:option, 0x04)
        call te#utils#run_command('gtags '.a:dir, function('te#pg#add_cscope_out'),[0,a:dir,1])
        return 0
    endif
    if !te#env#SupportCscope()
        return
    endif
    if !and(a:option, 0x02) || (&filetype !=# 'c' && &filetype !=# 'cpp')
        return
    endif
    if filereadable(l:cscopefiles)
        let csfilesdeleted=delete(l:cscopefiles)
        if(csfilesdeleted!=0)
            :call te#utils#EchoWarning('Fail to do cscope! I cannot delete the cscope.files')
            return
        endif
    endif
    if(!te#env#IsWindows())
        let l:generate_cscopefiles='find ' .a:dir. ' -name "*.[chsS]" > '  . l:cscopefiles
    else
        let l:generate_cscopefiles='dir /s/b *.c,*.cpp,*.h,*.java,*.cs,*.s,*.asm > '.l:cscopefiles
    endif
    exec 'cd '.a:dir
    call te#utils#run_command(l:generate_cscopefiles.' && cscope -Rbkq -i '.l:cscopefiles, function('te#pg#add_cscope_out'),[0,a:dir])
    cd -
    execute 'normal :'
    execute 'redraw!'
endfunction

" generate cscope database
function! te#pg#gen_cs_out() abort
    let l:project_root=getcwd()
    if te#env#SupportCscope()
        if &cscopeprg ==# 'gtags-cscope'
            let l:option=0x04
        else
            let l:option=0x02
        endif
    else
        let l:option=0x01
    endif
    if !filereadable('.csdb')
        :call te#pg#do_cs_tags(getcwd(),l:option)
    else
        for l:line in readfile('.csdb', '')
            call te#utils#EchoWarning('Generate cscope database in '.l:line)
            call te#pg#do_cs_tags(l:line, l:option)
        endfor
    endif
    execute 'cd '.l:project_root
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
