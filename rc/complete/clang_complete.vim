 " clang_complete
 " path to directory where library can be found
 if te#env#IsMac()
     let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
 elseif te#env#IsUnix()
     let g:clang_library_path='/usr/local/lib'
 else
     let g:clang_library_path='c:/LLVM/bin'
 endif
 "let g:clang_use_library = 1
 let g:clang_complete_auto = 1
 let g:clang_debug = 1
 let g:clang_snippets=1
 let g:clang_complete_copen=0
 let g:clang_periodic_quickfix=1
 let g:clang_snippets_engine='ultisnips'
 let g:clang_close_preview=1
 "let g:clang_jumpto_declaration_key=""
 "g:clang_jumpto_declaration_in_preview_key
 inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
