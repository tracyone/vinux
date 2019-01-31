if te#env#IsDisplay()
    Plug 'iamcco/markdown-preview.vim',{'for': 'markdown'}
    Plug 'iamcco/mathjax-support-for-mkdp',{'for': 'markdown'}
endif
Plug 'mzlogin/vim-markdown-toc',{'for': 'markdown'}
Plug 'plasticboy/vim-markdown',{'for': 'markdown'}

" Markdown ------------------------{{{
if  te#env#IsMac()
    let g:mkdp_path_to_chrome = 'open -a safari'
elseif te#env#IsWindows()
    let g:mkdp_path_to_chrome = 'C:\\Program Files (x86)\Google\Chrome\Application\chrome.exe'
else
    let g:mkdp_path_to_chrome = 'google-chrome'
endif
let g:vim_markdown_toc_autofit = 1
" Markdown preview in browser
nnoremap <leader>mp :MarkdownPreview<cr>
" generate markdown TOC
nnoremap <leader>mt :silent GenTocGFM<cr>
" update markdown TOC
nnoremap <leader>mu :silent UpdateToc<cr>
" Show toc sidebar
nnoremap <leader>ms :Toc<cr>
"}}}
