Plug 'chrisbra/vim-zsh',{'for': 'zsh'}
if get(g:, 'complete_plugin_type') ==# 'deoplete' 
    Plug 'zchee/deoplete-zsh',{'for': 'zsh'}
else
    Plug 'Valodim/vim-zsh-completion',{'for': 'zsh'}
endif

if matchstr($SHELL, "zsh") ==# 'zsh'
    autocmd filetype_group BufNewFile,BufRead *.sh,.bashrc*,bashrc,bash.bashrc,.bash[_-]profile*,.bash[_-]logout*,.bash[_-]aliases*,*.bash,*/{,.}bash[_-]completion{,.d,.sh}{,/*},*.ebuild,*.eclass,PKGBUILD* call dist#ft#SetFileTypeSH("zsh")
endif
