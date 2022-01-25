Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim', {'on': []}

function! FzfStartEntry(cmd)
    if te#env#SupportFloatingWindows() == 1
        call popup_clear()
    endif
    execute a:cmd
endfunction



function! s:fzf_vim_setting()
    "buffer
    nnoremap  <silent><c-j> :call FzfStartEntry('Buffers')<Cr>
    nnoremap  <silent><Leader>fw :call FzfStartEntry('Windows')<cr>
    "colorsceme
    nnoremap  <silent><Leader>pc :call FzfStartEntry('Colors')<cr>
    "file cmd
    nnoremap  <silent><Leader><Leader> :call FzfStartEntry("Files")<cr>
    "mru
    nnoremap  <silent><c-l>  :call FzfStartEntry('History')<cr>
    nnoremap  <silent><Leader>pm  :call FzfStartEntry('History')<cr>
    "command history
    nnoremap  <silent><leader>qc :call FzfStartEntry('History')<cr>
    nnoremap  <silent><leader>q/  :call FzfStartEntry('History/')<cr>
    " git log checkout
    nnoremap  <silent><Leader>pgc  :call FzfStartEntry('Commits')<cr>
    nnoremap  <silent><Leader>sp  :call FzfStartEntry('Snippets')<cr>
    "vim help
    nnoremap  <silent><Leader>ph  :call FzfStartEntry('Helptags')<cr>
    "spacemacs :SPC ff
    nnoremap  <silent><Leader>ff  :call FzfStartEntry('call te#fzf#dir#start()')<cr>
    "feature enable
    nnoremap  <silent><Leader>fe  :call FzfStartEntry(':call te#fzf#feat#start(1)')<cr>
    "feature disable
    nnoremap  <silent><Leader>fd  :call FzfStartEntry(':call te#fzf#feat#start(0)')<cr>

    nnoremap <silent><leader>pr :call FzfStartEntry('call te#fzf#reg#start(0)')<cr> 
    inoremap <silent><c-r> <c-o>:stopinsert<cr>:call FzfStartEntry('call te#fzf#reg#start(0)')<cr> 
    xnoremap <silent><leader>pr :call FzfStartEntry('call te#fzf#reg#start(1)')<cr> 

    if !te#env#Executable('ctags')
        Plug 'tracyone/fzf-funky',{'on': 'FzfFunky'}
        nnoremap  <silent><Leader>pk  :call FzfStartEntry('FzfFunky')<cr>
        nnoremap  <silent><c-k>  :call FzfStartEntry('FzfFunky')<cr>
    else
        nnoremap  <silent><Leader>pk  :call FzfStartEntry('BTags')<cr>
        nnoremap  <silent><c-k>  :call FzfStartEntry('BTags')<cr>
    endif
    let g:fzf_buffers_jump = 1

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
    if has('patch-8.2.191') || te#env#IsNvim() != 0
        let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.4 }, 'down': '~40%' }
        let g:fzf_colors =
                    \ { 'fg':      ['fg', 'vinux_tabline'],
                    \ 'border':  ['fg', 'vinux_border'],
                    \ 'preview-fg':      ['fg', 'vinux_normal']}
    elseif te#env#IsTmux()
        "use tmux's popup feature, require tmux V3.2 or later
        let g:fzf_layout = { 'tmux': '-p80%,40%' }
    else
        let g:fzf_layout = { 'down': '~40%' }
    endif

    "disable preview window
    "let g:fzf_preview_window = ''
    "let g:fzf_preview_window = 'right:50%'
endfunction

call te#feat#register_vim_enter_setting2([function('<SID>fzf_vim_setting')], ['fzf.vim'])

