Plug 'junegunn/goyo.vim',{'on': 'Goyo'}
Plug 'vimwiki/vimwiki'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'chrisbra/NrrwRgn'

" toggle free writing in vim (Goyo)
nnoremap <Leader>to :Goyo<cr>
map <localleader>wt <Plug>VimwikiToggleListItem
nmap <localleader>wT <Plug>VimwikiTabIndex
nmap <localleader>ww <Plug>VimwikiIndex
nmap <localleader>wl <Plug>VimwikiUISelect
nmap <localleader>wi <Plug>VimwikiDiaryIndex
nmap <localleader>wd <Plug>VimwikiMakeDiaryNote
nmap <localleader>ii 0i* [ ] 

let g:org_agenda_files = [$VIMFILES.'/org/*.org']
let g:org_todo_keywords = [['TODO(t)', '|', 'DONE(d)'],
            \ ['REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)', '|', 'FIXED(f)'],
            \ ['CANCELED(c)']]
