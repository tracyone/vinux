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

" 25 mins in pomodoro mode
let s:expires_time=1500000

function! EnterScreensaver(timer)
    call feedkeys("\<c-[>")
    :ScreenSaver largeclock
    :ScreenSaver password
endfunction

call timer_start(str2nr(s:expires_time), 'EnterScreensaver', {'repeat': -1})


