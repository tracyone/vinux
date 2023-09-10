"lsp function wrapper

function! te#lsp#is_server_running() abort
    if te#env#IsNvim() >= 0.5
        return v:lua.require('utils').is_lsp_running()
    else
        if exists("*lsp#get_server_status")
            let l:ret = 0
            let l:serve_name = lsp#get_allowed_servers()
            for l:needle in l:serve_name
                if stridx(lsp#get_server_status(l:needle), 'running') != -1
                    let l:ret += 1
                    break
                endif
            endfor
            return l:ret
        elseif g:complete_plugin_type.cur_val == 'coc.nvim'
            if exists("g:coc_extensions_dict")
                if has_key(g:coc_extensions_dict, &ft)
                    return 1
                endif
            return 0
        endif
    endif
    return 0
endfunction

function! te#lsp#get_lsp_server_name(sep) abort
    let l:str = ""
    if te#env#IsNvim() >= 0.5
        let l:str=v:lua.require('utils').get_client_name()
    else
        if exists("*lsp#get_server_status")
            let l:ret = 0
            let l:serve_name = lsp#get_allowed_servers()
            for l:needle in l:serve_name
                if stridx(lsp#get_server_status(l:needle), 'running') != -1
                    let l:str=l:needle
                    break
                endif
            endfor
        elseif g:complete_plugin_type.cur_val == 'coc.nvim'
            if te#lsp#is_server_running()
                let l:str = g:coc_extensions_dict[&ft]
            endif
        endif
    endif
    if !empty(l:str)
        let l:str='lsp['.l:str.']'.a:sep
    endif
    return l:str
endfunction

function! te#lsp#gotodefinion() abort
    if exists(':LspDefinition') == 2
        :LspDefinition
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.definition()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocActionAsync('jumpDefinition')
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
    return 0
endfunction

"format entire document
function! te#lsp#format_document() abort
    if exists(':LspDocumentFormatSync') == 2
        :LspDocumentFormatSync
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.range_formatting()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        execute 'normal '."\<Plug>(coc-format-selected)"
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
    return 0
endfunction

function! te#lsp#format_document_range() abort
    if exists(':LspDocumentRangeFormatSync') == 2
        :LspDocumentRangeFormatSync
        return 0
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocActionAsync('formatSelected', visualmode())
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#hover() abort
    if exists(':LspHover') == 2
        :LspHover
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.hover()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
        else
            call feedkeys('K', 'in')
        endif
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#find_implementation() abort
    if exists(':LspImplementation') == 2
        :LspImplementation
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.implementation()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocActionAsync('jumpImplementation')
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#references() abort
    if exists(':LspReferences') == 2
        :LspReferences
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.references()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocActionAsync('jumpReferences')
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
    return 0
endfunction

function! te#lsp#rename() abort
    if exists(':LspRename') == 2
        :LspRename
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.rename()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocActionAsync('rename')
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#goto_type_def() abort
    if exists(':LspTypeDefinition') == 2
        :LspTypeDefinition
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.type_definition()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocActionAsync('jumpTypeDefinition')
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#show_diagnostics(current_buffer)
    if te#lsp#is_server_running() == 1
        if exists(":LspDocumentDiagnostics") == 2 
            if a:current_buffer == 1
                :LspDocumentDiagnostics --buffers=*
            else
                :LspDocumentDiagnostics
            endif
        elseif g:complete_plugin_type.cur_val == 'coc.nvim'
            :CocDiagnostics
        endif
    else
        :botright lopen
    endif
endfunction

function! te#lsp#code_action() abort
    if exists(':LspCodeAction') == 2
        :LspCodeAction --ui=float
        return 0
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.buf.code_action()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocActionAsync('codeAction', 'currline')
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#call_tree(in) abort
    if a:in == 1
        if exists(':LspCallHierarchyIncoming') == 2
            :LspCallHierarchyIncoming
        elseif te#env#IsNvim() >= 0.5
            :lua vim.lsp.buf.incoming_calls()
        elseif g:complete_plugin_type.cur_val == 'coc.nvim'
            call CocActionAsync('showIncomingCalls')
        endif
    else
        if exists(':LspCallHierarchyOutgoing') == 2
            :LspCallHierarchyOutgoing
        elseif te#env#IsNvim() >= 0.5
            :lua vim.lsp.buf.outgoing_calls()
        elseif g:complete_plugin_type.cur_val == 'coc.nvim'
            call CocActionAsync('showOutgoingCalls')
        endif
    endif
endfunction

function! te#lsp#diagnostics_jump(direct) abort
    if a:direct == 0
        if exists(':LspPreviousDiagnostic') == 2
            :LspPreviousDiagnostic
        elseif te#env#IsNvim() >= 0.5
            :lua vim.diagnostic.goto_next()
        elseif g:complete_plugin_type.cur_val == 'coc.nvim'
            call CocActionAsync('diagnosticPrevious',     'error')
        endif
    else
        if exists(':LspNextDiagnostic') == 2
            :LspNextDiagnostic
        elseif te#env#IsNvim() >= 0.5
            :lua vim.diagnostic.goto_prev()
        elseif g:complete_plugin_type.cur_val == 'coc.nvim'
            call CocActionAsync('diagnosticNext',     'error')
        endif
    endif
endfunction

function! te#lsp#code_len() abort
    if exists(':LspCodeLens') == 2
        :LspCodeLens
    elseif te#env#IsNvim() >= 0.5
        :lua vim.lsp.codelens.run()
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        call CocActionAsync('codeLensAction')
    endif
endfunction

function! te#lsp#install_server() abort
    if exists(':LspInstallServer') == 2
        :LspInstallServer
    elseif te#env#IsNvim() >= 0.5
        :Mason
    elseif g:complete_plugin_type.cur_val == 'coc.nvim'
        :CocList marketplace
    endif
endfunction

function! te#lsp#diagnostics_info(type) abort
    let l:sign = (a:type == 'warning') ? '⚠ ': '✗'
    if exists('*lsp#get_buffer_diagnostics_counts')
        return l:sign.lsp#get_buffer_diagnostics_counts()[a:type]
    elseif te#env#IsNvim() >= 0.5
        if a:type == 'warning'
            return l:sign.len(v:lua.vim.diagnostic.get(0, { 'severity':2 }))
        else
            return l:sign.len(v:lua.vim.diagnostic.get(0, { 'severity':1 }))
        endif
    endif
endfunction
