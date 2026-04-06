
let s:provider_url_mapping = {
            \  'baidu': "https://qianfan.baidubce.com/v2/",
            \  'aliyun': "https://dashscope.aliyuncs.com/compatible-mode/v1/",
            \ }

function! te#ai#get_provider_url() abort
    return get(s:provider_url_mapping, te#ai#get_provider_name(), '')
endfunction

function! te#ai#get_provider_name() abort
    return te#feat#get_key_value('g:ai_provider_name', 'cur_val')
endfunction

function! te#ai#get_api_key() abort
    if filereadable($HOME.'/.config/'.te#ai#get_provider_name().'.token')
        return readfile($HOME.'/.config/'.te#ai#get_provider_name().'.token')[0]
    endif
endfunction

function! te#ai#get_model_name() abort
    return te#feat#get_key_value('g:ai_llm_model_name', 'cur_val')
endfunction

function! te#ai#get_llm_model_list() abort
    let l:llm_model_list = []
    if filereadable($HOME."/.config/llm_model.list")
        let l:llm_model_list = readfile($HOME."/.config/llm_model.list")
        let l:llm_model_list = filter(copy(l:llm_model_list), 'v:val !=# ""')
    endif
    if empty(l:llm_model_list)
        let l:llm_model_list = ['ernie-speed-128k']
    endif
    return l:llm_model_list
endfunction

function! te#ai#edit_ai_config(type) abort
    if a:type ==# 2
        if filereadable($HOME."/.config/llm_model.list")
            execute 'edit' $HOME."/.config/llm_model.list"
        else
            call te#utils#EchoWarning("llm_model.list not found, creating a new one with default model name.")
            call writefile([], $HOME."/.config/llm_model.list")
            execute 'edit' $HOME."/.config/llm_model.list"
        endif
    else
        if filereadable($HOME."/.config/".te#ai#get_provider_name().".token")
            execute 'edit' $HOME."/.config/".te#ai#get_provider_name().".token"
        else
            call te#utils#EchoWarning(te#ai#get_provider_name().".token not found, creating a new one with default model name.")
            call writefile([], $HOME."/.config/".te#ai#get_provider_name().".token")
            execute 'edit' $HOME."/.config/".te#ai#get_provider_name().".token"
        endif
    endif
endfunction
