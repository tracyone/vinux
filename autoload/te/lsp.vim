"lsp function wrapper

function! te#lsp#gotodefinion() abort
    if exists(':LspDefinition') == 2
        :LspDefinition
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

"format entire document
function! te#lsp#format_document() abort
    if exists(':LspDocumentFormatSync') == 2
        :LspDocumentFormatSync
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#format_document_range() abort
    if exists(':LspDocumentRangeFormat') == 2
        :LspDocumentRangeFormat
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#get_doc_symbol() abort
    if exists(':LspDocumentSymbol') == 2
        :LspDocumentSymbol
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#find_implementation() abort
    if exists(':LspImplementation') == 2
        :LspImplementation
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#find_implementation() abort
    if exists(':LspImplementation') == 2
        :LspImplementation
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#references() abort
    if exists(':LspReferences') == 2
        :LspReferences
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#rename() abort
    if exists(':LspRename') == 2
        :LspRename
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction

function! te#lsp#goto_type_def() abort
    if exists(':LspTypeDefinition') == 2
        :LspTypeDefinition
        return 0
    else
        call te#utils#EchoWarning('NOT support command!')
        return -1
    endif
endfunction
