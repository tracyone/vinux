Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-expand-region'
Plug 'Raimondi/delimitMate'
Plug 'thinca/vim-qfreplace',{'on': 'Qfreplace'}
Plug 'vim-scripts/The-NERD-Commenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' "repeat enhance
Plug 'junegunn/vim-easy-align',{'on': [ '<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)' ]}
if !te#env#IsNvim()
    Plug 'osyo-manga/vim-over',{'on': 'OverCommandLine'}
endif
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'mbbill/undotree',  { 'on': 'UndotreeToggle'   }
Plug 'tweekmonster/spellrotate.vim', {'on': ['<Plug>(SpellRotateForward)']}
nmap <silent> <leader>zn <Plug>(SpellRotateForward)
nmap <silent> <leader>zp <Plug>(SpellRotateBackward)
vmap <silent> <leader>zn <Plug>(SpellRotateForwardV)
vmap <silent> <leader>zp <Plug>(SpellRotateBackwardV)
nmap <leader>tz :call te#utils#OptionToggle('spell', [1,0])<cr>

" DelimitMate ---------------------{{{
let g:delimitMate_nesting_quotes = ['"','`']
let g:delimitMate_expand_cr = 0
let g:delimitMate_expand_space = 0
"}}}
" Algin ---------------------------{{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
xmap <leader>al <Plug>(LiveEasyAlign)
" Live easy align
nmap <leader>al <Plug>(LiveEasyAlign)
if !exists('g:easy_align_delimiters')
    let g:easy_align_delimiters = {}
endif
let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }
" }}}
" Incsearch -----------------------{{{
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)zz
map N  <Plug>(incsearch-nohl-N)zz
map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)
" }}}
" Nerdcommander -------------------{{{
let g:NERDMenuMode=0
let g:NERD_c_alt_style=1
"toggle comment
nmap <Leader>;; <plug>NERDCommenterComment
nmap <Leader>cc <plug>NERDCommenterComment
"}}}
"replace
if !te#env#IsNvim()
    nnoremap <c-h> :OverCommandLine<cr>:%s/<C-R>=expand("<cword>")<cr>/
    vnoremap <c-h> :OverCommandLine<cr>:<c-u>%s/<C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<cr>/
    nnoremap ss :OverCommandLine<cr>%s//<left>
    vnoremap : :OverCommandLine<cr>s//<left>
else
    nnoremap <c-h> :%s/<C-R>=expand("<cword>")<cr>/
    vnoremap <c-h> :<c-u>%s/<C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<cr>/
    nnoremap ss :%s//<left>
    vnoremap : :s//<left>
endif
" undo tree window toggle
nnoremap <leader>tu :UndotreeToggle<cr>
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
