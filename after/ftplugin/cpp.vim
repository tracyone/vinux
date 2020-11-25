if te#env#Executable('cppman')
    let g:manpager#man_executable='cppman'
endif
let g:clang_format#code_style='google'
let g:clang_format#style_options = {
            \ 'IndentWidth' : '4',
            \ 'UseTab' : 'Always',
            \ 'BreakBeforeBraces' : 'Linux',
            \ 'AllowShortIfStatementsOnASingleLine': 'false',
            \ 'AllowShortBlocksOnASingleLine': 'false',
            \ 'AllowShortCaseLabelsOnASingleLine': 'false',
            \ 'AllowShortFunctionsOnASingleLine': 'None',
            \ 'AllowShortLoopsOnASingleLine': 'false',
            \ 'IndentCaseLabels' : 'false'}
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
