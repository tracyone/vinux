" Gui:colorscheme,menu,font...
" Package Info {{{
if te#env#IsGui()
    Plug 'thinca/vim-fontzoom',{'on': ['<Plug>(fontzoom-smaller)', '<Plug>(fontzoom-larger)'] }
endif
"some awesome vim colour themes
Plug 'sjl/badwolf'
Plug 'iCyMind/NeoSolarized'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'nanotech/jellybeans.vim'
Plug 'vim-scripts/desert256.vim'
" }}}
"Gui releate{{{
if te#env#IsGui()
    if (te#env#IsMac())
        set guifont=Consolas:h16
    elseif te#env#IsUnix()
        set guifont=Consolas\ 12
        set guifontwide=YaHei_Mono_Hybird_Consolas\ 12.5
    else
        set guifont=Monaco:h12:cANSI
        set guifontwide=YaHei_Mono:h12.5:cGB2312
    endif
    if !te#env#IsMacVim()
        if g:airline_powerline_fonts == 1 && g:feat_enable_airline == 1
            set guifontwide=YaHei\ Consolas\ Hybrid\ 12
        endif
    endif
    au misc_group GUIEnter * call s:MaximizeWindow()
    " turn on this option as well
    set guioptions-=b
    set guioptions-=m "whether use menu
    set guioptions-=r "whether show the rigth scroll bar
    set guioptions-=l "whether show the left scroll bar
    set guioptions-=T "whether show toolbar or not
    "highlight the screen line of the cursor
    func! MenuToggle()
        if &guioptions =~# '\a*[mT]\a*[mT]'
            :set guioptions-=T
            :set guioptions-=m
        else
            :set guioptions+=m
            :set guioptions+=T
        endif
    endfunc
    :call MenuToggle()
    nnoremap <c-F8> :call MenuToggle()<cr>
    " Menu and toolbar toggle(MacVIm and gvim)
    nnoremap <Leader>tg :call MenuToggle()<cr>
    set cul
    "toolbar ----------------- {{{
    if has('toolbar')
        if exists('*Do_toolbar_tmenu')
            delfun Do_toolbar_tmenu
        endif
        fun Do_toolbar_tmenu()
            tmenu ToolBar.Open		Open File
            tmenu ToolBar.Save		Save File
            tmenu ToolBar.SaveAll	Save All
            tmenu ToolBar.Print		Print
            tmenu ToolBar.Undo		Undo
            tmenu ToolBar.Redo		Redo
            tmenu ToolBar.Cut		Cut
            tmenu ToolBar.Copy		Copy
            tmenu ToolBar.Paste		Paste
            tmenu ToolBar.Find		Find&Replace
            tmenu ToolBar.FindNext	Find Next
            tmenu ToolBar.FindPrev	Find Prev
            tmenu ToolBar.Replace	Replace
            tmenu ToolBar.LoadSesn	Load Session
            tmenu ToolBar.SaveSesn	Save Session
            tmenu ToolBar.RunScript	Run a Vim Script
            tmenu ToolBar.Make		Make
            tmenu ToolBar.Shell		Shell
            tmenu ToolBar.RunCtags	ctags! -R
            tmenu ToolBar.TagJump	Jump to next tag
            tmenu ToolBar.Help		Help
            tmenu ToolBar.FindHelp	Search Help
        endfun
    endif
    "}}}
    "mouse ------------------- {{{
    " Set up the gui cursor to look nice
    set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
    amenu PopUp.-SEP3-	<Nop>
    ""extend", "popup" or "popup_setpos"; what the right
    set mousemodel=popup_setpos
    amenu PopUp.&Undo :UndotreeToggle<CR>
    amenu PopUp.&Goto\ Definition :cs find g <C-R>=expand("<cword>")<CR><CR>
    amenu PopUp.&Find\ Text :silent! execute "vimgrep " . expand("<cword>") . " **/*.[ch]". " **/*.cpp" . " **/*.cc"<cr>:cw 5<cr>
    amenu PopUp.&Open\ Header/Source :AT<cr>
    "}}}
    function! s:MaximizeWindow()
        if te#env#IsUnix()
            :win 1999 1999
            silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
        elseif te#env#IsWindows()
            :simalt~x "maximize window
        else
            :win 1999 1999
        endif
        ":set vb t_vb=
    endfunction
    call TracyoneAltMap('map', 'o',':Fontzoom!<cr>')
    call TracyoneAltMap('map','-','<Plug>(fontzoom-smaller)')
    call TracyoneAltMap('map','=','<Plug>(fontzoom-larger)')
else
    set nocul
    set novb
    set t_vb=
    set t_ut=
    "highlight the screen line of the cursor
    set t_Co=256
endif

"{{{colorscheme
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
if te#env#IsNvim()
    let g:neosolarized_italic = 0
    let g:jellybeans_use_term_italics = 0
    let g:jellybeans_use_gui_italics = 0
endif
set background=dark
try 
    colorscheme PaperColor "default setting 
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert "default setting 
endtry
" toggle background option.
nnoremap <leader>tb :call te#utils#OptionToggle("bg",["dark","light"])<cr>
"}}}
"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
