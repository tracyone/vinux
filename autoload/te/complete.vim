function! te#complete#cstag(timer) abort
    let l:ret = 0
    if s:cur_file_name == expand('%:t') && s:cur_line == line(".")
        if te#env#SupportCscope()
            "cscope and ctags combine
            let l:cmd = ':cstag '.s:cur_word
        else
            let l:cmd = ':tselect '.s:cur_word
        endif
        try
            execute  l:cmd
        catch /^Vim\%((\a\+)\)\=:E/	
            call te#utils#EchoWarning(l:cmd."Can not find any definition...")
            let l:ret = -1
        endtry
        let l:len=getqflist({'size':0}).size
        if l:ret == 0 && l:len > 1
            :botright copen
        endif
    endif
endfunction

function! te#complete#goto_def(open_type) abort
    let l:ret = -1
    let s:cur_line = line(".")
    let s:cur_file_name = expand('%:t')
    let s:cur_word=expand('<cword>')
    execute a:open_type
    if &filetype == 'vim'
        silent! execute 'let l:ret = lookup#lookup()'
        if l:ret > 0
            return 0
        endif
    endif
    if get(g:, 'feat_enable_complete', 0)
        if g:complete_plugin_type.cur_val ==# 'YouCompleteMe' 
            let l:ret=s:YcmGotoDef()
        endif
    endif
    if get(g:, 'feat_enable_lsp') == 1
        let l:ret=te#lsp#gotodefinion()
    endif
    if te#env#SupportTimer() && l:ret == 0
        call timer_start(200, function('te#complete#cstag'), {'repeat': 1})
    else
        if l:ret < 0
            let l:ret = 0
            if te#env#SupportCscope()
                "cscope and ctags combine
                let l:cmd = ':cstag '.s:cur_word
            else
                let l:cmd = ':tselect '.s:cur_word
            endif
            try
                execute  l:cmd
            catch /^Vim\%((\a\+)\)\=:E/	
                call te#utils#EchoWarning("Can not find any definition...")
                let l:ret = -1
            endtry
            let l:len=getqflist({'size':0}).size
            if l:ret == 0 && l:len > 1
                :botright copen
            endif
        else
            return 0
        endif
    endif
    return l:ret
endfunction


function! te#complete#vim_complete( findstart, base ) abort
  let line_prefix = s:get_input()
  if a:findstart
    let ret = necovim#get_complete_position( line_prefix )
    if ret < 0
      return col( '.' ) " default to current
    endif
    return ret
  else
    return necovim#gather_candidates( line_prefix . a:base, a:base )
  endif
endfunction


function! s:get_input() abort
  let col = col( '.' )
  let line = getline( '.' )
  if col - 1 < len( line )
    return matchstr( line, '^.*\%' . col . 'c' )
  endif
  return line
endfunction

function! s:YcmGotoDef() abort
    if g:complete_plugin_type.cur_val ==# 'YouCompleteMe'
        if  exists('*youcompleteme#Enable') == 0
            if te#pg#top_of_kernel_tree(getcwd())
                let g:ycm_global_ycm_extra_conf = $VIMFILES.'/rc/ycm_conf_for_arm_linux.py'
            endif
            call te#utils#EchoWarning('Loading ycm ...')
            call plug#load(g:complete_plugin.name)
            call delete('.ycm_extra_conf.pyc')  
            call youcompleteme#Enable() 
            let g:is_load_ycm = 1
            autocmd! lazy_load_group 
            call te#utils#EchoWarning('ycm has been loaded!')
            return -1 
        endif
    endif
    let l:ret = te#utils#GetError(':YcmCompleter GoToDefinition','Runtime.*')
    if l:ret == -1
        let l:ret = te#utils#GetError(':YcmCompleter GoToDeclaration','Runtime.*')
        if l:ret == 0
            execute ':silent! A'
            " search failed then go back
            if search(s:cur_word) == 0
                execute ':silent! A'
                return -2
            endif
        else
            return -3 
        endif
    else
        if s:cur_file_name == expand('%:t') && s:cur_line == line(".")
            "file name and line not change
            return -4 
        endif
    endif
    return 0
endfunction

function! te#complete#csref(timer) abort
    let l:ret = 0
    if s:cur_file_name == expand('%:t') && s:cur_line == line(".")
        try
            execute ':cs find c '.s:cur_word
        catch /^Vim\%((\a\+)\)\=:E/	
            call te#utils#EchoWarning("Can not find any refernces")
            let l:ret = -1
        endtry
        let l:len=getqflist({'size':0}).size
        if l:ret == 0 && l:len > 1
            :botright copen
        endif
    endif
    return l:ret
endfunction

function te#complete#lookup_reference(open_type) abort
    let l:ret = 0
    let s:cur_line = line(".")
    let s:cur_file_name = expand('%:t')
    let s:cur_word=expand('<cword>')
    execute a:open_type
    if g:feat_enable_lsp == 1
        let l:ret=te#lsp#references()
    elseif g:feat_enable_complete == 1 && g:complete_plugin_type.cur_val == "YouCompleteMe"
        :silent! YcmCompleter GoToReferences
    endif
    if te#env#SupportTimer() && l:ret == 0
        call timer_start(200, function('te#complete#csref'), {'repeat': 1})
    elseif l:ret != 0
        let l:ret = 0
        try
            execute ':cs find c '.s:cur_word
        catch /^Vim\%((\a\+)\)\=:E/	
            call te#utils#EchoWarning("Can not find any refernces")
            let l:ret = -1
        endtry
        let l:len=getqflist({'size':0}).size
        if l:ret == 0 && l:len > 1
            :botright copen
        endif
    endif
    return l:ret
endfunction
