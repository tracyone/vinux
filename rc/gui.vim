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
Plug 'liuchengxu/space-vim-dark'
Plug 'ayu-theme/ayu-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'srcery-colors/srcery-vim'
" }}}
"Gui releate{{{
if te#env#IsGui()
    try
        if (te#env#IsMac())
            set guifont=Consolas:h16
        elseif te#env#IsUnix()
            set guifont=Consolas\ 12
            set guifontwide=YaHei_Mono_Hybird_Consolas\ 12.5
        else
            set guioptions+=!
            if has("directx")
                set renderoptions=type:directx
            endif
            set guifont=Monaco:h12:cANSI
            set guifontwide=YaHei_Mono:h12.5:cGB2312
        endif
        if g:enable_powerline_fonts.cur_val ==# 'on'
            if te#env#IsMacVim()
                set guifont=YaHei\ Consolas\ Hybrid:h14
                set guifontwide=YaHei\ Consolas\ Hybrid:h14
            elseif te#env#IsUnix()
                set guifont=YaHei\ Consolas\ Hybrid\ 12
                set guifontwide=YaHei\ Consolas\ Hybrid\ 12
            else
                set guifont=Monaco:h12:cANSI
                set guifontwide=YaHei_Consolas_Hybrid:h12:cGB2312
            endif
        endif
    catch /^Vim\%((\a\+)\)\=:E/
        set guifontwide&
    endtry
    call te#feat#register_vim_enter_setting(function('te#tools#max_win'))
    " turn on this option as well
    set guioptions-=b
    set guioptions-=m "whether use menu
    set guioptions-=r "whether show the rigth scroll bar
    set guioptions-=l "whether show the left scroll bar
    set guioptions-=T "whether show toolbar or not
    set guioptions-=e "whether use tabpage
    set guioptions+=c
    set guioptions+=k "Keep the GUI window size when adding/removing a scrollbar
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
    nnoremap  <silent><c-F8> :call MenuToggle()<cr>
    " Menu and toolbar toggle(MacVIm and gvim)
    nnoremap  <silent><Leader>tg :call MenuToggle()<cr>
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
    "}}}
    call te#meta#map('map', 'o',':Fontzoom!<cr>')
    call te#meta#map('map','-','<Plug>(fontzoom-smaller)')
    call te#meta#map('map','=','<Plug>(fontzoom-larger)')
else
    set nocul
    set novb
    set t_vb=
    set t_ut=
    "highlight the screen line of the cursor
    set t_Co=256
endif

if te#env#IsGui() || te#env#SupportFloatingWindows()
    set mousemodel=popup_setpos
    if !te#env#IsGui()
        if te#env#IsTmux()
            amenu PopUp.&Paste <C-o>:call te#tmux#tmux2reg()<cr><C-o>p
        else
            amenu PopUp.&Paste "+p
        endif
    endif
    amenu PopUp.&====sep==== <Nop>
    amenu PopUp.&Undo :UndotreeToggle<CR>
    amenu PopUp.&Goto\ Definition :call te#complete#goto_def("")<cr>
    if g:grepper_plugin.cur_val ==# 'vim-easygrep'
        amenu PopUp.&Find\ Text :execute "normal "."\<Plug>EgMapGrepCurrentWord_V"<cr>
    else
        amenu PopUp.&Find\ Text :execute "normal "."\<Plug>\(neomakemp_global_search\)"<cr>
    endif
    amenu PopUp.&Open\ Header/Source :AT<cr>
    amenu PopUp.&Hightlight :execute "normal ". "\<Plug>MarkSet"<cr>
    amenu PopUp.&Translate :TranslateW<cr>
    amenu PopUp.&====sep===== <Nop>
endif

nnoremap  <silent><2-LeftMouse> :call te#complete#goto_def("")<cr>

"{{{colorscheme
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
if te#env#IsNvim()
    let g:neosolarized_italic = 0
    let g:jellybeans_use_term_italics = 0
    let g:jellybeans_use_gui_italics = 0
endif

let g:jellybeans_overrides = {
\    'background': { 'guibg': '000000' },
\    'StatusLine': {'guibg': '282828', 'guifg': 'c7c7c7', 'ctermbg': '235', 'ctermfg': '255'},
\    'StatusLineNC': {'guibg': '3a3a3a', 'guifg': '808080', 'ctermbg': '236', 'ctermfg': '244'},
\}
set background=dark
" toggle background option.
nnoremap  <silent><leader>tb :call te#utils#OptionToggle("bg",["dark","light"])<cr>
"}}}
"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
