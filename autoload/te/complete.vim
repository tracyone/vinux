function! te#complete#goto_def(open_type) abort
    let l:cword=expand('<cword>')
    let l:ret = -1
    execute a:open_type
    if &filetype == 'vim'
        :call lookup#lookup()
        return 0
    endif
    if get(g:, 'feat_enable_complete', 0)
        if te#env#SupportYcm() && g:complete_plugin_type.cur_val ==# 'YouCompleteMe' 
            let l:ret=s:YcmGotoDef()
        else
            let l:ret=te#lsp#gotodefinion()
        endif
    endif
    if l:ret < 0
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
    let l:cur_word=expand('<cword>').'\s*(.*[^;]$'
    if g:complete_plugin_type.cur_val ==# 'YouCompleteMe'
        if  exists('*youcompleteme#Enable') == 0
            if te#pg#top_of_kernel_tree()
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
            if search(l:cur_word) == 0
                execute ':silent! A'
                return -2
            endif
        else
            return -3 
        endif
    endif
    return 0
endfunction


function te#complete#lookup_reference(open_type) abort
    if get(g:, 'feat_enable_complete', 0)
        execute a:open_type
        if te#env#SupportYcm() && g:complete_plugin_type.cur_val ==# 'YouCompleteMe' 
            :YcmCompleter GoToReferences
        else
            let l:ret=te#lsp#references()
            if l:ret == -1
                " use ctags or cscope
                :cs find c <C-R>=expand("<cword>")<CR><CR>:botright cw 7
            endif
        endif
        return 0
    endif
    return 1
endfunction
