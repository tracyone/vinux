
if !has('patch-7.4.330') || !te#env#SupportAsync() || !te#env#SupportPy()
    call te#utils#EchoWarning('leaderf require python , patch-7.4.330 and async api support!', 1)
    let g:fuzzysearcher_plugin_name.cur_val='ctrlp'
    finish
endif
Plug 'Yggdroot/LeaderF'
Plug 'Yggdroot/LeaderF-marks',{'on': 'LeaderfMarks'}
" show global mark
nnoremap  <silent><leader>pm :LeaderfMarks<Cr>

"function
nnoremap  <silent><c-k> :LeaderfFunction<cr>
nnoremap  <silent><Leader>pk :LeaderfFunction<cr>
" buffer 
nnoremap  <silent><Leader>pb :LeaderfBuffer<Cr>
" recent file 
nnoremap  <silent><c-l> :LeaderfMru<cr>
nnoremap  <silent><Leader>pr :LeaderfMru<cr>
"file
nnoremap  <silent><Leader>pp :LeaderfFile<cr>
"leaderf cmd
nnoremap  <silent><Leader>ps :LeaderfSelf<cr>
nnoremap  <silent><Leader>pt :LeaderfBufTag<cr>
"colorsceme
nnoremap  <silent><Leader>pc :LeaderfColorscheme<cr>
nnoremap  <silent><Leader>ff :Leaderf dir<cr>
nnoremap  <silent><Leader>fe :Leaderf feat<cr>
nnoremap  <silent><Leader>fd :Leaderf feat<cr>
"CtrlP cmd
let g:Lf_ShortcutF = '<C-P>'
let g:Lf_ShortcutB = '<C-j>'
let g:Lf_CacheDiretory=$VIMFILES
let g:Lf_DefaultMode='FullPath'
let g:Lf_StlColorscheme = 'default'
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_UseMemoryCache = 0
let g:Lf_ReverseOrder = 1
let g:Lf_PreviewInPopup = 1
let g:Lf_WindowPosition ='popup'
nnoremap  <silent><Leader><Leader> :LeaderfFile<cr>
let g:Lf_Extensions = {
            \ 'dir': {
            \       'source': 'te#leaderf#dir#source',
            \       'accept': 'te#leaderf#dir#accept',
            \ 'need_exit': 'te#leaderf#dir#needExit',
            \       'supports_name_only': 1,
            \       'supports_multi': 0,
            \ },
            \ 'feat': {
            \       'source': "te#leaderf#feat#source",
            \       'accept': 'te#leaderf#feat#accept',
            \       'supports_name_only': 1,
            \       'supports_multi': 0,
            \ },
            \}
