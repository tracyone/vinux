"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif
let b:did_vinux_ftplugin = 1

if get(g:, 'feat_enable_c') != 1
    :finish
endif

" add cscope database at the first time
if get(g:,'tagging_program').cur_val ==# 'gtags'
    set cscopeprg=gtags-cscope
    :call te#pg#add_cscope_out(1,'.',1)
else
    set cscopeprg=cscope
    :call te#pg#add_cscope_out(1)
endif

" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
set cscopetag
" check cscope for definition of a symbol before checking ctags: set to 1
" if you want the reverse search order.
set cscopetagorder=0
set cscopequickfix=s-,c-,d-,i-,t-,e-,i-,g-,f-
" add any cscope database in current directory
" else add the database pointed to by environment variable 
set cscopetagorder=0
set cscopeverbose 
" show msg when any other cscope db added
nnoremap  <silent><buffer> <LocalLeader>s :cs find s <C-R>=expand("<cword>")<CR><CR>:botright cw 7<cr>
nnoremap  <silent><buffer> <LocalLeader>d :cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>:botright cw 7<cr>
nnoremap  <silent><buffer> <LocalLeader>c :cs find c <C-R>=expand("<cword>")<CR><CR>:botright cw 7<cr>
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

nnoremap  <silent><buffer> <LocalLeader>u :call te#pg#gen_cs_out()<cr>
nnoremap  <silent><buffer> <LocalLeader>a :call te#pg#add_cscope_out(1)<cr>
"kill the connection of current dir 
nnoremap  <silent><buffer> <LocalLeader>k :cs kill cscope.out<cr> 

" make
nnoremap  <silent><buffer> <leader>am :call te#pg#do_make()<cr>
nnoremap  <silent><buffer> <F5> :call te#pg#do_make()<CR>
nnoremap  <silent><buffer> <silent> K :call te#utils#find_mannel()<cr>
nnoremap  <silent><buffer><Leader>cf :<C-u>ClangFormat<CR>
vnoremap  <silent><buffer><Leader>cf :ClangFormat<CR>
" generate cscope for linux kernel
nnoremap  <silent><buffer><Leader>gk :call te#pg#gen_cscope_kernel(0)<cr>
" generate cctree database
nnoremap  <silent><buffer><Leader>gt :call te#pg#cctree()<cr>


nnoremap  <silent><buffer><leader>cC :s,//\(.*\),/*\1 */,<cr>
vnoremap  <silent><buffer><leader>cC :s,//\(.*\),/*\1 */,<cr>

setlocal cinoptions=:0,l1,t0,g0,(0)
setlocal comments    =sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/
setlocal cindent  "enable specific indenting for C code
setlocal foldmethod=syntax
setlocal colorcolumn=80
execute 'setlocal tabstop='.g:vinux_tabwidth
execute 'setlocal shiftwidth='.g:vinux_tabwidth
execute 'setlocal softtabstop='.g:vinux_tabwidth
setlocal noexpandtab
setlocal nosmarttab

" linux coding style
let g:clang_format#code_style=g:vinux_coding_style.cur_val
if g:vinux_coding_style.cur_val ==# 'linux'
    let g:clang_format#code_style='llvm'
    let g:clang_format#style_options = {
                \ 'IndentWidth' : '8',
                \ 'UseTab' : 'Always',
                \ 'BreakBeforeBraces' : 'Linux',
                \ 'AllowShortIfStatementsOnASingleLine': 'false',
                \ 'AllowShortBlocksOnASingleLine': 'false',
                \ 'AllowShortCaseLabelsOnASingleLine': 'false',
                \ 'AllowShortFunctionsOnASingleLine': 'None',
                \ 'AllowShortLoopsOnASingleLine': 'false',
                \ 'IndentCaseLabels' : 'false'}
endif

let b:delimitMate_matchpairs = '(:),[:],{:}'

:match Error /\s\+$/

vnoremap  <silent><buffer><Leader>ct :s/^\s\+/\t/g<cr>

let b:match_words=
\ '\%(\<else\s\+\)\@<!\<if\>:\<else\s\+if\>:\<else\%(\s\+if\)\@!\>,' .
\ '\<switch\>:\<case\>:\<default\>'

if !exists('g:vinux_auto_gen_cscope') 
    if te#env#SupportTimer() &&
                \ (te#env#IsTmux() || te#env#SupportAsync())
        if te#pg#top_of_kernel_tree() || te#pg#top_of_uboot_tree()
                    \ || filereadable('.project')
            call timer_start(3000, 'te#pg#gen_cscope_kernel')
            call timer_start(600000, 'te#pg#gen_cscope_kernel', {'repeat': -1})
        endif
    endif
    let g:vinux_auto_gen_cscope=1
endif
