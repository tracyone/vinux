Plug 'lambdalisue/fern.vim', {'on': []}
Plug 'lambdalisue/fern-git-status.vim', {'on': []}
Plug 'lambdalisue/fern-ssh', {'on': []}
Plug 'yuki-yano/fern-preview.vim', {'on': []}

let s:lazy_load_plugins = ['fern.vim',
            \ 'fern-git-status.vim', 'fern-ssh', 'fern-preview.vim']
 
if g:feat_enable_gui == 1 && g:enable_powerline_fonts.cur_val == 'on'
    if te#env#IsNvim() != 0
        Plug 'TheLeoP/fern-renderer-web-devicons.nvim', {'on': []}
        call add(s:lazy_load_plugins, 'fern-renderer-web-devicons.nvim')
    else
        Plug 'lambdalisue/fern-renderer-devicons.vim', {'on': []}
        call add(s:lazy_load_plugins, 'fern-renderer-devicons.vim')
    endif
endif

if g:feat_enable_jump == 1 && g:fuzzysearcher_plugin_name.cur_val == 'fzf'
    Plug 'LumaKernel/fern-mapping-fzf.vim', {'on': []}
    call add(s:lazy_load_plugins, 'fern-mapping-fzf.vim')
endif


let g:fern_renderer_devicons_disable_warning = 1
call te#tools#register_sexy_command(':Fern . -drawer')

function! s:fern_file_type_setting() abort
    setlocal nonu nornu
    if g:feat_enable_gui == 1 && g:enable_powerline_fonts.cur_val == 'on'
        if te#env#IsNvim() == 0
            call glyph_palette#apply()
        endif
    endif
    nmap <buffer> yy <Plug>(fern-action-clipboard-copy)
    nmap <buffer> r <Plug>(fern-action-rename)
    nmap <buffer> q :bdelete<cr>
    nmap <buffer> p <Plug>(fern-action-clipboard-paste)
    nmap <buffer> <tab> <Plug>(fern-action-choice)
    nmap <buffer> o <Plug>(fern-action-expand)
    nmap <buffer> N <Plug>(fern-action-new-file)
	nmap <buffer> dd <Plug>(fern-action-remove)
	nmap <buffer> <c-t> <Plug>(fern-action-open:tabedit)
	nmap <buffer> <c-x> <Plug>(fern-action-open:split)
	nmap <buffer> I <Plug>(fern-action-hidden:toggle)
	nmap <buffer> > <Plug>(fern-action-zoom:half)
	nmap <buffer> < <Plug>(fern-action-zoom:reset)

    "preview
    nmap <buffer> P <Plug>(fern-action-preview:auto:toggle)
endfunction

function! s:fern_settings() abort
    autocmd FileType fern call <SID>fern_file_type_setting()
    if g:feat_enable_gui == 1 && g:enable_powerline_fonts.cur_val == 'on'
        if te#env#IsNvim() != 0
            let g:fern#renderer = "nvim-web-devicons"
        else
            let g:fern#renderer = "devicons"
        endif
    endif
    nnoremap <silent><leader>te :Fern . -drawer<cr>
    nnoremap <silent><F12> :Fern . -drawer<cr>
    nnoremap <silent><leader>nf :Fern %:h -drawer<cr>
    call fern_git_status#init()
endfunction

call te#feat#register_vim_enter_setting2([function('<SID>fern_settings')], s:lazy_load_plugins)

