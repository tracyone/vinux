"just for fun ...
Plug 'itchyny/thumbnail.vim',{'on': 'Thumbnail'}
Plug 'itchyny/screensaver.vim'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar'}


"config ...
function! s:fun_setting()
    let g:screensaver_password = 1
    call screensaver#source#password#set('926aa1d8058dd2dbf419367ceee6d55162dbe51c32c5d2452e94ec229c621d64')
    nnoremap <Leader>aS :ScreenSaver password<cr>
endfunction
call te#feat#register_vim_enter_setting(function('<SID>fun_setting'))
" open calendar
nnoremap <Leader>ad :Calendar<cr>
nnoremap <Leader>ab :Thumbnail<cr>

let s:reset_time=0
let s:expires_time=90000
autocmd misc_group CursorMoved,CursorMovedI * let s:reset_time=1

function! EnterScreensaver(timer)
    if s:reset_time == 0
        call feedkeys("\<c-[>")
        :ScreenSaver largeclock
        :ScreenSaver password
    endif
    let s:reset_time=0
endfunction

call timer_start(str2nr(s:expires_time), 'EnterScreensaver', {'repeat': -1})


