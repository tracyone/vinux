"wirting something...
Plug 'junegunn/goyo.vim',{'on': 'Goyo'}
Plug 'jceb/vim-orgmode', {'for': 'org'}
Plug 'tpope/vim-speeddating'
Plug 'chrisbra/NrrwRgn'

" toggle free writing in vim (Goyo)
nnoremap <Leader>to :Goyo<cr>
nmap <localleader>ww :call <SID>open_index_org()<cr>

let g:org_agenda_files = [$VIMFILES.'/org/index.org']
let g:org_todo_keywords = [['TODO(t)', '|', 'DONE(d)'],
            \ ['REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)', '|', 'FIXED(f)'],
            \ ['CANCELED(c)']]

function! s:open_index_org() abort
    let l:index_org = g:org_agenda_files[0]
    if !filereadable(l:index_org)
        call te#utils#EchoWarning(l:index_org.' is not exist! Try to create one.')
        call writefile(['* Organize everything !!'], l:index_org, "w")
    endif
    silent! execute 'edit! ' . l:index_org
endfunction

