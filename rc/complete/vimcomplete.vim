vim9script

Plug 'girishji/vimcomplete'
Plug 'girishji/autosuggest.vim'

var autosuggest_options = {
    search: {
            enable: true,   # 'false' will disable search completion
            pum: true,      # 'false' for flat menu, 'true' for stacked menu
            maxheight: 12,  # max height of stacked menu in lines
            fuzzy: false,   # fuzzy completion
            alwayson: true, # when 'false' press <tab> to open popup menu
        },
    cmd: {
            enable: true,   # 'false' will disable command completion
            pum: true,      # 'false' for flat menu, 'true' for stacked menu
            fuzzy: false,   # fuzzy completion
            exclude: [],    # patterns to exclude from command completion (use \c for ignorecase)
            onspace: [],    # show popup menu when cursor is in front of space (ex. :buffer<space>)
        }
}

var vimcomplete_options = {
    completor: { shuffleEqualPriority: true },
    buffer: { enable: true, priority: 10, urlComplete: true, envComplete: true },
    abbrev: { enable: true, priority: 10 },
    lsp: { enable: true, priority: 7, maxCount: 5 },
    omnifunc: { enable: false, priority: 8, filetypes: ['python', 'javascript'] },
    vsnip: { enable: false, priority: 9 },
    vimscript: { enable: true, priority: 11 },
    ngram: {
        enable: true,
        priority: 10,
        bigram: false,
        filetypes: ['text', 'help', 'markdown'],
        filetypesComments: ['c', 'cpp', 'python'],
    },
}

g:vimcomplete_tab_enable = 1

te#feat#register_vim_enter_setting("call g:VimCompleteOptionsSet(vimcomplete_options)")
te#feat#register_vim_enter_setting("call g:AutoSuggestSetup(vimcomplete_options)")
