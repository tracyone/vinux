"ctrlp colorscheme
"author:tracyone@live.cn

function! s:GetColorSchemes()
    if !te#env#IsVim8() && !te#env#IsNvim()
        return map(
                    \  split(globpath(&runtimepath, "colors/*.vim"), nr2char(10)),  
                    \  'fnamemodify(v:val, ":t:r")'
                    \)
    else
        return uniq(map(
                    \  globpath(&runtimepath, "colors/*.vim", 0, 1),  
                    \  'fnamemodify(v:val, ":t:r")'
                    \))
    endif
endfunction

call add(g:ctrlp_ext_vars, {
      \ 'init': 'te#ctrlp#colorscheme#init()',
      \ 'accept': 'te#ctrlp#colorscheme#accept',
      \ 'lname': 'colorscheme',
      \ 'sname': 'color',
      \ 'type': 'line',
      \ 'sort': 1,
      \ 'specinput': 0,
      \ })

let s:text = []
function! te#ctrlp#colorscheme#init() abort
  return s:text
endfunction

"press ctrl-v will not exit ctrlp
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
