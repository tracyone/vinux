Plug 'mhinz/vim-lookup', {'for': 'vim'}
Plug 'Shougo/neco-vim', {'on':[]}
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}
Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1
if te#env#IsNvim() != 0
    let g:echodoc#type = 'virtual_lines'
else
    if te#env#SupportFloatingWindows()
        let g:echodoc#type = 'popup'
    else
        let g:echodoc#type = 'echo'
    endif
endif


if g:complete_plugin_type.cur_val !=# 'ncm2' || g:complete_plugin_type.cur_val !=# 'deoplete.nvim'
    autocmd filetype_group FileType vim setlocal omnifunc=te#complete#vim_complete
endif

call te#feat#register_vim_plug_insert_setting([], 
            \ ['neco-vim'])

nnoremap  <silent><Leader>vd :call te#tools#vim_get_message()<cr>
nnoremap  <silent><Leader>sm :message<cr>
