Plug 'mattn/emmet-vim',{'for': 'html'}
Plug 'hail2u/vim-css3-syntax', {'for': ['css']}
Plug 'cakebaker/scss-syntax.vim',{'for': ['scss', 'css']}
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'moll/vim-node', {'for': 'javascript'}
Plug 'maksimr/vim-jsbeautify', {'for': ['html', 'javascript', 'css', 'json', 'html'], 'do': 'npm install'}
Plug 'tmhedberg/SimpylFold',    { 'for': 'python','do': 'pip install --user autopep8 yapf' }
Plug 'vim-scripts/indentpython.vim', {'for': 'python'}
Plug 'gko/vim-coloresque', {'on': []}
call te#feat#register_vim_enter_setting2([0], ['vim-coloresque'])
if te#env#IsNvim() == 0
    Plug 'rbtnn/vim-coloredit', {'on': 'ColorEdit'}
    nnoremap <Leader>ce :ColorEdit<cr>
endif
let g:html_use_css=1
let g:user_emmet_leader_key = '<c-e>'



autocmd filetype_group FileType javascript vnoremap  <silent><buffer> <Leader>cf :call RangeJsBeautify()<cr>
autocmd filetype_group FileType json vnoremap  <silent><buffer>  <Leader>cf :call RangeJsonBeautify()<cr>
autocmd filetype_group FileType html vnoremap  <silent><buffer> <Leader>cf :call RangeHtmlBeautify()<cr>
autocmd filetype_group FileType css vnoremap  <silent><buffer> <Leader>cf :call RangeCSSBeautify()<cr>

" format the whole file
autocmd filetype_group FileType javascript nnoremap  <silent><buffer>  <Leader>cf :call JsBeautify()<cr>
autocmd filetype_group FileType json nnoremap  <silent><buffer>  <Leader>cf :call JsonBeautify()<cr>
autocmd filetype_group FileType html nnoremap  <silent><buffer> <Leader>cf :call HtmlBeautify()<cr>
autocmd filetype_group FileType css nnoremap  <silent><buffer> <Leader>cf :call CSSBeautify()<cr>
