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
    let s:password=strftime('%Y%m%d')
    silent! call screensaver#source#password#set(sha256(s:password))
    nnoremap <Leader>ar :call EnterScreensaver(0)<cr>
endfunction
call te#feat#register_vim_enter_setting(function('<SID>fun_setting'))

" 1500000 ms (25 mins)
let s:expires_time=1500000
" 120000 ms (2 mins) for rest time
let s:rest_time=120000
let s:main_timer=-1

function! RestExit(timer)
    call timer_info(a:timer)
    call feedkeys("\<c-[>")
    call feedkeys("\<c-[>")
    call feedkeys("\<c-[>")
    call feedkeys("\<cr>")
    call feedkeys(s:password)
    call feedkeys("\<cr>")
    let s:main_timer=timer_start(str2nr(s:expires_time), 'EnterScreensaver', {'repeat': 1})
endfunction

function! EnterScreensaver(timer)
    call timer_info(a:timer)
    call feedkeys("\<c-[>")
    call timer_stop(s:main_timer)
    if a:timer != 0
        call timer_start(str2nr(s:rest_time), 'RestExit', {'repeat': 1})
    endif
    :ScreenSaver largeclock
    call feedkeys("\<c-[>")
endfunction

let s:main_timer=timer_start(str2nr(s:expires_time), 'EnterScreensaver', {'repeat': 1})
