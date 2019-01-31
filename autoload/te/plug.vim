"vim-plug extra
"https://github.com/junegunn/vim-plug/wiki/extra
"

function! te#plug#open_doc() abort
    let name = matchstr(getline('.'), '^[x-] \zs\S\+\ze:')
    let l:found=0
    if has_key(g:plugs, name)
        for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
            let l:found=1
            execute 'tabe' doc
            setlocal filetype=help
        endfor
    endif
    if l:found == 0
        call te#utils#EchoWarning('Can not find '.name."'s document")
    endif
endfunction

function! te#plug#open_plugin_dir(option) abort
    let name = matchstr(getline('.'), '^[x-] \zs\S\+\ze:')
    if has_key(g:plugs, name)
        if isdirectory(g:plugs[name].dir)
            if a:option == 2
                call delete(g:plugs[name].dir, 'rf')
                call te#utils#EchoWarning('Delete '.g:plugs[name].dir)
            else
                execute 'cd '.g:plugs[name].dir
                call te#utils#EchoWarning('cd '.g:plugs[name].dir)
            endif
        else
            call te#utils#EchoWarning(g:plugs[name].dir.' is not found!')
            return
        endif
       if a:option == 1
           call te#tools#shell_pop(0x4)
       endif
    endif
endfunction

function! te#plug#show_log() abort
    let name = matchstr(getline('.'), '^[x-] \zs\S\+\ze:')
    if has_key(g:plugs, name)
       call te#git#show_log(g:plugs[name].dir)
    endif
endfunction

function! te#plug#browse_plugin_url() abort
    let line = getline('.')
    let sha  = matchstr(line, '^  \X*\zs\x\{7,9}\ze ')
    let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:')
                \ : getline(search('^- .*:$', 'bn'))[2:-2]
    let uri  = get(get(g:plugs, name, {}), 'uri', '')
    if uri !~# 'github.com'
        return
    endif
    let repo = matchstr(uri, 'github.com/\zs.*'.name)
    let url  = empty(sha) ? 'https://github.com/'.repo
                \ : printf('https://github.com/%s/commit/%s', repo, sha)
    call te#utils#open_url(url)
endfunction


function! s:scroll_preview(down) abort
  silent! wincmd P
  if &previewwindow
    execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
    wincmd p
  endif
endfunction

function! s:get_plugin_name_in_visual_mode() abort
    let l:sline=line("'<")
    let l:eline=line("'>")
    let l:result=''
    while l:sline <= l:eline
        let l:result.=matchstr(getline(l:sline), '^[x-] \zs\S\+\ze:').' '
        let l:sline+=1
    endw
    return l:result
endfunction

function! te#plug#extra_key() abort
    nnoremap <silent> <buffer> J :call <sid>scroll_preview(1)<cr>
    nnoremap <silent> <buffer> K :call <sid>scroll_preview(0)<cr>
    nnoremap <silent> <buffer> U :execute ':PlugUpdate '.matchstr(getline('.'), '^[x-] \zs\S\+\ze:')<cr>
    xnoremap <silent> <buffer> U :<c-u>execute ':PlugUpdate '.<SID>get_plugin_name_in_visual_mode()<cr>
    nnoremap <silent> <buffer> <c-n> :call search('^  \X*\zs\x')<cr>
    nnoremap <silent> <buffer> <c-p> :call search('^  \X*\zs\x', 'b')<cr>
    nnoremap <silent> <buffer> cd :call te#plug#open_plugin_dir(0)<cr>
    nmap <silent> <buffer> dd :call te#plug#open_plugin_dir(2)<cr>
    nmap <silent> <buffer> <c-j> <c-n>o
    nmap <silent> <buffer> <c-k> <c-p>o
endfunction

function! s:syntax() abort
  syntax clear
  syntax region plug1 start=/\%1l/ end=/\%2l/ contains=plugNumber
  syntax region plug2 start=/\%2l/ end=/\%3l/ contains=plugBracket,plugX
  syn match plugDash /^-/
  syn match plugName /\(^- \)\@<=[^ ]*:/
  syn match plugNotLoaded /(http.*)/
  syn match plugError /\[missing\]/
  syn keyword Function PlugInstall PlugStatus PlugUpdate PlugClean
  hi def link plug1       Title
  hi def link plug2       Repeat
  hi def link plugDash    Special
  hi def link plugName    Label
  hi def link plugNotLoaded Comment
  hi def link plugError   Error
endfunction

"list all plugin
function! te#plug#list() abort
    if buflisted('[plugins_list]')
        call te#utils#EchoWarning("Plugin list buffer is already exist!")
        execute ':b '.bufnr("[plugins_list]")
        return
    endif
    tabnew
    nnoremap <buffer> q :call te#utils#quit_win(0)<cr>
    nnoremap <buffer> <2-LeftMouse> :call te#plug#open_doc()<cr>
    nnoremap <buffer> <s-LeftMouse> :call te#plug#browse_plugin_url()<cr>
    nnoremap <buffer> <RightMouse> :call te#plug#open_plugin_dir(1)<cr>
    setlocal wrap
    setlocal mouse=a
    setlocal conceallevel=2 concealcursor=nc
    setlocal keywordprg=:help iskeyword=@,48-57,_,192-255,-,#

    let l:output=[]
    call add(l:output, 'Vinux plugins list:')
    call add(l:output, '====================')
    call add(l:output, '')
    let l:i=3

    for l:needle in g:plugs_order
        if !isdirectory(g:plugs[l:needle].dir)
            call add(l:output, printf('- %s:%s [missing]', l:needle,' ('.g:plugs[l:needle].uri.')' ) )
        else
            call add(l:output, printf('- %s:%s', l:needle,' ('.g:plugs[l:needle].uri.')' ) )
        endif
        let l:i=l:i + 1
    endfor
    let l:output[0].=l:i-3
    call append(0, l:output)

    setlocal nomodified
    setlocal nomodifiable
    setlocal bufhidden=delete
    setlocal filetype=vim-plug
    call s:syntax()
    :0
    :f [plugins_list]
endfunction
