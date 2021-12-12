Plug 'lambdalisue/gina.vim', {'on': []}

function! StageNext(count) abort
    for i in range(a:count)
        call search('^\t.*','W')
    endfor
    return '.'
endfunction

function! StagePrevious(count) abort
    if line('.') == 1 && exists(':CtrlP') && get(g:, 'ctrl_p_map') =~? '^<c-p>$'
        return 'CtrlP '.fnameescape(s:repo().tree())
    else
        for i in range(a:count)
            call search('^\t.*','Wbe')
        endfor
        return '.'
    endif
endfunction

function s:gina_setting()
    nnoremap  <silent><F3> :Gina status<cr>
    " Open git status window
    nnoremap  <silent><Leader>gs :Gina status<cr>
    " Open github url
    nnoremap  <silent><Leader>gh :Gina browse<cr>
    " Open git blame windows
    nnoremap  <silent><Leader>gb :Gina blame --use-author-instead :<cr>
    " show branch
    nnoremap  <silent><Leader>sb :Gina branch -a<cr>
    " show tag
    nnoremap  <silent><Leader>st :Gina tag<cr>
    " git diff current file
    nnoremap  <silent><Leader>gd :Gina compare :<cr>
    " git cd
    nnoremap <silent><Leader>gc :Gina cd<cr>:call te#utils#EchoWarning(getcwd())<cr>
    " git config -e
    nnoremap  <silent><Leader>ge :Gina cd<cr>:sp .git/config<cr>
    call gina#custom#command#option('status', '--opener', &previewheight . 'split')
    call gina#custom#command#option('commit', '--opener', &previewheight . 'split')
    call gina#custom#command#option('status', '--group', 'short')
    call gina#custom#command#option('commit', '--group', 'short')
    "log windows
    silent! call gina#custom#mapping#nmap(
                \ 'log', 'yy',
                \ ':call gina#action#call(''yank:rev'')<CR>',
                \ {'noremap': 1, 'silent': 0},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'log', '<c-n>',
                \ 'j:call gina#action#call(''show:preview'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'log', '<c-p>',
                \ 'k:call gina#action#call(''show:preview'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'log', '<cr>',
                \ ':call gina#action#call(''show:preview'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'log', '<c-t>',
                \ ':call gina#action#call(''show:tab'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'log', '<tab>',
                \ '<c-w>w',
                \ {'noremap': 1, 'silent': 1},
                \)
    "blame windows
    silent! call gina#custom#mapping#nmap(
                \ 'blame', '<cr>',
                \ ':call gina#action#call(''show:commit:tab'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    "branch windows
    silent! call gina#custom#mapping#nmap(
                \ 'branch', 'cc',
                \ ':call gina#action#call(''checkout:track'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    "status windows
    let g:gina#command#status#use_default_mappings=0
    silent! call gina#custom#mapping#nmap(
                \ 'status', 'cc',
                \ ':<C-u>Gina commit --signoff<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)

    silent! call gina#custom#mapping#nmap(
                \ 'status', '=',
                \ ':call gina#action#call(''diff:top'')<CR>',
                \ {'noremap': 1, 'silent': 0},
                \)

    silent! call gina#custom#mapping#nmap(
                \ 'status', '<cr>',
                \ ':call gina#action#call(''edit'')<CR>',
                \ {'noremap': 1, 'silent': 0},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', 'yy',
                \ ':call gina#action#call(''yank:path'')<CR>',
                \ {'noremap': 1, 'silent': 0},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', '-',
                \ ':call gina#action#call(''index:toggle'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', 'e',
                \ ':call gina#action#call(''diff'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#vmap(
                \ 'status', '-',
                \ ':call gina#action#call(''index:toggle'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', '<c-n>',
                \ ':<C-U>execute StageNext(v:count1)<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', '<tab>',
                \ ':<C-U>execute StageNext(v:count1)<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', '<c-p>',
                \ ':<C-U>execute StagePrevious(v:count1)<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', 'ca',
                \ ':<C-u>Gina commit --amend --signoff<CR>:0<cr>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'commit', 'cc',
                \ ':<C-u>Gina status<CR>:0<cr>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', 'U',
                \ ':call gina#action#call(''index:discard'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', 'u',
                \ ':call gina#action#call(''checkout'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#vmap(
                \ 'status', 'u',
                \ ':call gina#action#call(''checkout'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', 'd',
                \ ':call gina#action#call(''patch'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'status', 'D',
                \ ':call gina#action#call(''compare'')<CR>',
                \ {'noremap': 1, 'silent': 1},
                \)
    silent! call gina#custom#mapping#nmap(
                \ '/.*', 'q',
                \ ':call te#utils#quit_win(0)<cr>',
                \ {'noremap': 1, 'silent': 1},
                \)
    "let g:gina#command#status#use_default_mappings=0
    silent! call gina#custom#mapping#nmap(
                \ 'blame', 'yy',
                \ ':call gina#action#call(''yank:rev'')<CR>',
                \ {'noremap': 1, 'silent': 0},
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'blame', 'j',
                \ 'j<Plug>(gina-blame-echo)'
                \)
    silent! call gina#custom#mapping#nmap(
                \ 'blame', 'k',
                \ 'k<Plug>(gina-blame-echo)'
                \)
    call gina#custom#execute('commit', 'setlocal omnifunc=github_complete#complete nofoldenable cursorline')
    call gina#custom#execute('status', 'setlocal nofoldenable cursorline')
    let g:gina#component#repo#commit_length=6
    call gina#component#repo#branch()
endfunction

call te#feat#register_vim_enter_setting2([function('<SID>gina_setting')], ['gina.vim'])
