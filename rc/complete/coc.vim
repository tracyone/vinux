Plug 'neoclide/coc.nvim', {'on': [], 'branch': 'release'}


let g:coc_config_home = $VIMFILES.'/rc/complete/'

function! s:coc_setup() abort
    " code
    " Use tab for trigger completion with characters ahead and navigate
    " NOTE: There's always complete item selected by default, you may want to enable
    " no select by `"suggest.noselect": true` in your configuration file
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config
    inoremap <silent><expr> <TAB>
                \ coc#pum#visible() ? coc#pum#next(1) :
                \ CheckBackspace() ? "\<Tab>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion
    if has('nvim')
        inoremap <silent><expr> <c-space> coc#refresh()
    else
        inoremap <silent><expr> <c-@> coc#refresh()
    endif

    set updatetime=1500

    " Highlight the symbol and its references when holding the cursor
    autocmd misc_group CursorHold * silent call CocActionAsync('highlight')
    " Setup formatexpr specified filetype(s)
    autocmd filetype_group FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd misc_group User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')


    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Remap <C-f> and <C-b> to scroll float windows/popups
    if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif

    let g:coc_global_extensions = ['coc-marketplace', 'coc-json', 'coc-ultisnips']
    let g:coc_extensions_dict = {'json': 'coc-json'}
    if &ft == 'vim'
        call add(g:coc_global_extensions, 'coc-vimlsp')
        let g:coc_extensions_dict.vim = 'coc-vimlsp'
    elseif &ft == 'lua'
        call add(g:coc_global_extensions, 'coc-sumneko-lua')
        let g:coc_extensions_dict.lua = 'coc-sumneko-lua'
    elseif &ft == 'c' || &ft == 'cpp'
        call add(g:coc_global_extensions, 'coc-clangd')
        let g:coc_extensions_dict[&ft]='coc-clangd'
    elseif &ft == 'python'
        call add(g:coc_global_extensions, 'coc-pyright')
        let g:coc_extensions_dict.python = 'coc-pyright'
    elseif &ft =~ ".*sh$"
        call add(g:coc_global_extensions, 'coc-sh')
        let g:coc_extensions_dict[&ft]='coc-sh'
    endif

    " Add `:Format` command to format current buffer
    command! -nargs=0 Format :call CocActionAsync('format')

    " Add `:Fold` command to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer
    command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

    " Mappings for CoCList
    " Show all diagnostics
    "nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions
    "nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
    " Show commands
    "nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document
    "nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols
    "nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item
    "nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item
    "nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list
    "nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
endfunction

let g:complete_plugin.name = ['coc.nvim']
let g:complete_plugin.enable_func=function('<SID>coc_setup')
