"avoid source twice
if exists('b:did_vinux_ftplugin') 
    finish
endif
let b:did_vinux_ftplugin = 1

"nnoremap  <silent><buffer> K :call te#complete#lookup_doc()<cr>

"sudo pip3 install yapf
if te#env#Executable('yapf')
    nnoremap  <silent><buffer><leader>cf :0,$!yapf<CR>
    vnoremap  <silent><buffer><leader>cf :!yapf<CR>
elseif te#env#Executable('autopep8')
    nnoremap  <silent><buffer><leader>cf :%!autopep8 -<CR>
    vnoremap  <silent><buffer><leader>cf :!autopep8 -<CR>
else
    nnoremap  <silent><buffer><leader>cf :call te#utils#EchoWarning("Please install yapf or autopep8")<cr>
    vnoremap  <silent><buffer><leader>cf :call te#utils#EchoWarning("Please install yapf or autopep8")<cr>
endif
