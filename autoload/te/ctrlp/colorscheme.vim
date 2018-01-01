"ctrlp colorscheme
"author:tracyone@live.cn

function! s:GetColorSchemes()
  return uniq(sort(map(
        \  globpath(&runtimepath, "colors/*.vim", 0, 1),  
        \  'fnamemodify(v:val, ":t:r")'
        \)))
endfunction

call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#colorscheme#init()',
      \ 'accept': 'te#ctrlp#colorscheme#accept',
      \ 'lname': 'colorscheme',
      \ 'sname': 'colorscheme',
      \ 'type': 'line',
      \ 'sort': 0,
      \ 'specinput': 0,
      \ })

let s:text = ''
function! te#ctrlp#colorscheme#init() abort
  return s:text
endfunction

function! te#ctrlp#colorscheme#accept(mode, str) abort
  if a:mode !=# 'v'
      call ctrlp#exit()
  endif
  execute 'colorscheme '.a:str
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! te#ctrlp#colorscheme#id() abort
  return s:id
endfunction

function! te#ctrlp#colorscheme#start() abort
    let s:text = s:GetColorSchemes()
    call ctrlp#init(te#ctrlp#colorscheme#id()) 
endfunction
