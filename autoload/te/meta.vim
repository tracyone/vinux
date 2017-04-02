"meta key mapping
scriptencoding utf-8
if te#env#IsMacVim()
    let s:alt_char={1:'¡',2:'™',3:'£',4:'¢',5:'∞',6:'§',7:'¶',8:'•',9:'ª'
                \,'t':'†','q':'œ','a':'å','=':'≠','h':'˙','l':'¬','j':'∆','k':'˚'
                \,'o':'ø','-':'–','b':'∫','f':'ƒ','m':'µ','w':'∑'}
elseif te#env#IsUnix() && !te#env#IsNvim() && !te#env#IsGui()
    let s:alt_char={1:'±' ,2:'²',3:'³',4:'´',5:'µ',6:'¶',7:'·',8:'¸',9:'¹'
                \,'t':'ô','q':'ñ','a':'á','=':'½','h':'è','l':'ì','j':'ê','k':'ë'
                \,'o':'ï','-':'­','b':'â','f':'æ','m':'í','w':'÷'}
elseif te#env#IsGui() || te#env#IsNvim()
    let s:alt_char={1:'<m-1>',2:'<m-2>',3:'<m-3>',4:'<m-4>',5:'<m-5>',6:'<m-6>',7:'<m-7>',8:'<m-8>',9:'<m-9>'
                \,'t':'<m-t>','q':'<m-q>','a':'<m-a>','=':'<m-=>','h':'<m-h>','l':'<m-l>','j':'<m-j>','k':'<m-k>'
                \,'o':'<m-o>','-':'<m-->','b':'<m-b>','f':'<m-f>','m':'<m-m>','w':'<m-w>'}
endif

function! te#meta#init()
    if !te#env#IsNvim()
        if(!te#env#IsGui())
            let s:c='a'
            while s:c <=# 'z'
                exec 'set <m-'.s:c.">=\e".s:c
                exec "inoremap \e".s:c.' <m-'.s:c.'>'
                let s:c = nr2char(1+char2nr(s:c))
            endw
            let s:d='1'
            while s:d <=? '9'
                exec 'set <m-'.s:d.">=\e".s:d
                exec "inoremap \e".s:d.' <m-'.s:d.'>'
                let s:d = nr2char(1+char2nr(s:d))
            endw
        endif
    endif
    ""no", "yes" or "menu"; how to use the ALT key
    set winaltkeys=no
endfunction

function! te#meta#map(maptype,keycodes,action) abort
    execute a:maptype.' '.s:alt_char[a:keycodes].' '.a:action
endfunction
