if te#env#IsDisplay()
    Plug 'iamcco/markdown-preview.vim',{'for': 'markdown'}
    Plug 'iamcco/mathjax-support-for-mkdp',{'for': 'markdown'}
endif
Plug 'mzlogin/vim-markdown-toc',{'for': 'markdown'}
if te#env#IsNvim() < 0.6
    Plug 'plasticboy/vim-markdown',{'for': 'markdown'}
endif

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
nnoremap  <silent><leader>mp :MarkdownPreview<cr>
" generate markdown TOC
nnoremap  <silent><leader>mt :silent GenTocGFM<cr>
" update markdown TOC
nnoremap  <silent><leader>mu :silent UpdateToc<cr>
" Show toc sidebar
nnoremap  <silent><leader>ms :Toc<cr>
"}}}
