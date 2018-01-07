function! te#complete#goto_def(open_type) abort
    let l:cword=expand('<cword>')
    execute a:open_type
    if te#env#SupportYcm() && g:complete_plugin_type.cur_val ==# 'YouCompleteMe' && get(g:, 'feat_enable_complete', 0)
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



function! s:YcmGotoDef() abort
    let l:cur_word=expand('<cword>').'\s*(.*[^;]$'
    if g:complete_plugin_type.cur_val ==# 'YouCompleteMe'
        if  exists('*youcompleteme#Enable') == 0
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

function! s:get_input() abort
  let col = col( '.' )
  let line = getline( '.' )
  if col - 1 < len( line )
    return matchstr( line, '^.*\%' . col . 'c' )
  endif
  return line
endfunction

function! te#complete#update_ycm() abort
    execute 'cd '.g:vinux_plugin_dir.cur_val.'/YouCompleteMe'
    if !isdirectory(g:vinux_plugin_dir.cur_val.'/YouCompleteMe')
        return
    endif
    let l:update_command='git submodule update --remote --merge && git pull origin master' 
    if te#env#IsMac()
        let l:update_command.=' && ./install.py --system-libclang --clang-completer'
    elseif te#env#IsUnix()
        let l:update_command.=' && ./install.py --clang-completer'
    else
        call te#utils#EchoWarning('Current OS is not support','err')
        return
    endif
        call te#utils#run_command(l:update_command)
endfunction
