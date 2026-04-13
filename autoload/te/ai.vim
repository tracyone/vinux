
let s:provider_url_mapping = {
            \  'baidu': "https://qianfan.baidubce.com/v2/",
            \  'aliyun': "https://dashscope.aliyuncs.com/compatible-mode/v1/",
            \  'ollama': "http://localhost:11434",
            \  'llama': "http://127.0.0.1:8080",
            \  'omlx': "http://127.0.0.1:8000/v1/",
            \ 'aw': "http://192.168.201.78:7001/v1/",
            \ }

" Get the API URL for the current provider
" Returns: The provider's base URL string
" Throws: None
function! te#ai#get_provider_url() abort
    return get(s:provider_url_mapping, te#ai#get_provider_name(), '')
endfunction

" Get the name of the current AI provider
" Returns: The provider name string
" Throws: None
function! te#ai#get_provider_name() abort
    return te#feat#get_key_value('g:ai_provider_name', 'cur_val')
endfunction

" Get the API key for the current provider
" Returns: The API key string or empty string if not found
" Throws: None
function! te#ai#get_api_key() abort
    if filereadable($HOME.'/.config/'.te#ai#get_provider_name().'.token')
        return readfile($HOME.'/.config/'.te#ai#get_provider_name().'.token')[0]
    endif
endfunction

" Get the name of the currently selected LLM model
" Returns: The model name string
" Throws: None
function! te#ai#get_model_name() abort
    return te#feat#get_key_value('g:ai_llm_model_name', 'cur_val')
endfunction

" Get the list of available LLM models from the config file
" Returns: A list of model names
" Throws: None
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

" Edit the AI configuration file
" Arguments:
"   a:type - 2 for model list, otherwise for provider token
" Returns: None
" Throws: None
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

function! te#ai#get_provider_name_list() abort
    return keys(s:provider_url_mapping)
endfunction
