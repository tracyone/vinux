Plug 'chrisbra/vim-zsh',{'for': 'zsh'}
if g:complete_plugin_type.cur_val ==# 'deoplete.nvim' 
    Plug 'zchee/deoplete-zsh',{'for': 'zsh'}
else
    Plug 'tracyone/vim-zsh-completion',{'for': ['zsh','sh']}
endif

