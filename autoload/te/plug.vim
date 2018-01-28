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
            setlocal ft=help
        endfor
    endif
    if l:found == 0
        call te#utils#EchoWarning("Can not find ".name."'s document")
    endif
endfunction

function! te#plug#open_plugin_dir() abort
    let name = matchstr(getline('.'), '^[x-] \zs\S\+\ze:')
    if has_key(g:plugs, name)
       execute 'cd '.g:plugs[name].dir
       call te#tools#shell_pop(0x4)
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
    if uri !~ 'github.com'
        return
    endif
    let repo = matchstr(uri, 'github.com/\zs.*'.name)
    let url  = empty(sha) ? 'https://github.com/'.repo
                \ : printf('https://github.com/%s/commit/%s', repo, sha)
    call te#utils#open_url(url)
endfunction


function! s:scroll_preview(down)
  silent! wincmd P
  if &previewwindow
    execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
    wincmd p
  endif
endfunction

function! te#plug#extra_key() abort
    nnoremap <silent> <buffer> J :call <sid>scroll_preview(1)<cr>
    nnoremap <silent> <buffer> K :call <sid>scroll_preview(0)<cr>
    nnoremap <silent> <buffer> U :execute ':PlugUpdate '.matchstr(getline('.'), '^[x-] \zs\S\+\ze:')<cr>
    nnoremap <silent> <buffer> <c-n> :call search('^  \X*\zs\x')<cr>
    nnoremap <silent> <buffer> <c-p> :call search('^  \X*\zs\x', 'b')<cr>
    nmap <silent> <buffer> dd <nop>
    nmap <silent> <buffer> <c-j> <c-n>o
    nmap <silent> <buffer> <c-k> <c-p>o
endfunction

function! s:syntax()
  syntax clear
  syntax region plug1 start=/\%1l/ end=/\%2l/ contains=plugNumber
  syntax region plug2 start=/\%2l/ end=/\%3l/ contains=plugBracket,plugX
  syn match plugDash /^-/
  syn match plugName /\(^- \)\@<=[^ ]*:/
  syn match plugNotLoaded /(http.*)$/
  syn keyword Function PlugInstall PlugStatus PlugUpdate PlugClean
  hi def link plug1       Title
  hi def link plug2       Repeat
  hi def link plugDash    Special
  hi def link plugName    Label
  hi def link plugNotLoaded Comment
endfunction

"list all plugin
function! te#plug#list() abort
    tabnew
    nnoremap <buffer> q :call te#utils#quit_win(0)<cr>
    nnoremap <buffer> <2-LeftMouse> :call te#plug#open_doc()<cr>
    nnoremap <buffer> <s-LeftMouse> :call te#plug#browse_plugin_url()<cr>
    nnoremap <buffer> <RightMouse> :call te#plug#open_plugin_dir()<cr>
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
        call add(l:output, printf("- %s:%s", l:needle,' ('.g:plugs[l:needle].uri.')' ) )
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
    :f [Plugins]
endfunction
