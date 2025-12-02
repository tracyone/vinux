"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif
let b:did_vinux_ftplugin = 1

if get(g:, 'feat_enable_c') != 1
    :finish
endif


if te#env#SupportCscope()

    " show msg when any other cscope db added
    nnoremap  <silent><buffer> <LocalLeader>s :cs find s <C-R>=expand("<cword>")<CR><CR>:botright cw 7<cr>
    nnoremap  <silent><buffer> <LocalLeader>d :cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>:botright cw 7<cr>
    nnoremap  <silent><buffer> <LocalLeader>t :cs find t <C-R>=expand("<cword>")<CR><CR>:botright cw 7<cr>
    nnoremap  <silent><buffer> <LocalLeader>e :cs find e <C-R>=expand("<cword>")<CR><CR>:botright cw 7<cr>
    "nnoremap ,f :cs find f <C-R>=expand("<cfile>")<CR><CR>:cw 7<cr>
    nnoremap  <silent><buffer> <LocalLeader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:botright cw 7<cr>

    nnoremap  <silent><buffer> <C-\>s :split<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
    nnoremap  <silent><buffer> <C-\>d :split<CR>:cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
    nnoremap  <silent><buffer> <C-\>c :split<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap  <silent><buffer> <C-\>t :split<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
    nnoremap  <silent><buffer> <C-\>e :split<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
    nnoremap  <silent><buffer> <C-\>f :split<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
    nnoremap  <silent><buffer> <C-\>i :split<CR>:cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

    nnoremap  <silent><buffer> <LocalLeader>u :call te#pg#gen_cs_tags(0)<cr>
    nnoremap  <silent><buffer> <LocalLeader>a :call te#pg#add_cscope_out(getcwd())<cr>
    "kill the connection of current dir 
    nnoremap  <silent><buffer> <LocalLeader>k :cs kill cscope.out<cr> 

endif
" make
nnoremap  <silent><buffer> <leader>am :call te#pg#do_make()<cr>
nnoremap  <silent><buffer> <F5> :call te#pg#do_make()<CR>
nnoremap  <silent><buffer><Leader>cf :<C-u>ClangFormat<CR>
vnoremap  <silent><buffer><Leader>cf :ClangFormat<CR>
" generate cctree database
nnoremap  <silent><buffer><Leader>gt :call te#pg#cctree()<cr>


nnoremap  <silent><buffer><leader>cC :s,//\(.*\),/*\1 */,<cr>
vnoremap  <silent><buffer><leader>cC :s,//\(.*\),/*\1 */,<cr>

setlocal cinoptions=:0,l1,t0,g0,(0)
setlocal comments    =sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/
setlocal cindent  "enable specific indenting for C code
setlocal foldmethod=syntax

if g:vinux_coding_style.cur_val == 'linux'
    let g:vinux_tabwidth=8
    set textwidth=80
    set noexpandtab
    set nosmarttab
elseif g:vinux_coding_style.cur_val ==# 'mozilla'
    let g:vinux_tabwidth=4
elseif g:vinux_coding_style.cur_val ==# 'google'
    let g:vinux_tabwidth=2
elseif g:vinux_coding_style.cur_val ==# 'llvm'
    let g:vinux_tabwidth=4
elseif g:vinux_coding_style.cur_val ==# 'chromium'
    let g:vinux_tabwidth=2
endif
execute 'set colorcolumn='.(&textwidth + 1)

execute 'setlocal tabstop='.g:vinux_tabwidth
execute 'setlocal shiftwidth='.g:vinux_tabwidth
if &expandtab == 1
    execute 'silent! set softtabstop='.g:vinux_tabwidth
else
    set softtabstop=0
endif

" linux coding style
let g:clang_format#code_style=g:vinux_coding_style.cur_val
"custom codeing style for linux kernel development
if g:clang_format#code_style ==# 'linux'
    let g:clang_format#code_style='llvm'
    setlocal noexpandtab
    setlocal nosmarttab
    let g:clang_format#style_options = {
                \ 'IndentWidth' : g:vinux_tabwidth,
                \ 'UseTab' : 'Always',
                \ 'BreakBeforeBraces' : 'Linux',
                \ 'AllowShortIfStatementsOnASingleLine': 'false',
                \ 'AllowShortBlocksOnASingleLine': 'false',
                \ 'AllowShortCaseLabelsOnASingleLine': 'false',
                \ 'AllowShortFunctionsOnASingleLine': 'None',
                \ 'AllowShortLoopsOnASingleLine': 'false',
                \ 'IndentCaseLabels' : 'false'}
endif
if &ft == 'cpp'
    execute 'source '.$VIMFILES.'/after/ftplugin/cpp.vim'
endif


let b:delimitMate_matchpairs = '(:),[:],{:}'

:match Error /\s\+$/

vnoremap  <silent><buffer><Leader>ct :s/^\s\+/\t/g<cr>

let b:match_words=
\ '\%(\<else\s\+\)\@<!\<if\>:\<else\s\+if\>:\<else\%(\s\+if\)\@!\>,' .
\ '\<switch\>:\<case\>:\<default\>'

