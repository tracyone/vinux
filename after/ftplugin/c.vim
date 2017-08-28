if get(g:, 'feat_enable_c') != 1
    :finish
endif

" add cscope database at the first time
:call te#pg#add_cscope_out(1)

" use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
set cscopetag
set csprg=cscope
" check cscope for definition of a symbol before checking ctags: set to 1
" if you want the reverse search order.
set csto=0
set cscopequickfix=s-,c-,d-,i-,t-,e-,i-,g-,f-
" add any cscope database in current directory
" else add the database pointed to by environment variable 
set cscopetagorder=0
set cscopeverbose 
" show msg when any other cscope db added
nnoremap <buffer> <LocalLeader>s :cs find s <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>g :call te#complete#goto_def("")<cr>
nnoremap <buffer> <LocalLeader>d :cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>c :cs find c <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>t :cs find t <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>e :cs find e <C-R>=expand("<cword>")<CR><CR>:cw 7<cr>
"nnoremap ,f :cs find f <C-R>=expand("<cfile>")<CR><CR>:cw 7<cr>
nnoremap <buffer> <LocalLeader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:cw 7<cr>

nnoremap <buffer> <C-\>s :split<CR>:cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>g :call te#complete#goto_def("sp")<cr>
nnoremap <buffer> <C-\>d :split<CR>:cs find d <C-R>=expand("<cword>")<CR> <C-R>=expand("%")<CR><CR>
nnoremap <buffer> <C-\>c :split<CR>:cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>t :split<CR>:cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>e :split<CR>:cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>f :split<CR>:cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <C-\>i :split<CR>:cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

nnoremap <buffer> <LocalLeader>u :call te#pg#gen_cs_out()<cr>
nnoremap <buffer> <LocalLeader>a :call te#pg#add_cscope_out(1)<cr>
"kill the connection of current dir 
nnoremap <buffer> <LocalLeader>k :cs kill cscope.out<cr> 

" make
nnoremap <buffer> <leader>am :call te#pg#do_make()<cr>
noremap <buffer> <F5> :call te#pg#do_make()<CR>
nnoremap <buffer> <silent> K :call te#utils#find_mannel()<cr>
nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
vnoremap <buffer><Leader>cf :ClangFormat<CR>
" generate cscope for linux kernel
nnoremap <buffer><Leader>gk :call te#pg#gen_cscope_kernel()<cr>
" generate cctree database
nnoremap <buffer><Leader>gt :call te#pg#cctree()<cr>

nnoremap <buffer><silent> <Enter> :call te#complete#goto_def("")<cr>

nnoremap <buffer><leader>cC :s,//\(.*\),/*\1 */,<cr>
vnoremap <buffer><leader>cC :s,//\(.*\),/*\1 */,<cr>

setlocal cinoptions=:0,l1,t0,g0,(0)
setlocal comments    =sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/
setlocal cindent  "enable specific indenting for C code
setlocal foldmethod=syntax 
setlocal colorcolumn=80
setlocal tabstop=8  
setlocal shiftwidth=8 
setlocal softtabstop=8 
setlocal noexpandtab
setlocal nosmarttab

" linux coding style
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

let b:delimitMate_matchpairs = '(:),[:],{:}'


vnoremap <buffer><Leader>ct :s/^\s\+/\t/g<cr>

let b:match_words=
\ '\%(\<else\s\+\)\@<!\<if\>:\<else\s\+if\>:\<else\%(\s\+if\)\@!\>,' .
\ '\<switch\>:\<case\>:\<default\>'

