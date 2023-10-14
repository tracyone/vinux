"wirting something...
Plug 'junegunn/goyo.vim',{'on': 'Goyo'}
Plug 'jceb/vim-orgmode', {'for': 'org'}
Plug 'tpope/vim-speeddating', {'on': []}
Plug 'chrisbra/NrrwRgn',{'on': 'NR'}

if te#env#IsDisplay()
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'iamcco/mathjax-support-for-mkdp',{'for': 'markdown'}
endif
Plug 'mzlogin/vim-markdown-toc',{'for': 'markdown'}
if te#env#IsNvim() < 0.6
    Plug 'plasticboy/vim-markdown',{'for': 'markdown'}
endif
call te#feat#register_vim_enter_setting2([0], ['vim-speeddating'])

" toggle free writing in vim (Goyo)
nnoremap  <silent><Leader>to :Goyo<cr>
" org open index.org
nmap  <silent><Leader>ow :call <SID>open_index_org()<cr>
" org show todo
nmap  <silent><Leader>ot <Plug>OrgAgendaTodo
" org change todo type
nmap  <silent><Leader>od <Plug>OrgTodoToggleInteractive
" org inster a new date
nmap  <silent><Leader>os <Plug>OrgDateInsertTimestampInactiveCmdLine
" org new check box
nmap  <silent><Leader>oc <Plug>OrgCheckBoxNewBelow
" org instert new url
nmap  <silent><Leader>on <Plug>OrgHyperlinkInsert
" org checkbox toggle
nmap  <silent><Leader>ob <Plug>OrgCheckBoxToggle
" org checkbox update
nmap  <silent><Leader>ou <Plug>OrgCheckBoxUpdate



let g:org_agenda_files = [$VIMFILES.'/org/*.org']
let g:org_todo_keywords = [['TODO(t)', '|', 'DONE(d)'],
            \ ['REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)', '|', 'FIXED(f)'],
            \ ['CANCELED(c)']]

function! s:open_index_org() abort
    let l:index_org = $VIMFILES.'/org/index.org'
    if !filereadable(l:index_org)
        call te#utils#EchoWarning(l:index_org.' is not exist! Try to create one.')
        call mkdir($VIMFILES.'/org', 'p')
        call writefile(['* Organize everything !!'], l:index_org, 'a')
    endif
    silent! execute 'edit! ' . l:index_org
endfunction

if te#env#IsGui()
	let g:utl_cfg_hdl_scm_http = "silent !xdg-open '%u' &"
	let g:utl_cfg_hdl_scm_mailto = "silent !x-terminal-emulator -e mutt '%u'"
	for s:pdfviewer in ['evince', 'okular', 'kpdf', 'acroread']
		" slower implementation but also detect executeables in other locations
		"let s:pdfviewer = substitute(system('which '.s:pdfviewer), '\n.*', '', '')
		let s:pdfviewer = '/usr/bin/'.s:pdfviewer
		if filereadable(s:pdfviewer)
			let g:utl_cfg_hdl_mt_application_pdf = 'silent !'.s:pdfviewer.' "%p"'
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
xnoremap  <silent><Leader>nl :NR<cr>
nnoremap  <silent><Leader>nl vip:NR<cr>
nnoremap  <silent><Leader>nw :NW<cr>

if  te#env#IsMac()
    let g:mkdp_path_to_chrome = 'open -a safari'
elseif te#env#IsWindows()
    let g:mkdp_path_to_chrome = 'C:\\Program Files (x86)\Google\Chrome\Application\chrome.exe'
else
    let g:mkdp_path_to_chrome = 'google-chrome'
endif
let g:vim_markdown_toc_autofit = 1
" Markdown preview in browser
nnoremap  <silent><leader>mp :MarkdownPreview<cr>
" generate markdown TOC
nnoremap  <silent><leader>mt :silent GenTocGFM<cr>
" update markdown TOC
nnoremap  <silent><leader>mu :silent UpdateToc<cr>
" Show toc sidebar
nnoremap  <silent><leader>ms :Toc<cr>

