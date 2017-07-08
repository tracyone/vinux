"just for fun ...
Plug 'itchyny/thumbnail.vim',{'on': 'Thumbnail'}
Plug 'itchyny/calendar.vim', { 'on': 'Calendar'}
Plug 'johngrib/vim-game-code-break', {'on': 'VimGameCodeBreak'}


" open calendar
nnoremap <Leader>ad :Calendar<cr>
nnoremap <Leader>ab :Thumbnail<cr>

if !te#env#SupportTimer()
    :finish
endif

Plug 'itchyny/screensaver.vim'

"config ...
function! s:fun_setting()
    let g:screensaver_password = 1
    let s:password=screensaver#random#number()
    call screensaver#source#password#set(sha256(s:password))
    nnoremap <Leader>ar :call EnterScreensaver(0)<cr>
endfunction
call te#feat#register_vim_enter_setting(function('<SID>fun_setting'))

" 25 mins in pomodoro mode
let s:expires_time=1500000
let s:rest_time=300000
"let s:expires_time=8000
"let s:rest_time=15000
let s:main_timer=-1

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

function! s:clear_screen_flag()
    let l:timer_info=timer_info(s:main_timer)
    if filereadable($VIMFILES.'/.screenlock')
        if te#env#IsUnix()
            let l:pid=readfile($VIMFILES.'/.screenlock', '')[0]
            call system('kill -0 '.l:pid)
            if v:shell_error
                call delete($VIMFILES.'/.screenlock')
            endif
        endif
        if !empty(l:timer_info)
            call delete($VIMFILES.'/.screenlock')
        endif
    endif
endfunction

if !filereadable($VIMFILES.'/.screenlock')
    let s:main_timer=timer_start(str2nr(s:expires_time), 'EnterScreensaver', {'repeat': 1})
    call writefile([getpid()],$VIMFILES.'/.screenlock')
endif

autocmd misc_group VimLeave * call <SID>clear_screen_flag()

