if te#env#IsNvim() >= 0.9 
    Plug 'mfussenegger/nvim-dap', {'on': []}
    Plug 'rcarriga/nvim-dap-ui', {'on': []}
    Plug 'jay-babu/mason-nvim-dap.nvim', {'on': []}
    Plug 'theHamsta/nvim-dap-virtual-text', {'on': []}
    call te#feat#register_vim_enter_setting2(['call te#feat#load_lua_modlue("nvim_dap")'],
                \ ['nvim-dap', 'nvim-dap-ui', 'mason-nvim-dap.nvim',
                \ 'nvim-dap-virtual-text'])
endif

if te#env#IsVim() >= 900 && te#env#SupportPy3()
    Plug 'puremourning/vimspector'
endif

if(te#env#IsLinux())
    Plug 'tracyone/pyclewn_linux',{'branch': 'pyclewn-1.11'}
endif

Plug 'thinca/vim-quickrun',{'on': '<Plug>(quickrun)'}

" Quickrun {{{
if te#env#SupportFloatingWindows() == 1
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'popup',
            \   },
            \}
else
let g:quickrun_config = {
            \   '_' : {
            \       'outputter' : 'quickfix',
            \   },
            \}
endif

let g:quickrun_no_default_key_mappings = 1
map  <silent><F6> <Plug>(quickrun)
vnoremap  <silent><F6> :'<,'>QuickRun<cr>
" run cunrrent file
nmap  <silent><leader>yr <Plug>(quickrun)
" run selection text
vnoremap  <silent><leader>yr :'<,'>QuickRun<cr>
" }}}
