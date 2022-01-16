
if !has('patch-7.4.330') || !te#env#SupportAsync() || !te#env#SupportPy()
    call te#utils#EchoWarning('leaderf require python , patch-7.4.330 and async api support!', 1)
    let g:fuzzysearcher_plugin_name.cur_val='ctrlp'
    finish
endif
Plug 'Yggdroot/LeaderF',{'on': []}

function! s:leaderf_setting()
    " show global mark
    "nnoremap  <silent><leader>pm :LeaderfMarks<Cr>

    "function
    nnoremap  <silent><c-k> :LeaderfFunction<cr>
    nnoremap  <silent><Leader>pk :LeaderfFunction<cr>
    " buffer 
    nnoremap  <silent><Leader>pb :LeaderfBuffer<Cr>
    " recent file 
    nnoremap  <silent><c-l> :LeaderfMru<cr>
    nnoremap  <silent><Leader>pm :LeaderfMru<cr>
    "file
    nnoremap  <silent><Leader>pp :LeaderfFile<cr>
    "leaderf cmd
    nnoremap  <silent><Leader>ps :LeaderfSelf<cr>
    nnoremap  <silent><Leader>pt :LeaderfBufTag<cr>
    "colorsceme
    nnoremap  <silent><Leader>pc :LeaderfColorscheme<cr>
    nnoremap  <silent><Leader>ff :Leaderf dir<cr>
    nnoremap  <silent><Leader>fe :Leaderf feat -d 1<cr>
    nnoremap  <silent><Leader>fd :Leaderf feat -d 0<cr>
    nnoremap  <silent><Leader>ph :LeaderfHelp<cr>
    if te#env#Executable('rg')
        nnoremap  <silent><Leader>pf :Leaderf rg<cr>
    endif
    "CtrlP cmd
    let g:Lf_ShortcutF = '<C-P>'
    let g:Lf_ShortcutB = '<C-j>'
    let g:Lf_CacheDiretory=$VIMFILES
    let g:Lf_DefaultMode='FullPath'
    let g:Lf_StlColorscheme = 'default'
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
    let g:Lf_PreviewCode = 1
    let g:Lf_PreviewResult = {
            \ 'File': 1,
            \ 'Buffer': 1,
            \ 'Mru': 1,
            \ 'Tag': 1,
            \ 'BufTag': 1,
            \ 'Function': 1,
            \ 'Line': 0,
            \ 'Colorscheme': 1,
            \ 'dir': 1,
            \ 'term': 1,
            \ 'Rg': 1,
            \ 'Gtags': 0,
            \}
    let g:Lf_UseMemoryCache = 0
    let g:Lf_ReverseOrder = 1
    if te#env#SupportFloatingWindows()
        let g:Lf_WindowPosition ='popup'
        let g:Lf_PreviewInPopup = 1
        let g:Lf_PopupPreviewPosition = 'bottom'
        "let g:Lf_PreviewPopupWidth = &columns * 4 / 10
        "let g:Lf_PreviewPopupWidth = &columns * 4 / 10
        let g:Lf_PopupWidth = &columns * 8 / 10
        let g:Lf_PopupHeight = &lines * 4 / 10
        let g:Lf_PopupShowStatusline = 0
        let g:Lf_PreviewHorizontalPosition = 'right'
        "let g:Lf_PopupPosition= 
    endif
    let g:Lf_ShowDevIcons = 0
    nnoremap  <silent><Leader><Leader> :LeaderfFile<cr>
    if !exists("g:Lf_Extensions")
        let g:Lf_Extensions = {}
    endif
    let g:Lf_Extensions.dir = {
                    \       'source': 'te#leaderf#dir#source',
                    \       'accept': 'te#leaderf#dir#accept',
                    \ 'need_exit': 'te#leaderf#dir#needExit',
                    \ 'preview': 'te#leaderf#dir#preview',
                    \       'supports_name_only': 1,
                    \       'supports_multi': 0,
                    \ }
    let g:Lf_Extensions.feat = {
                    \       'source': "te#leaderf#feat#source",
                    \       'accept': 'te#leaderf#feat#accept',
                    \       'arguments': [ { "name": ["-d"], "nargs": 1}],
                    \       'supports_name_only': 1,
                    \       'supports_multi': 0,
                    \ }
    let g:Lf_Extensions.term = {
                    \       'source': "te#leaderf#terminal#source",
                    \       'accept': 'te#leaderf#terminal#accept',
                    \ 'preview': 'te#leaderf#terminal#preview',
                    \       'arguments': [ { "name": ["-d"], "nargs": 1}],
                    \       'supports_name_only': 1,
                    \       'supports_multi': 0,
                    \}
endfunction

call te#feat#register_vim_enter_setting2([function('<SID>leaderf_setting')], ['LeaderF'])
