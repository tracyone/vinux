Plug 'mattn/emmet-vim',{'for': 'html'}
Plug 'hail2u/vim-css3-syntax', {'for': ['css']}
Plug 'cakebaker/scss-syntax.vim',{'for': ['scss', 'css']}
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'moll/vim-node', {'for': 'javascript'}
Plug 'maksimr/vim-jsbeautify', {'for': ['html', 'javascript', 'css', 'json', 'html'], 'do': 'npm install'}
Plug 'tmhedberg/SimpylFold',    { 'for': 'python'}

let g:html_use_css=1
let g:user_emmet_leader_key = '<c-e>'

autocmd FileType javascript vnoremap <buffer> <Leader>cf :call RangeJsBeautify()<cr>
autocmd FileType json vnoremap <buffer>  <Leader>cf :call RangeJsonBeautify()<cr>
autocmd FileType html vnoremap <buffer> <Leader>cf :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <Leader>cf :call RangeCSSBeautify()<cr>

" format the whole file
autocmd FileType javascript nnoremap <buffer>  <Leader>cf :call JsBeautify()<cr>
autocmd FileType json nnoremap <buffer>  <Leader>cf :call JsonBeautify()<cr>
autocmd FileType html nnoremap <buffer> <Leader>cf :call HtmlBeautify()<cr>
autocmd FileType css nnoremap <buffer> <Leader>cf :call CSSBeautify()<cr>
