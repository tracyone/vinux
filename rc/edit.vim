Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-expand-region'
Plug 'Raimondi/delimitMate'
Plug 'thinca/vim-qfreplace',{'on': 'Qfreplace'}
Plug 'vim-scripts/The-NERD-Commenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' "repeat enhance
Plug 'junegunn/vim-easy-align',{'on': [ '<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)' ]}
Plug 'osyo-manga/vim-over',{'on': 'OverCommandLine'}
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'mbbill/undotree',  { 'on': 'UndotreeToggle'   }
Plug 'svermeulen/vim-easyclip'

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
nnoremap <c-h> :OverCommandLine<cr>:%s/<C-R>=expand("<cword>")<cr>/
vnoremap <c-h> :OverCommandLine<cr>:<c-u>%s/<C-R>=getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]<cr>/
" undo tree window toggle
nnoremap <leader>tu :UndotreeToggle<cr>
" easyclip ------------------------{{{
nnoremap <c-y> :Yanks<cr>
imap <c-y> <c-o>:Yanks<cr>
" Open yankring window
nnoremap <Leader>yy :Yanks<cr>
" clear yank history
nnoremap <Leader>yc :ClearYanks<cr>
let g:EasyClipShareYanks=1
let g:EasyClipShareYanksDirectory=$VIMFILES
let g:EasyClipUseYankDefaults=1
let g:EasyClipUseCutDefaults=0
let g:EasyClipUsePasteDefaults=0
let g:EasyClipEnableBlackHoleRedirect=0
let g:EasyClipUsePasteToggleDefaults=0
let g:EasyClipCopyExplicitRegisterToDefault=1
nmap <silent> gs <plug>SubstituteOverMotionMap 
nmap gss <plug>SubstituteLine
xmap gs <plug>XEasyClipPaste
call te#meta#map('nmap ','p','<plug>EasyClipSwapPasteForward')
call te#meta#map('nmap ','n','<plug>EasyClipSwapPasteBackwards')
"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
