Plug 'chrisbra/vim-zsh',{'for': 'zsh'}
if get(g:, 'complete_plugin_type') ==# 'deoplete' 
    Plug 'zchee/deoplete-zsh',{'for': 'zsh'}
else
    Plug 'tracyone/vim-zsh-completion',{'for': ['zsh','sh']}
endif

