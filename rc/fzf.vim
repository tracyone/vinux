Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

function! FzfStartEntry(cmd)
    if te#env#SupportFloatingWindows() == 1
        call popup_clear()
    endif
    execute a:cmd
endfunction

"buffer
nnoremap  <silent><c-j> :call FzfStartEntry('Buffers')<Cr>
nnoremap  <silent><Leader>fw :call FzfStartEntry('Windows')<cr>
"colorsceme
nnoremap  <silent><Leader>pc :call FzfStartEntry('Colors')<cr>
"file cmd
nnoremap  <silent><Leader><Leader> :call FzfStartEntry("Files")<cr>
"mru
nnoremap  <silent><c-l>  :call FzfStartEntry('History')<cr>
nnoremap  <silent><Leader>pr  :call FzfStartEntry('History')<cr>
"command history
nnoremap  <silent><leader>qc :call FzfStartEntry('History')<cr>
nnoremap  <silent><leader>q/  :call FzfStartEntry('History/')<cr>
" git log checkout
nnoremap  <silent><Leader>pgc  :call FzfStartEntry('Commits')<cr>
nnoremap  <silent><Leader>ps  :call FzfStartEntry('Snippets')<cr>
"vim help
nnoremap  <silent><Leader>ph  :call FzfStartEntry('Helptags')<cr>
"spacemacs :SPC ff
nnoremap  <silent><Leader>ff  :call FzfStartEntry('call te#fzf#dir#start()')<cr>
"feature enable
nnoremap  <silent><Leader>fe  :call FzfStartEntry(':call te#fzf#feat#start(1)')<cr>
"feature disable
nnoremap  <silent><Leader>fd  :call FzfStartEntry(':call te#fzf#feat#start(0)')<cr>

if !te#env#Executable('ctags')
    Plug 'tracyone/fzf-funky',{'on': 'FzfFunky'}
    nnoremap  <silent><Leader>pk  :call FzfStartEntry('FzfFunky')<cr>
    nnoremap  <silent><c-k>  :call FzfStartEntry('FzfFunky')<cr>
else
    nnoremap  <silent><Leader>pk  :call FzfStartEntry('BTags')<cr>
    nnoremap  <silent><c-k>  :call FzfStartEntry('BTags')<cr>
endif

"ag
if te#env#Executable('ag')
    nnoremap  <silent><Leader>pf :Ag<cr>
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
    nnoremap  <silent><Leader>pf  :call FzfStartEntry('Rg')<cr>
    let $FZF_DEFAULT_COMMAND=s:fzf_custom_command
endif

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
        if mode() ==# 't'
            call feedkeys('i')
        endif
    endfunction
else
    if has('patch-8.2.191')
        let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.4 }, 'down': '~40%' }
    else
        let g:fzf_layout = {'window': 'botright '.&lines*40/100.'new'}
    endif
endif

