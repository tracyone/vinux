" Stolen and adapted from SolaWing/vim-config
if get(g:, 'complete_plugin_type') ==# 'ycm' && get(g:, 'feat_enable_complete') == 1
    setlocal omnifunc=te#complete#vim_complete
endif

