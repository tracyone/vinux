"some programming function

" add cscope database
function! te#pg#add_cscope_out(read_project,...) abort
    if a:read_project == 1
        if empty(glob('.project'))
            exec 'silent! cs add cscope.out'
        else
            for s:line in readfile('.project', '')
                exec 'silent! cs add '.s:line.'/cscope.out'
            endfor
        endif
    else
        if a:0 == 1
            exec 'cs add '.a:1.'/cscope.out'
        else
            exec 'silent! cs add cscope.out'
        endif
    endif
endfunction
function! te#pg#gen_cscope_kernel() abort
    :silent! cs kill cscope.out
    :silent! call delete('cctree.out')
    call te#utils#run_command('make O=. SRCARCH=arm SUBARCH=sunxi COMPILED_SOURCE=1 cscope tags', function('te#pg#add_cscope_out'),[0])
    :call te#utils#EchoWarning('Generating cscope database file for linux kernel ...')
endfunction

function! te#pg#cctree() abort
    if filereadable('cctree.out')
        :CCTreeLoadXRefDB cctree.out
    else
        if filereadable('cscope.out')
            call te#utils#run_command('vim +"CCTreeLoadDB cscope.out" +"CCTreeSaveXRefDB cctree.out" +qa' 
                        \,function('neomakemp#SampleCallBack'),['CCTreeLoadXRefDB cctree.out'])
        else
            :call te#utils#EchoWarning('No cscope.out!Please generate cscope first.')
        endif
    endif
endfunction

function! te#pg#do_cs_tags(dir) abort
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
    :silent! call delete(l:cctreeout)
    if filereadable('tags')
        let tagsdeleted=delete(l:tagfile)
        if(tagsdeleted!=0)
            :call te#utils#EchoWarning('Fail to do tags! I cannot delete the tags')
            return
        endif
    endif
    if filereadable(l:cscopefiles)
        let csfilesdeleted=delete(l:cscopefiles)
        if(csfilesdeleted!=0)
            :call te#utils#EchoWarning('Fail to do cscope! I cannot delete the cscope.files')
            return
        endif
    endif
    if filereadable(l:cscopeout)
        silent! execute 'cs kill '.l:cscopeout
        let csoutdeleted=delete(l:cscopeout)
        if(csoutdeleted!=0)
            :call te#utils#EchoWarning('I cannot delete the cscope.out,try again')
            let csoutdeleted=delete(l:cscopeout)
        endif
        if(csoutdeleted!=0)
            :call te#utils#EchoWarning('I still cannot delete the cscope.out,failed to do cscope')
            return
        endif
    endif
    "if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        "silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    "endif
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
    if empty(glob('.project'))
        :call te#pg#do_cs_tags(getcwd())
    else
        for l:line in readfile('.project', '')
            let l:ans=input('Generate cscope database in '.l:line.' [y/n/a]?','y')
            if l:ans =~# '\v^[yY]$'
                call te#pg#do_cs_tags(l:line)
            endif
        endfor
    endif
    execute 'cd '.l:project_root
endfunction


"make 
function! te#pg#do_make()
    :call te#utils#EchoWarning('making ...')
    :wa
    if empty(glob('makefile')) && empty(glob('Makefile'))
        :call te#utils#run_command('gcc '.expand('%').' -o'.fnamemodify(expand('%'),':r').' && ./'
                    \.fnamemodify(expand('%'),':r'),1)
        :copen
    else
        call neomake#Make(0,['make'])
    endif
endfunction
