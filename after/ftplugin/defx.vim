function! s:defx_my_settings() abort
    setlocal nonu nornu
    " Define mappings
	nnoremap <silent><buffer><expr> > defx#do_action('resize',
	\ defx#get_context().winwidth + 10)
	nnoremap <silent><buffer><expr> < defx#do_action('resize',
	\ defx#get_context().winwidth - 10)
    nnoremap <silent><buffer><expr> <CR>
                \ defx#async_action('drop')
    nnoremap <silent><buffer><expr> <2-LeftMouse>
                \ defx#async_action('drop')
    nnoremap <silent><buffer><expr> yy 
                \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
                \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
                \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
                \ defx#async_action('open')
    "nnoremap <silent><buffer><expr> <T>
                "\ defx#do_action('open', 'tabnew|:tabprev')
    nnoremap <silent><buffer><expr> <c-t>
                \ defx#do_action('drop', 'tabnew')
    nnoremap <silent><buffer><expr> <c-v>
                \ defx#do_action('drop', 'vsplit')
    nnoremap <silent><buffer><expr> t 
                \ defx#do_action('drop', 'tabedit')
    nnoremap <silent><buffer><expr> <c-j>
                \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> P
                \ defx#do_action('preview')
    nnoremap <silent><buffer><expr> K
                \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
                \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> dd
                \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
                \ defx#do_action('rename', 'new')
    nnoremap <silent><buffer><expr> x
                \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> .
                \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> <c-o>
                \ defx#async_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
                \ defx#async_action('cd')
    nnoremap <silent><buffer><expr> q
                \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> -
                \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
                \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
                \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
                \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
                \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
                \ defx#do_action('print')
    nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ?
                \ ':<C-u>wincmd w<CR>' :
                \ ':<C-u>Defx -buffer-name=temp -split=vertical<CR>'
    nnoremap <silent><buffer><expr> \
                \ defx#do_action('cd', getcwd())
    nnoremap <silent><buffer><expr> c
                \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> o
                \ defx#async_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> O
                \ defx#async_action('open_tree_recursive')
    nnoremap <silent><buffer><expr> M
                \ defx#do_action('new_multiple_files')
    xnoremap <silent><buffer><expr> -
                \ defx#do_action('toggle_select_visual')
endfunction

call s:defx_my_settings()


