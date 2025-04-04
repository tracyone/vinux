"vim-plug extra
"https://github.com/junegunn/vim-plug/wiki/extra
"
function! te#plug#gen_help_tag() abort
    let name = matchstr(getline('.'), '^[x-] \zs\S\+\ze:')
    if isdirectory(g:plugs[name].dir.'/doc')
        execute ':helptags '.g:plugs[name].dir.'/doc'
        call te#utils#EchoWarning("Generate tags for ".name." successfully")
    else
        call te#utils#EchoWarning("Can not find any directory")
    endif
endfunction

function! te#plug#open_doc() abort
    let name = matchstr(getline('.'), '^[x-] \zs\S\+\ze:')
    let l:found=0
    if has_key(g:plugs, name)
        for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
            let l:found=1
            execute 'tabe' doc
            setlocal filetype=help
        endfor
        if l:found == 0
            for doc in split(globpath(g:plugs[name].dir, './*.md'), '\n')
                let l:found=1
                execute 'tabe' doc
            endfor
            call te#utils#EchoWarning('Can not find '.name."'s txt document try to find markdown document")
        endif
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
                call te#utils#confirm('Delete '.g:plugs[name].dir.' directory??', ['Yes', 'No'], ["call delete(".string(g:plugs[name].dir).", 'rf')", ""])
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
           call te#terminal#shell_pop({'opener':0x4})
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

function! s:update_plugins(vmode) abort
    if a:vmode == 1
        let l:plugin_name = <SID>get_plugin_name_in_visual_mode()
    else
        let l:plugin_name = matchstr(getline('.'), '^[x-] \zs\S\+\ze:')
    endif
    if te#env#IsNvim() > 0
        :bdelete
    endif
    execute 'PlugUpdate '.l:plugin_name
endfunction

function! te#plug#extra_key() abort
    nnoremap  <silent><buffer> q :bdelete<cr>
    nnoremap  <silent><buffer> <2-LeftMouse> :call te#plug#open_doc()<cr>
    nnoremap  <silent><buffer> <s-LeftMouse> :call te#plug#browse_plugin_url()<cr>
    nnoremap  <silent><buffer> <RightMouse> :call te#plug#open_plugin_dir(1)<cr>
    nnoremap <buffer> <silent> H :call te#plug#open_doc()<cr> 
    nnoremap <buffer> <silent> <leader>ol :call te#plug#browse_plugin_url()<cr>
    nnoremap <buffer> <silent> <c-t> :call te#plug#open_plugin_dir(1)<cr>
    nnoremap <buffer> <silent> D :call te#plug#show_log()<cr>
    nnoremap <buffer> <silent> t :call te#plug#gen_help_tag()<cr>
    nnoremap <silent> <buffer> U :call <SID>update_plugins(0)<cr>
    xnoremap <silent> <buffer> U :<c-u>:call <SID>update_plugins(1)<cr>
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
  syn match MoreMsg /(http.*)/
  syn match plugError /\[missing\]/
  syn match plugNotLoaded /\[unloaded\]/
  syn keyword Function PlugInstall PlugStatus PlugUpdate PlugClean
  hi def link plug1       Title
  hi def link plug2       Repeat
  hi def link plugDash    Special
  hi def link plugNotLoaded Comment
  hi def link plugName    Label
  hi def link plugError   Error
endfunction

function! te#plug#window(content) abort
    let l:buf_opt = {'buftype':'nofile', 'buflisted':v:false, 'bufhidden':'wipe',
                \ 'undolevels':-1, 'textwidth':0, 'swapfile':v:false,
                \  'filetype':'vim-plug', 'modifiable':v:false,
                \ }
    let l:win_opt = {'number':v:false, 'relativenumber':v:false, 'wrap':v:false,
                \ 'spell':v:false, 'foldenable':v:false, 'signcolumn':"no",
                \  'colorcolumn':'', 'cursorline':v:true, 'previewwindow':v:true,
                \ }
    let l:buf = nvim_create_buf(v:false, v:true)
    let l:opts = {'relative': 'editor','anchor': "NW", 'border': 'rounded', 
                \ 'focusable': v:true, 'style': 'minimal', 'zindex': 1}
    let l:opts.width = &columns * 8/10 
    let l:opts.height = &lines * 8/10 
    let l:opts.row = (&lines - l:opts.height)/2 - 2
    let l:opts.col = (&columns - l:opts.width)/2
    let l:opts.title = "Vinux Plugins Manager" 
    let l:opts.title_pos = "center" 
    let l:plugins_list_win_id=nvim_open_win(l:buf, v:true, l:opts)
    call nvim_win_set_option(l:plugins_list_win_id, 'winhl', 
                \ 'FloatBorder:vinux_border,FloatTitle:vinux_warn')
    for [k,v] in items(l:win_opt)
        call nvim_win_set_option(l:plugins_list_win_id, k, v)
    endfor
    if len(a:content)
        call nvim_buf_set_lines(l:buf, 0, -1, v:false, a:content)
    endif
    for [k,v] in items(l:buf_opt)
        call nvim_buf_set_option(l:buf, k, v)
    endfor
    return l:plugins_list_win_id
endfunction

"list all plugin
function! te#plug#list() abort
    if exists('s:plugins_list_win_id') && s:plugins_list_win_id > 0 && win_gotoid(s:plugins_list_win_id) == v:true
        return
    endif
    let s:plugins_list_win_id = -1

    let l:output = ['Vinux plugins list:', '====================', '']
    let l:output += map(copy(g:plugs_order), {_, needle -> 
                \ printf('- %s: (%s) %s', needle, g:plugs[needle].uri, 
                \ !isdirectory(g:plugs[needle].dir) ? '[missing]' : '' .
                \ (!plug#is_plugin_load(needle) ? ' [unloaded]' : '')) })
    let l:output[0] .= len(g:plugs_order)

    let l:buf_opt = {'buftype':'nofile', 'buflisted':v:false, 'bufhidden':'wipe',
                \ 'undolevels':-1, 'textwidth':0, 'swapfile':v:false,
                \ 'filetype':'vim-plug', 'modifiable':v:false}

    if te#env#IsNvim() > 0.5
        let s:plugins_list_win_id = te#plug#window(l:output)
        call s:syntax()
    else
        tabnew
        call append(0, l:output)
        for [k, v] in items(l:buf_opt)
            execute 'setlocal ' . (type(v) == g:t_bool ? (v ? '' : 'no') : '') . k . (type(v) == g:t_bool ? '' : '=' . v)
        endfor
        call s:syntax()
        let s:plugins_list_win_id = bufwinid(bufnr('%'))
    endif
endfunction

function! te#plug#is_plugin_exist(plugin) abort
    return has_key(g:plugs, a:plugin)
endfunction
