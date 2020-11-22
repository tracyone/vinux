"some programming function

" add cscope database
" a:1:read path from .project or pwd
" a:2:use gtags or not
function! te#pg#add_cscope_out(read_project,...) abort
    if a:0 == 2 && a:2 == 1
        let l:cscope_db_name='GTAGS'
    else
        let l:cscope_db_name='cscope.out'
    endif
    if a:read_project == 1
        if empty(glob('.project'))
            silent! execute 'cs kill '.l:cscope_db_name
            exec 'silent! cs add '.l:cscope_db_name
        else
            for s:line in readfile('.project', '')
                exec 'silent! cs add '.s:line.'/'.l:cscope_db_name
            endfor
        endif
    else
        if a:0 >= 1
            silent! execute 'cs kill '.a:1.'/'.l:cscope_db_name
            exec 'cs add '.a:1.'/'.l:cscope_db_name
        else
            silent! execute 'cs kill '.l:cscope_db_name
            exec 'silent! cs add '.l:cscope_db_name
        endif
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

function! te#pg#top_of_kernel_tree() abort
    let l:tree_check= ['COPYING', 'CREDITS', 'Kbuild', 'MAINTAINERS', 'Makefile',
                \ 'README', 'Documentation', 'arch', 'include', 'drivers',
                \ 'fs', 'init', 'ipc', 'kernel', 'lib', 'scripts']
    for l:needle in l:tree_check
        if !isdirectory(l:needle) && !filereadable(l:needle)
            return 0
        endif
    endfor
    return 1
endfunction

function! te#pg#gen_cscope_kernel(timerid) abort
    if !te#pg#top_of_kernel_tree()
        call te#pg#gen_cs_out()
        call te#utils#EchoWarning('Current directory is not in the top level of kernel tree')
    else
        :silent! call delete('cctree.out')
        if &cscopeprg ==# 'gtags-cscope'
            call te#utils#run_command('make O=. SRCARCH=arm SUBARCH=sunxi COMPILED_SOURCE=1 gtags', function('te#pg#add_cscope_out'),[0,'.',1])
        else
            call te#utils#run_command('make O=. SRCARCH=arm SUBARCH=sunxi COMPILED_SOURCE=1 cscope tags', function('te#pg#add_cscope_out'),[0])
        endif
        :call te#utils#EchoWarning('Generating cscope database file for linux kernel ...')
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
    if and(a:option, 0x04)
        call te#utils#run_command('gtags '.a:dir, function('te#pg#add_cscope_out'),[0,a:dir,1])
        return 0
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
            if &filetype ==# 'cpp'
                call te#utils#run_command('ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .')
            elseif &filetype ==# 'c'
                call te#utils#run_command('ctags -R --c-types=+p --fields=+S *')
            else
                call te#utils#run_command('ctags -R *')
            endif
        endif
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
    let l:option=0x02
    if &cscopeprg ==# 'gtags-cscope'
        let l:option=0x04
    endif
    if empty(glob('.project'))
        :call te#pg#do_cs_tags(getcwd(),l:option)
    else
        for l:line in readfile('.project', '')
            let l:ans=input('Generate cscope database in '.l:line.' [y/n/a]?','y')
            if l:ans =~# '\v^[yY]$'
                call te#pg#do_cs_tags(l:line, l:option)
            endif
        endfor
    endif
    execute 'cd '.l:project_root
endfunction


"make 
function! te#pg#do_make() abort
    :call te#utils#EchoWarning('making ...')
    :wa
    if empty(glob('makefile')) && empty(glob('Makefile'))
        let l:cc = 'gcc '
        if &ft == 'cpp'
            let l:cc = 'g++ --std=c++11 '
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
            call neomake#Make(0,['make'])
        else
            :make
            :botright copen
        endif
    endif
endfunction
