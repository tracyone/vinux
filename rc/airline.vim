" vim-airline
" powerline font: https://github.com/Magnetic2014/YaHei-Consolas-Hybrid-For-Powerline
scriptencoding utf-8
" Package info {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" }}}
" Config {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#fnamemod = ':p:t'
let g:airline#extensions#hunks#enabled = 0

let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_crypt=1
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#ycm#enabled = 1

let g:airline_theme='gruvbox'

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

if g:airline_powerline_fonts == 1 && !te#env#IsMacVim()
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
else
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.branch = '⎇'
endif
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.crypt = '🔒'

function! s:airline_setting()
    let g:airline_section_error = airline#section#create_right(['%{neomakemp#run_status()}'])
    let g:airline_section_warning='%{strftime("%m/%d\-%H:%M")}'
endfunction

autocmd misc_group VimEnter * call s:airline_setting()
" }}}
