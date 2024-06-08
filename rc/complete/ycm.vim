" jume to definition (YCM)
function! s:enable_ycm()
    if te#pg#top_of_kernel_tree(getcwd())
        let g:ycm_global_ycm_extra_conf = $VIMFILES.'/rc/ycm_conf/ycm_conf_for_arm_linux.py'
    elseif te#pg#top_of_uboot_tree()
        let g:ycm_global_ycm_extra_conf = $VIMFILES.'/rc/ycm_conf/ycm_conf_for_uboot.py'
    elseif &filetype ==# 'c'
        let g:ycm_global_ycm_extra_conf = $VIMFILES.'/rc/ycm_conf/ycm_conf_for_c.py'
    elseif &filetype ==# 'cpp'
        let g:ycm_global_ycm_extra_conf = $VIMFILES.'/rc/ycm_conf/ycm_conf_for_cpp.py'
    elseif &filetype ==# 'python'
        let g:ycm_global_ycm_extra_conf = $VIMFILES.'/rc/ycm_conf/ycm_conf_for_python.py'
    endif
    call delete('.ycm_extra_conf.pyc')  | call youcompleteme#Enable() 
endfunction
let g:complete_plugin.enable_func=function('<SID>enable_ycm')
nnoremap  <silent><leader>yj :YcmCompleter GoTo<CR>
nnoremap  <silent><leader>yd :YcmDiags<cr>
nnoremap  <silent><leader>yt :YcmCompleter GetType<cr>
nnoremap  <silent><leader>yp :YcmCompleter GetParent<cr>
nnoremap  <silent><leader>yf :YcmCompleter FixIt<cr>
"inoremap <silent><expr> ( complete_parameter#pre_complete("()")
"smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
"imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
"smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
"imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)

let g:ycm_warning_symbol = '!'
let g:ycm_error_symbol = '>>'
let g:ycm_key_detailed_diagnostics = '<leader>ys'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf=0
let g:syntastic_always_populate_loc_list = 1
let g:ycm_semantic_triggers = {
            \   'c' : ['->', '    ', '.', ' ', '(', '[', '&', 're!\w{4}'],
            \     'cpp,objcpp' : ['->', '.', ' ', '(', '[', '&', '::'],
            \     'perl' : ['->', '::', ' '],
            \     'php' : ['->', '::', '.'],
            \     'cs,java,javascript,d,vim,perl6,scala,vb,elixir,go' : ['.'],
            \     'ruby' : ['.', '::'],
            \     'lua' : ['.', ':'],
            \     'vim' : ['$', '&', 're![\w&$<-][\w:#<>-]*']
            \ }
let g:ycm_semantic_triggers.tex = [
            \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
            \ ]
let g:ycm_semantic_triggers.php = ['->', '::', '(', 'use ', 'namespace ', '\', '$', 're!\w{3}']
let g:ycm_semantic_triggers.html = ['<', '"', '</', ' ']
let g:ycm_semantic_triggers.python=['.', 'import ', 're!import [,\w ]+, ']
let g:ycm_semantic_triggers.vimshell=['re!\w{2}', '/']
let g:ycm_semantic_triggers.sh=['re![\w-]{2}', '/', '-', '$']
let g:ycm_semantic_triggers.zsh=['re![\w-]{2}', '/', '-', '$']

let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'qf' : 1,
            \ 'notes' : 1,
            \ 'unite' : 1,
            \ 'text' : 1,
            \ 'vimwiki' : 1,
            \ 'startufy' : 1,
            \ 'pandoc' : 1,
            \ 'infolog' : 1,
            \ 'mail' : 1
            \}
let g:ycm_global_ycm_extra_conf = $VIMFILES.'/rc/ycm_conf_for_c.py'

let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
