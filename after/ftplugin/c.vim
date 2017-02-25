if g:feat_enable_c != 1
    :finish
endif

if !te#env#SupportCscope()
    call te#utils#EchoWarning("Please install cscope and build vim with cscope feature")
    finish
endif
" add cscope database
function! s:AddCscopeOut(read_project,...)
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

" generate cscope database
function! s:GenCsTag()
    if empty(glob('.project'))
        :call s:DoCsTag(getcwd())
    else
        for l:line in readfile('.project', '')
            let l:ans=input('Generate cscope database in '.l:line.' [y/n/a]?','y')
            if l:ans =~# '\v^[yY]$'
                call s:DoCsTag(l:line)
            endif
        endfor
    endif
endfunction


function! GenCCTreeDataBase()
    if filereadable('cctree.out')
        :CCTreeLoadXRefDB cctree.out
    else
        if filereadable('cscope.out')
            call neomakemp#run_command('vim +"CCTreeLoadDB cscope.out" +"CCTreeSaveXRefDB cctree.out" +qa' 
                        \,function('neomakemp#SampleCallBack'),['CCTreeLoadXRefDB cctree.out'])
        else
            :call te#utils#EchoWarning('No cscope.out!Please generate cscope first.')
        endif
    endif
endfunction

function! GenerateCscope4Kernel()
    :silent! cs kill cscope.out
    :silent! call delete('cctree.out')
    call neomakemp#run_command('make O=. SRCARCH=arm SUBARCH=sunxi COMPILED_SOURCE=1 cscope tags', function('<SID>AddCscopeOut'),[0])
    :call te#utils#EchoWarning('Generating cscope database file for linux kernel ...')
endfunction

function! s:DoMake()
    :call te#utils#EchoWarning('making ...')
    :wa
    if empty(glob('makefile')) && empty(glob('Makefile'))
        :call neomakemp#run_command('gcc '.expand('%').' -o'.fnamemodify(expand('%'),':r').' && ./'
                    \.fnamemodify(expand('%'),':r'),1)
        :copen
    else
        call neomake#Make(0,['make'])
    endif
endfunction

function! s:DoCsTag(dir)
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
    call neomakemp#run_command(l:generate_cscopefiles.' && cscope -Rbkq -i '.l:cscopefiles, function('<SID>AddCscopeOut'),[0,a:dir])
    cd -
    execute 'normal :'
    execute 'redraw!'
endfunction

" add cscope database at the first time
:call s:AddCscopeOut(1)

" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
set cscopetag
set csprg=cscope
" check cscope for definition of a symbol before checking ctags: set to 1
" if you want the reverse search order.
set csto=0
set cscopequickfix=s-,c-,d-,i-,t-,e-,i-,g-,f-
" add any cscope database in current directory
" else add the database pointed to by environment variable 
set cscopetagorder=0
set cscopeverbose 
" show msg when any other cscope db added
nnoremap <buffer> <LocalLeader>s :cs find s <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>g :call TracyoneGotoDef("")<cr>
nnoremap <buffer> <LocalLeader>d :cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>c :cs find c <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>t :cs find t <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>e :cs find e <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
"nnoremap ,f :cs find f <C-R>=expand("<cfile>")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:cw 7<cr>

nnoremap <buffer> <C-\>s :split<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>g :call TracyoneGotoDef("sp")<cr>
nnoremap <buffer> <C-\>d :split<CR>:cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
nnoremap <buffer> <C-\>c :split<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>t :split<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>e :split<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>f :split<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <C-\>i :split<CR>:cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

nnoremap <buffer> <LocalLeader>u :call <SID>GenCsTag()<cr>
nnoremap <buffer> <LocalLeader>a :call <SID>AddCscopeOut()<cr>
"kill the connection of current dir 
nnoremap <buffer> <LocalLeader>k :cs kill cscope.out<cr> 

" make
nnoremap <buffer> <leader>am :call <SID>DoMake()<cr>
noremap <buffer> <F5> :call <SID>DoMake()<CR>
nnoremap <buffer> <silent> K :call te#utils#find_mannel()<cr>
nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
vnoremap <buffer><Leader>cf :ClangFormat<CR>

setlocal cinoptions=:0,l1,t0,g0,(0)
setlocal comments    =sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/
setlocal cindent  "enable specific indenting for C code
setlocal foldmethod=syntax 
setlocal colorcolumn=80

" linux coding style
let g:clang_format#code_style='llvm'
let g:clang_format#style_options = {
            \ 'IndentWidth' : '8',
            \ 'UseTab' : 'Always',
            \ 'BreakBeforeBraces' : 'Linux',
            \ 'AllowShortIfStatementsOnASingleLine': 'false',
	    \ 'AllowShortBlocksOnASingleLine': 'false',
	    \ 'AllowShortCaseLabelsOnASingleLine': 'false',
	    \ 'AllowShortFunctionsOnASingleLine': 'None',
	    \ 'AllowShortLoopsOnASingleLine': 'false',
            \ "IndentCaseLabels" : "false"}

let b:delimitMate_matchpairs = "(:),[:],{:}"

function! TracyoneGotoDef(open_type)
    let l:cword=expand('<cword>')
    execute a:open_type
    if te#env#SupportYcm() && g:complete_plugin_type ==# 'ycm'
        let l:ycm_ret=s:YcmGotoDef()
    else
        let l:ycm_ret = -1
    endif
    if l:ycm_ret < 0
        try
            execute 'cs find g '.l:cword
        catch /^Vim\%((\a\+)\)\=:E/	
            call te#utils#EchoWarning('cscope query failed')
            if a:open_type !=? '' | wincmd q | endif
            return -1
        endtry
    else
        return 0
    endif
    return 0
endfunction

func! s:YcmGotoDef()
    let l:cur_word=expand('<cword>').'\s*(.*[^;]$'
    if g:complete_plugin_type ==# 'ycm' 
        if  exists('*youcompleteme#Enable') == 0
            call te#utils#EchoWarning('Loading ycm ...')
            call plug#load('ultisnips','YouCompleteMe')
            call delete('.ycm_extra_conf.pyc')  
            call youcompleteme#Enable() 
            let g:is_load_ycm = 1
            autocmd! lazy_load_group 
            sleep 1
            call te#utils#EchoWarning('ycm has been loaded!')
        endif
    endif
    let l:ret = te#utils#GetError(':YcmCompleter GoToDefinition','Runtime.*')
    if l:ret == -1
        let l:ret = te#utils#GetError(':YcmCompleter GoToDeclaration','Runtime.*')
        if l:ret == 0
            execute ':silent! A'
            " search failed then go back
            if search(l:cur_word) == 0
                execute ':silent! A'
                return -2
            endif
        else
            return -3 
        endif
    endif
    return 0
endfunc
