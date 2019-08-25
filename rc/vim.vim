Plug 'mhinz/vim-lookup', {'for': 'vim'}
Plug 'Shougo/neco-vim', {'on':[]}
Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'}

if g:complete_plugin_type.cur_val !=# 'ncm2' || g:complete_plugin_type.cur_val !=# 'deoplete.nvim'
    autocmd filetype_group FileType vim setlocal omnifunc=te#complete#vim_complete
endif

call te#feat#register_vim_plug_insert_setting([], 
            \ ['neco-vim'])

nnoremap  <silent><Leader>vd :call te#tools#vim_get_message()<cr>
nnoremap  <silent><Leader>sm :message<cr>
