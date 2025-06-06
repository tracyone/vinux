" vim-airline
" powerline font: https://github.com/Magnetic2014/YaHei-Consolas-Hybrid-For-Powerline
scriptencoding utf-8
" Package info {{{
Plug 'vim-airline/vim-airline', {'on': []}
Plug 'vim-airline/vim-airline-themes'
" }}}
" Config {{{
let g:airline_extensions = []

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

if g:enable_powerline_fonts.cur_val ==# 'on'
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_powerline_fonts = 1
    let g:airline_symbols.maxlinenr = '☰'
    let g:airline_symbols.dirty='⚡'
    let g:airline_symbols.linenr = ' :'
    let g:airline_symbols.colnr = ' :'
else
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.maxlinenr = '㏑'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.colnr = ' ℅:'
endif
let g:airline_section_c_sep = ' | '
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.crypt = '🔒'
set noshowmode 


function! s:airline_setting()
    if te#env#check_requirement()
        let g:airline_extensions = ['tabline']
        if g:outline_plugin.cur_val == 'tagbar'
            let g:airline_section_x = "%{airline#util#prepend(tagbar#currenttag('%s', ''),0)}"
        elseif g:outline_plugin.cur_val == 'vista.vim'
            let g:airline_section_x = "%{airline#util#prepend(get(b:, 'vista_nearest_method_or_function', ''), 0)}"
        elseif g:outline_plugin.cur_val == 'aerial.nvim'
            let g:airline_section_x = "%{airline#util#prepend(v:lua.require'aerial_setup'.aerial_get_symbol(),0)}"
        else
            let g:airline_section_x = "%{airline#util#prepend(Tlist_Get_Tagname_By_Line(),0)}"
        endif
    else
        let g:airline_extensions = ['tabline']
    endif
    let g:airline_section_c="%t".g:airline_section_c_sep
    if te#env#SupportCscope()
        let g:airline_section_c.="cs["."%{cscope_connection()}"."]".g:airline_section_c_sep
    endif
    let g:airline_section_c.="%{te#pg#get_tags_number(g:airline_section_c_sep)}"

    if get(g:, 'feat_enable_git')
        if g:git_plugin_name.cur_val ==# 'vim-fugitive'
            call add(g:airline_extensions, 'fugitiveline')
            let g:airline#extensions#fugitiveline#enabled = 1
            let g:airline_section_b = airline#section#create_left([g:airline_symbols.branch.' '.fugitive#statusline()])
        endif
        if g:git_plugin_name.cur_val ==# 'gina.vim'
            call add(g:airline_extensions, 'gina')
            let g:airline#extensions#gina#enabled = 1
            let g:airline_section_b = airline#section#create_left([g:airline_symbols.branch.' '.gina#component#repo#branch()])
        endif
    endif
    if get(g:, 'feat_enable_lsp')
        let g:airline_section_warning = '%{te#lsp#diagnostics_info("warning")}'
        let g:airline_section_error = '%{te#lsp#diagnostics_info("error")}'
        let g:airline_section_c.="%{te#lsp#get_lsp_server_name(g:airline_section_c_sep)}"
    endif

    if g:feat_enable_complete == 1
        if g:complete_plugin_type.cur_val == 'YouCompleteMe'
            call add(g:airline_extensions, 'ycm')
        endif
    endif
    if g:feat_enable_jump
        if g:fuzzysearcher_plugin_name.cur_val == 'ctrlp' || !te#env#SupportFloatingWindows()
            call add(g:airline_extensions, g:fuzzysearcher_plugin_name.cur_val)
        endif
    endif
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
    let g:airline#extensions#tabline#show_tab_nr = 1
    if g:feat_enable_gui == 1 && g:enable_powerline_fonts.cur_val == 'on'
        if te#env#IsNvim() == 0
            if exists('*WebDevIconsGetFileTypeSymbol')
                let g:airline#extensions#tabline#formatter = 'webdevicons'
                call airline#add_statusline_func('AirlineWebDevIcons')
            endif
        endif
    else
        let g:airline#extensions#tabline#formatter = 'default'
    endif
    let g:airline#extensions#tabline#buffer_nr_show = 0
    let g:airline#extensions#tabline#fnametruncate = 16
    let g:airline#extensions#tabline#fnamecollapse = 2
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline#extensions#tabline#show_tab_type = 0
    let g:airline#extensions#tabline#fnamemod = ':p:t'
    let g:airline#extensions#hunks#enabled = 0
    let g:airline_detect_modified=1
    let g:airline_detect_paste=1
    let g:airline_detect_crypt=1
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#ycm#enabled = 0
    let g:airline#extensions#ctrlp#show_adjacent_modes = 1
    let g:airline_highlighting_cache = 1


    if te#env#SupportAsync()
        let g:airline_section_error .= ' '.airline#section#create_right(['%{neomakemp#run_status()}'])
    endif
    "let g:airline_section_warning='%{strftime("%m/%d\-%H:%M")}'
    "load extension here
    call airline#extensions#load()

    
    let l:theme_map = {'gruvbox8_hard':'gruvbox8', 'gruvbox8_soft':'gruvbox8', 
                \ 'space-vim-dark':'violet', 'space-nvim':'violet', 'jellybeans-nvim':'jellybeans',
                \ 'janah':'base16_grayscale'
                \ }
    if has_key(l:theme_map, g:colors_name)
        execute ':AirlineTheme '.l:theme_map[g:colors_name]
    else
        execute ':AirlineTheme '. g:colors_name
        if g:airline_theme != g:colors_name
            "default
            :AirlineTheme base16_google
        endif
    endif
    :AirlineRefresh
endfunction

call te#feat#register_vim_enter_setting2([function('<SID>airline_setting')], ['vim-airline'])
" }}}
