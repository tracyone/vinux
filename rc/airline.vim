" vim-airline
" powerline font: https://github.com/Magnetic2014/YaHei-Consolas-Hybrid-For-Powerline
scriptencoding utf-8
" Package info {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" }}}
" Config {{{
let g:airline#extensions#tabline#enabled = 1

"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
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

if g:airline_powerline_fonts == 1
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
else
    let g:airline_left_sep = '»'
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '«'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.crypt = '🔒'
    let g:airline_symbols.maxlinenr = '☰'
    let g:airline_symbols.maxlinenr = ''
    let g:airline_symbols.branch = '⎇'
endif
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
" }}}
