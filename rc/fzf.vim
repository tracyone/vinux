"buffer
nnoremap <c-j> :Buffers<Cr>
nnoremap <Leader>fw :Windows<cr>
"colorsceme
nnoremap <Leader>pc :Colors<cr>
"file cmd
nnoremap <Leader><Leader> :Files<cr>
"mru
nnoremap <c-l> :History<cr>
nnoremap <Leader>pr :History<cr>

"ag
if te#env#Executable('ag')
    nnoremap <Leader>pf :Ag<cr>
    let s:fzf_custom_command = 'ag --hidden -l --nocolor --nogroup '.'
                \ --ignore "*.[odODaA]"
                \ --ignore "*.exe"
                \ --ignore "*.out"
                \ --ignore "*.hex"
                \ --ignore "cscope*"
                \ --ignore "*.so"
                \ --ignore "*.dll"
                \ --ignore ".git"
                \ -g ""'
    let $FZF_DEFAULT_COMMAND=s:fzf_custom_command
elseif te#env#Executable('rg')
    let s:fzf_custom_command = 'rg --hidden --files --color=never --glob "!.git"'
    nnoremap <Leader>pf :Rg<cr>
    let $FZF_DEFAULT_COMMAND=s:fzf_custom_command
endif
"command history
nnoremap <Leader>p: :History:<cr>
" git log checkout
nnoremap <Leader>pgc :Commits<cr>

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = $VIMFILES.'/.fzf-history'
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

"nmap <leader><tab> <plug>(fzf-maps-n)
"xmap <leader><tab> <plug>(fzf-maps-x)
"omap <leader><tab> <plug>(fzf-maps-o)
if te#env#SupportFloatingWindows() == 2
    let $FZF_DEFAULT_OPTS='--layout=reverse'
    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
    let g:fzf_layout = get(g:, 'fzf_layout', {'down': '~40%'})

    function! FloatingFZF()
        let height = &lines - 3
        let width = float2nr(&columns - (&columns * 2 / 10))
        let col = float2nr((&columns - width) / 2)

        let col_offset = &columns / 6

        let opts = {
                    \ 'relative': 'editor',
                    \ 'row': height * 0.3,
                    \ 'col': col + col_offset,
                    \ 'width': width * 2 / 3,
                    \ 'height': height / 2
                    \ }

        let buf = nvim_create_buf(v:false, v:true)

        let win = nvim_open_win(buf, v:true, opts)

        call setwinvar(win, '&winhl', 'Normal:Pmenu')

        setlocal
                    \ buftype=nofile
                    \ nobuflisted
                    \ bufhidden=hide
                    \ nonumber
                    \ norelativenumber
                    \ signcolumn=no
    endfunction
endif
