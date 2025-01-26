vim9script

Plug 'girishji/vimcomplete'
Plug 'girishji/ngram-complete.vim', {'on':[] }
Plug 'girishji/vimsuggest', {'on':[] }

var autosuggest_options = {
    search: {
        enable: true,
        pum: true,
        fuzzy: true,
        alwayson: true,
        popupattrs: {
            'maxheight': 12
        },
        range: 100,
        timeout: 200,
        async: true,
        async_timeout: 3000,
        async_minlines: 1000,
        highlight: true,
        trigger: 't',
        prefixlen: 1,
    },
    cmd: {
            enable: true,   # 'false' will disable command completion
            pum: true,      # 'false' for flat menu, 'true' for stacked menu
            fuzzy: true,   # fuzzy completion
            exclude: [],    # patterns to exclude from command completion (use \c for ignorecase)
            onspace: ['b\%[uffer]', 'colo\%[rscheme]'],
            alwayson: true,
            popupattrs: {},
            wildignore: true,
            addons: true,
            trigger: 't',
            reverse: false,
            prefixlen: 1,
        }
}

var vimcomplete_options = {
    completor: { shuffleEqualPriority: true },
    buffer: { enable: true, priority: 10, urlComplete: true, envComplete: true },
    abbrev: { enable: true, priority: 10 },
    lsp: { enable: true, priority: 11, maxCount: 5 },
    omnifunc: { enable: false, priority: 8, filetypes: ['python', 'javascript'] },
    vsnip: { enable: false, priority: 9 },
    vimscript: { enable: true, priority: 10 },
    ngram: {
        enable: true,
        priority: 10,
        bigram: false,
        filetypes: ['text', 'help', 'markdown', 'gitcommit'],
        filetypesComments: ['c', 'cpp', 'python'],
    },
}

g:vimcomplete_tab_enable = 1

def VimCompletSetting()
    g:VimCompleteOptionsSet(vimcomplete_options)
enddef

def VimSuggestSetting()
    g:VimSuggestSetOptions(autosuggest_options)
    highlight VimSuggestMatch ctermfg=Green guifg=#00FF00
    highlight VimSuggestMute ctermfg=Gray guifg=#808080
enddef

g:complete_plugin.name = ['vimsuggest', 'ngram-complete.vim']
g:complete_plugin.enable_func = function('VimCompletSetting')

te#feat#register_vim_enter_setting2([function('VimSuggestSetting')], ['vimsuggest'])
