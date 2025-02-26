if !has('patch-8.1.2114') && !has('nvim-0.4')
    call te#utils#EchoWarning('vim-clap.vim require vim with patch-8.1.2114 or nvim-0.4!')
    let g:fuzzysearcher_plugin_name.cur_val='ctrlp'
    finish
endif
Plug 'liuchengxu/vim-clap', {'on':'Clap','do': ':Clap install-binary' }


function! s:vim_clap_settings() abort
    nnoremap  <silent><c-k> :Clap tags<cr>
    nnoremap  \ :Clap blines<cr>
    nnoremap  <silent><c-j> :Clap buffers<Cr>
    " buffer 
    nnoremap  <silent><Leader>pb :Clap buffers<Cr>
    "nnoremap  <silent><c-l> :CtrlPMRUFiles<cr>
    "CtrlP mru
    nnoremap  <silent><Leader>pm :Clap history<Cr>
    nnoremap  <silent><c-l> :Clap history<Cr>
    "File
    nnoremap  <silent><Leader>pp :Clap files<cr>
    " narrow the list down with a word under cursor
    "CtrlP colorsceme
    nnoremap  <silent><Leader>pc :Clap colors<cr>
    "CtrlP function
    nnoremap  <silent><Leader>pk :Clap tags<cr>
    nnoremap  <silent><Leader>ff :Clap filer<cr>
    "CtrlP cmd
    nnoremap  <silent><Leader><Leader> :Clap files<cr>
    "spacemacs :SPC ff
    "nnoremap  <silent><Leader>ff :call te#ctrlp#dir#start()<cr>
    "CtrlP git branch
    "nnoremap  <silent><Leader>pgb :call te#ctrlp#git#start(1)<cr>
    "CtrlP git show diff of specified commit
    nnoremap  <silent><Leader>pgl :Clap commits<cr>
    "CtrlP git log checkout
    "nnoremap  <silent><Leader>pgc :call te#ctrlp#git#start(3)<cr>
    "CtrlP git remote branch
    "nnoremap  <silent><Leader>pgr :call te#ctrlp#git#start(4)<cr>
    "vim help
    nnoremap  <silent><Leader>hv :Clap help_tags<cr>
    "nnoremap  <silent><Leader>fe :call te#ctrlp#feat#start(1)<cr>
    "nnoremap  <silent><Leader>fd :call te#ctrlp#feat#start(0)<cr>

    nnoremap  <silent><Leader>qc :Clap hist:<cr>
    "nnoremap  <silent><Leader>q/ :call te#ctrlp#history#start('/')<cr>
    nnoremap  <silent><Leader>pf :Clap live_grep<cr>
    nnoremap  <silent><Leader>pr :Clap registers<cr>

    "feature enable
    nnoremap  <silent><Leader>fe  :call te#clap#feat#start(1)<cr>
    "feature disable
    nnoremap  <silent><Leader>fd  :call te#clap#feat#start(0)<cr>

    let g:clap_popup_move_manager = {
                \ "\<C-z>": "\<Tab>",
                \ }

    if te#env#IsNvim() != 0
        let g:clap_cache_directory = stdpath('cache').'/clap'
    elseif exists('$XDG_CACHE_HOME')
        let g:clap_cache_directory = $XDG_CACHE_HOME.'/clap'
    else
        let g:clap_cache_directory = $HOME.'/.cache/clap'
    endif

    "atom_dark.vim  material_design_dark.vim  nord.vim  onehalfdark.vim  onehalflight.vim  solarized_dark.vim  solarized_light.vim
    let g:clap_theme = 'atom_dark'
endfunction

call te#feat#register_vim_enter_setting2([function('<SID>vim_clap_settings')], ['vim-clap'])
