" Package info {{{
Plug 'tracyone/a.vim',{'for': ['c', 'cpp']}
Plug 'rhysd/vim-clang-format',{'for': ['c', 'cpp']}
Plug 'hari-rangarajan/CCTree',{'for': ['c', 'cpp']}
if te#env#IsNvim() < 0.5
    Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}
endif
if(te#env#IsLinux())
    Plug 'tracyone/pyclewn_linux',{'branch': 'pyclewn-1.11'}
endif
Plug 'jyelloz/vim-dts-indent',{'for': ['dts']}
Plug 'justinmk/vim-syntax-extra',{'for': ['c', 'cpp', 'lex', 'yacc']}
" }}}
" A.vim ---------------------------{{{
":A switches to the header file corresponding to the current file being  edited (or vise versa)
":AS splits and switches
":AV vertical splits and switches
":AT new tab and switches
":AN cycles through matches
":IH switches to file under cursor
":IHS splits and switches
":IHV vertical splits and switches
":IHT new tab and switches
":IHN cycles through matches
" Open c family header in new tab
nnoremap <Leader>aa :AT<cr>
"}}}
" CCtree --------------------------{{{
let g:CCTreeKeyTraceForwardTree = '<C-\>>' "the symbol in current cursor's forward tree 
let g:CCTreeKeyTraceReverseTree = '<C-\><'
let g:CCTreeKeyHilightTree = '<C-\>l' " Static highlighting
let g:CCTreeKeySaveWindow = '<C-\>y'
let g:CCTreeKeyToggleWindow = '<C-\>w'
let g:CCTreeKeyCompressTree = 'zs' " Compress call-tree
let g:CCTreeKeyDepthPlus = '<C-\>='
let g:CCTreeKeyDepthMinus = '<C-\>-'
let g:CCTreeJoinProgCmd = 'PROG_JOIN JOIN_OPT IN_FILES > OUT_FILE'
let  g:CCTreeJoinProg = 'cat' 
let  g:CCTreeJoinProgOpts = ''
"let g:CCTreeUseUTF8Symbols = 1
"map <F7> :CCTreeLoadXRefDBFromDisk $CCTREE_DB<cr> 
command! -bang -nargs=* -complete=file Make Neomake! <args>
"}}}
"misc {{{
let g:neomake_make_maker = {
            \ 'exe': 'make',
            \ 'args': ['-j8'],
            \ 'errorformat': '%f:%l:%c: %m',
            \ }
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 1

"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
