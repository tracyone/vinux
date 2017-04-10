"just for fun ...
Plug 'itchyny/thumbnail.vim',{'on': 'Thumbnail'}
Plug 'itchyny/screensaver.vim'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar'}


"config ...
function! s:fun_setting()
    let g:screensaver_password = 1
    let s:password=screensaver#random#number()
    call screensaver#source#password#set(sha256(s:password))
    nnoremap <Leader>ar :call EnterScreensaver(0)<cr>
endfunction
call te#feat#register_vim_enter_setting(function('<SID>fun_setting'))
" open calendar
nnoremap <Leader>ad :Calendar<cr>
nnoremap <Leader>ab :Thumbnail<cr>

" 25 mins in pomodoro mode
let s:expires_time=1500000
let s:rest_time=300000
"let s:expires_time=8000
"let s:rest_time=15000

function! RestExit(timer)
    call timer_info(a:timer)
    call feedkeys("\<c-[>")
    call feedkeys("\<c-[>")
    call feedkeys(s:password)
    call feedkeys("\<cr>")
    if te#env#IsTmux()
        call system('tmux set -g status on')
    endif
    let s:main_timer=timer_start(str2nr(s:expires_time), 'EnterScreensaver', {'repeat': 1})
endfunction

function! EnterScreensaver(timer)
    call timer_info(a:timer)
    call feedkeys("\<c-[>")
    call timer_stop(s:main_timer)
    call timer_start(str2nr(s:rest_time), 'RestExit', {'repeat': 1})
    if te#env#IsTmux()
        call system('tmux set -g status off')
    endif
    :ScreenSaver password
endfunction

let s:main_timer=timer_start(str2nr(s:expires_time), 'EnterScreensaver', {'repeat': 1})

