" Help:Welcome screen, leader guide
" Package info {{{

Plug 'mhinz/vim-startify',{'commit': '5df5b7478c09991bd20ab50cc65023cda826b2bf'}
" }}}
" VimStartify {{{
if g:feat_enable_gui == 1 && g:enable_powerline_fonts.cur_val == 'on'
    if te#env#IsNvim() == 0
        if exists('*glyph_palette#apply')
            autocmd FileType startify call glyph_palette#apply()
        endif
    endif
    function! StartifyEntryFormat()
        if te#env#IsNvim() > 0
            return 'v:lua.require("nvim-web-devicons").get_icon(absolute_path, fnamemodify(absolute_path, ":e"), { "default":v:true }) ." ". entry_path'
        else
            if exists('*WebDevIconsGetFileTypeSymbol')
                return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
            endif
        endif
    endfunction
endif
if te#env#IsWindows()
    let g:startify_session_dir = $VIMFILES .'\sessions'
else
    let g:startify_session_dir = $VIMFILES .'/sessions'
endif
let g:startify_list_order = [
            \ 'commands',
            \ ['   These are my sessions:'],
            \ 'sessions',
            \ ['   My most recently used files in the current directory:'],
            \ 'dir',
            \ ['   My most recently used files:'],
            \ 'files',
            \ ]
let g:startify_change_to_dir = 1
let g:startify_files_number = 5 
let g:startify_change_to_vcs_root = 0
let g:startify_session_sort = 1
let g:startify_custom_header = []

let g:startify_session_savevars = [
            \ 'g:startify_session_savevars',
            \ 'g:startify_session_savecmds',
            \ 'g:vinux_coding_style.cur_val',
            \ 'g:vinux_project',
            \ ]

let g:startify_session_savecmds = [
            \ "call te#project#load_project(get(g:, 'vinux_project', {}))",
            \ ]

let g:startify_commands = [
            \ {'o': [g:vinux_version, 'call te#utils#open_url("https://github.com/tracyone/vinux")']},
            \ {'v': ['Open vimrc', 'call feedkeys("\<Space>vc")']},
            \ {'f': ['Find File', 'call feedkeys("\<Space>\<Space>")']},
            \ ]

" Open startify windows
nnoremap  <silent><Leader>hh :Startify<cr>
autocmd misc_group FileType startify setlocal buftype=
"}}}
"which-key {{{
if v:version >= 704 && te#env#IsDisplay()
    Plug 'liuchengxu/vim-which-key'
    function! s:which_key_setting()
        nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
        nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
        let g:which_key_map = {}
        let g:which_key_map.a = { 
                    \ 'name' : '+application',
                    \ 'a': 'Switch to c & cpp header',
                    \ 'p': 'Preview window',
                    \ 'c': 'Calculator',
                    \ 'd': 'Calendar',
                    \ 'e': 'Translate:zh2en',
                    \ 'l': 'easy align',
                    \ 'r': 'Enter screensaver',
                    \ 's': 'Open terminal win in vim in a split window',
                    \ 'T': 'Go to the current working directory in the Terminal',
                    \ 't': "Open terminal win in a tab window",
                    \ 'f': "Open terminal win in a floating window",
                    \ 'v': 'Open terminal win in a vertical split window',
                    \ 'w': 'toggle drawit plugin',
                    \ 'i': 'Artificial intelligence',
                    \ 'u': 'Translate from user input',
                    \ 'y': 'Translate en2ch or ch2en',
                    \ 'z': 'Translate:chinese pinyin',
                    \ 'g': 'Open game center',
                    \ }
        let g:which_key_map.b = { 
                    \ 'name' : '+buffer',
                    \ 'a': 'Delete all buffer',
                    \ 'd': 'Delete current buffer',
                    \ 'n': 'Switch to next buffer or tab',
                    \ 'p': 'Switch to previous buffer or tab',
                    \ 'o': 'Delete all buffer except current one',
                    \ }
        let g:which_key_map.c = { 
                    \ 'name' : '+Comment',
                    \ 'SPC': 'Comment toggle',
                    \ 'A': 'Commnet append',
                    \ 'a': 'Commnet alt delims',
                    \ 'c': 'Commnet',
                    \ 'l': 'Comment align left',
                    \ 'm': 'Comment minimal',
                    \ 'n': 'Comment nested',
                    \ 'p': 'Cd to selected plugin directory',
                    \ 's': 'Commnet sexy',
                    \ 'u': 'UnCommnet',
                    \ 'y': 'Comment and yank',
                    \ 'h': 'Check the vim health',
                    \ }
        let g:which_key_map.d = { 
                    \ 'name' : '+Do',
                    \ 'd': 'Ctrl-d in normal mode',
                    \ 'u': 'Ctrl-u in normal mode',
                    \ 'i': 'drawit start',
                    \ 's': 'drawit stop',
                    \ }
        let g:which_key_map.f = { 
                    \ 'name' : '+file_or_feature',
                    \ 'c' : "Go to the current file's directory",
                    \ 'd' : "Disable feature",
                    \ 'e' : "Enable feature",
                    \ 'f' : "Fuzzy search dir and file(not recursive)",
                    \ 'j' : 'Open vim Explorer',
                    \ 'R' : 'Open rename Explorer',
                    \ 'r' : 'reset feature.vim',
                    \ 's' : 'Save current file',
                    \ 'S' : 'Save all file',
                    \ 'u' : 'Generate feature.vim',
                    \ 'w' : 'Fuzzy search vim windows',
                    \ }
        let g:which_key_map.g = { 
                    \ 'name' : '+git',
                    \ 'A' : 'Archive vinux and move the archive to current dir',
                    \ 'a' : 'Git stage Hunk',
                    \ 'u' : 'Git undo Hunk',
                    \ 'b' : 'open Git blame window',
                    \ 'C' : 'Archive current git repo and move the archive to current dir',
                    \ 'c' : 'Cd to the root dir of git repo',
                    \ 'd' : 'git diff current file with previous verion',
                    \ 'e' : "Open git repo's config",
                    \ 'f' : "Git fetch all",
                    \ 'h' : "Open git url using default web browser",
                    \ 'i' : "Show git hunk",
                    \ 'l' : "Open git log window",
                    \ 'L' : "Open git log window with --all",
                    \ 'm' : "Merge and rebase with selected branch",
                    \ 'p' : "git push to selected branch ",
                    \ 's' : 'Open git status window',
                    \ 'g' : 'Gerrit push',
                    \ 'n' : "Show git commit message of current line",
                    \ }
        let g:which_key_map.h = { 
                    \ 'name' : '+help',
                    \ 'e' : 'Open vim eval.txt',
                    \ 'f' : 'Open vim function-list',
                    \ 'm' : 'Open manual of current cursor word',
                    \ 'p' : 'Open vim programming document',
                    \ 'h' : 'Open start screen',
                    \ 'v' : 'Fuzzy search vim help',
                    \ }
        let g:which_key_map.j = { 
                    \ 'name' : '+jump',
                    \ 'j' : 'easymotion:search 1 char',
                    \ 'l' : 'easymotion:Line downward and upward',
                    \ 's' : 'easymotion:search multiple previous char ',
                    \ 'w' : 'easymotion:word',
                    \ 't' : 'Start last close terminal win',
                    \ 'f' : 'Start a fuzzyfinder to select terminal win',
                    \ '0' : 'Open index 0 terminal win',
                    \ '1' : 'Open index 1 terminal win',
                    \ '2' : 'Open index 2 terminal win',
                    \ '3' : 'Open index 3 terminal win',
                    \ '4' : 'Open index 4 terminal win',
                    \ '5' : 'Open index 5 terminal win',
                    \ '6' : 'Open index 6 terminal win',
                    \ '7' : 'Open index 7 terminal win',
                    \ '8' : 'Open index 8 terminal win',
                    \ '9' : 'Open index 9 terminal win',
                    \ }
        let g:which_key_map.l = { 
                    \ 'name' : '+lsp',
                    \ 'o' : 'save your own vim setting',
                    \ 'c' : 'lsp code action',
                    \ 'd' : 'lsp goto declaration',
                    \ 'r' : 'lsp rename',
                    \ 'f' : 'lsp format',
                    \ 'i' : 'lsp find implementation',
                    \ 'y' : 'lsp find type definition',
                    \ 'l' : 'lsp code len',
                    \ 's' : 'lsp server install',
                    \ }
        let g:which_key_map.l.t = { 
                    \ 'name' : '+call tree',
                    \ 'i' : 'lsp in coming call',
                    \ 'o' : 'lsp out coming call',
                    \ }
        let g:which_key_map.m = { 
                    \ 'name' : '+bookmark_or_markdown',
                    \ '/' : 'Search next highlight',
                    \ '?' : 'Search previous highlight',
                    \ 'a' : 'Add bookmark',
                    \ 'b' : 'Show all bookmarks',
                    \ 'c' : 'Clear bookmark',
                    \ 'i' : 'Add bookmark with annotate',
                    \ 'j' : 'Move down curent line',
                    \ 'k' : 'Move up curent line',
                    \ 'm' : 'Mark current word',
                    \ 'n' : 'Clear current mark',
                    \ 'p' : 'Markdown preview',
                    \ 'r' : 'highlight words that match specified regex',
                    \ 's' : 'show Markdown toc',
                    \ 't' : 'gen Markdown toc',
                    \ }
        let g:which_key_map.n = { 
                    \ 'name' : '+nothing',
                    \ 'f' : 'nerdtree find',
                    \ 'l' : 'narrow vip',
                    \ 'm' : 'show avaliable linter',
                    \ 'q' : 'clear all highlight mark',
                    \ 'r' : 'Narrow',
                    \ 'w' : 'Narrow current visible window',
                    \ 'j' : 'Show list of running jobs',
                    \ }
        let g:which_key_map.o = { 
                    \ 'name' : '+Org_or_Open',
                    \ 'b' : 'org checkbox toggle',
                    \ 'c' : 'New org checkbox below',
                    \ 'd' : 'Org interactive',
                    \ 'l' : 'Open url',
                    \ 'n' : 'Org insert hyperlink',
                    \ 's' : 'Org insert timestamp',
                    \ 't' : 'Org todo',
                    \ 'u' : 'Org checkbox update',
                    \ 'w' : 'Org open index.org',
                    \ 'F' : 'open Files position',
                    \ 'f' : 'open Files position',
                    \ 'T' : 'open Files position in terminal',
                    \ }
        let g:which_key_map.p = { 
                    \ 'name' : '+FuzzySearcher_or_Plugin',
                    \ 'b' : 'Buffer',
                    \ 'c' : 'Colorscheme',
                    \ 'k' : 'Function',
                    \ 'l' : 'PluginList',
                    \ 'm' : 'Mru',
                    \ 'p' : 'File',
                    \ 'r' : 'Reg',
                    \ 's' : 'Plugin status',
                    \ 't' : 'tag',
                    \ 'u' : 'Plugin update',
                    \ 'w' : 'Show current directory',
                    \ }
        let g:which_key_map.q = { 
                    \ 'name' : '+quit_or_cmd_win',
                    \ '/' : 'Open Search history window',
                    \ 'a' : 'Quit all window',
                    \ 'c' : 'Open histor command line window',
                    \ 'f' : 'Open quickfix window',
                    \ 'l' : 'Open location list window',
                    \ 'A' : 'Quit all windows without confirm',
                    \ 'q' : 'Quit current window',
                    \ 's' : 'Quit all windows and save all',
                    \ 'w' : 'Close current tab',
                    \ }
        let g:which_key_map.r = { 
                    \ 'name' : '+Run',
                    \ 'c' :'Run command from user input',
                    \ 'e' :'Start repl for current filetype',
                    \ 'r' : 'Open ranger in floating window',
                    \ 'g' : 'Show git status using tig',
                    \ 'n' : 'LSP rename',
                    \ }
        let g:which_key_map.s = { 
                    \ 'name' : '+Show_or_session',
                    \ 'b' : 'Show all branch',
                    \ 'c' : 'Select dir in project',
                    \ 'd' : 'Delete session',
                    \ 'm' : 'Show message',
                    \ 'l' : 'Session load',
                    \ 'o' : 'Source vimrc',
                    \ 's' : 'Session save',
                    \ 't' : 'Show git tag',
                    \ 'e' : 'Edit project files',
                    \ 'p' : 'Fuzzy search snippets',
                    \ }
        let g:which_key_map.u = { 
                    \ 'name' : '+Update',
                    \ 'd' : 'Update vinux',
                    \ 'w' : 'Rename tmux window',
                    \ }
        let g:which_key_map.v = { 
                    \ 'name' : '+Vvvvv',
                    \ 'b' : 'Global search in exist buffer',
                    \ 'c' : 'Edit vimrc',
                    \ 'd' : 'Copy message from specified vim command',
                    \ 'f' : 'Global search function',
                    \ 'r' : 'Run command from user input',
                    \ 's' : 'Global search from user input',
                    \ 'v' : 'Global search current cursor word',
                    \ 'g' : 'Global search in current file',
                    \ }
        let g:which_key_map.w = { 
                    \ 'name' : '+Window',
                    \ ',' : 'Vertical resize window -10',
                    \ '.' : 'Vertical resize window +10',
                    \ '-' : 'Horizontal resize window -10',
                    \ '=' : 'Horizontal resize window +10',
                    \ '<Tab>' : 'Go to previous window',
                    \ 'c' : 'Choose win',
                    \ 'q' : 'Quit current window',
                    \ 'H' : 'Move the current window to be at the far left',
                    \ 'h' : 'Move the cursor to the left window',
                    \ 'J' : 'Move the current window to be at the very bottom',
                    \ 'j' : 'Move cursor to Nth window below current one',
                    \ 'K' : 'Move the current window to be at the very top',
                    \ 'k' : 'Move cursor to Nth window above current one',
                    \ 'L' : 'Move the current window to be at the far right',
                    \ 'l' : 'Move cursor to Nth window right of current one',
                    \ 'm' : 'Maximize window',
                    \ 'o' : 'Make the current window the only one on the screen',
                    \ 'R' : 'Rotate windows upwards/leftwards',
                    \ 'r' : 'Rotate windows downwards/rightwards',
                    \ 'S' : 'horizontal open window then focus the new one',
                    \ 's' : 'horizontal open window',
                    \ 't' : 'Move the current window to a new tab page',
                    \ 'V' : 'vertical open window then focus the new one',
                    \ 'v' : 'Vertical open window',
                    \ 'w' : 'switch between two windows',
                    \ }
        let g:which_key_map.y = { 
                    \ 'name' : '+Yank_or_ycm',
                    \ 'd' : 'Show ycm diags',
                    \ 'f' : 'Ycm fixit',
                    \ 'j' : 'Ycm goto to definition',
                    \ 'p' : 'Ycm get parent',
                    \ 'r' : 'Quickrun current file',
                    \ 's' : 'Ycm show detail diags',
                    \ 't' : 'Ycm get type',
                    \ 'u' : 'Update ycm',
                    \ }
        let g:which_key_map.z = { 
                    \ 'name' : '+Spell',
                    \ 'n' : 'Spell rotate forward',
                    \ 'p' : 'Spell rotate backward',
                    \ }
        let g:which_key_map.t = { 
                    \ 'name' : '+Toggle',
                    \ 'b' : 'Toggle background color',
                    \ 'c' : 'Toggle cursor option',
                    \ 'd' : 'Toggle fileformat between dos and unix',
                    \ 'e' : 'Toggle nerdtree window',
                    \ 'f' : 'Toggle fenc between utf-8 and cp936',
                    \ 'g' : 'Menu toggle',
                    \ 'h' : 'Toggle cursorword',
                    \ 'l' : 'Toggle termguicolors',
                    \ 'm' : 'Toggle mouse',
                    \ 'n' : 'Toggle number option',
                    \ 'o' : 'Toggle Goyo window',
                    \ 'p' : 'Toggle paste option',
                    \ 't' : 'Toggle tagbar window',
                    \ 'v' : 'Toggle focus window',
                    \ 'w' : 'Toggle unlimit textwidth option',
                    \ 'z' : 'Toggle spell option',
                    \ 'r' : 'send current line to terminal win',
                    \ 'a' : 'send all content  to terminal win',
                    \ }

        let g:which_key_map['<Tab>'] = 'switch to last open tab or buffer'

        let g:which_key_map.1 = 'Tab or buffer 1'
        let g:which_key_map.2 = 'Tab or buffer 2'
        let g:which_key_map.3 = 'Tab or buffer 3'
        let g:which_key_map.4 = 'Tab or buffer 4'
        let g:which_key_map.5 = 'Tab or buffer 5'
        let g:which_key_map.6 = 'Tab or buffer 6'
        let g:which_key_map.7 = 'Tab or buffer 7'
        let g:which_key_map.8 = 'Tab or buffer 8'
        let g:which_key_map.9 = 'Tab or buffer 9'
        let g:which_key_default_group_name = '+prefix'

        call which_key#register('<Space>', 'g:which_key_map')
    endfunction
    call te#feat#register_vim_enter_setting(function('<SID>which_key_setting'))
endif

"}}}
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
