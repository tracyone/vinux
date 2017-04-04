"wirting something...
Plug 'junegunn/goyo.vim',{'on': 'Goyo'}
Plug 'jceb/vim-orgmode', {'for': 'org'}
Plug 'tpope/vim-speeddating'
Plug 'chrisbra/NrrwRgn'
Plug 'tracyone/utl.vim'

" toggle free writing in vim (Goyo)
nnoremap <Leader>to :Goyo<cr>
nmap <localleader>ww :call <SID>open_index_org()<cr>

let g:org_agenda_files = [$VIMFILES.'/org/*.org']
let g:org_todo_keywords = [['TODO(t)', '|', 'DONE(d)'],
            \ ['REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)', '|', 'FIXED(f)'],
            \ ['CANCELED(c)']]

function! s:open_index_org() abort
    let l:index_org = $VIMFILES.'/org/index.org'
    if !filereadable(l:index_org)
        call te#utils#EchoWarning(l:index_org.' is not exist! Try to create one.')
        call writefile(['* Organize everything !!'], l:index_org, "w")
    endif
    silent! execute 'edit! ' . l:index_org
endfunction

if te#env#IsGui()
	let g:utl_cfg_hdl_scm_http = "silent !xdg-open '%u' &"
	let g:utl_cfg_hdl_scm_mailto = "silent !x-terminal-emulator -e mutt '%u'"
	for pdfviewer in ['evince', 'okular', 'kpdf', 'acroread']
		" slower implementation but also detect executeables in other locations
		"let pdfviewer = substitute(system('which '.pdfviewer), '\n.*', '', '')
		let pdfviewer = '/usr/bin/'.pdfviewer
		if filereadable(pdfviewer)
			let g:utl_cfg_hdl_mt_application_pdf = 'silent !'.pdfviewer.' "%p"'
			break
		endif
	endfor
else
	let g:utl_cfg_hdl_scm_http = "silent !www-browser '%u' &"
	let g:utl_cfg_hdl_scm_mailto = "silent !mutt '%u'"
	let g:utl_cfg_hdl_mt_application_pdf = 'new|set buftype=nofile|.!pdftotext "%p" -'
endif
if te#env#IsMac()
    let g:utl_cfg_hdl_scm_http = "silent !open '%u' &"
endif
" Shortcut to run the Utl command {{{2
" open link
nnoremap gl :Utl<CR>
xnoremap gl Utl o v<CR>
" copy/yank link
nnoremap gL Utl cl<CR>
xnoremap gL Utl cl v<CR>

