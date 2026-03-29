
let s:provider_url_mapping = {
            \  'baidu': "https://qianfan.baidubce.com/v2/",
            \  'aliyun': "https://dashscope.aliyuncs.com/compatible-mode/v1/",
            \ }

function! te#ai#get_provider_url(provider_name) abort
    return get(s:provider_url_mapping, a:provider_name, '')
endfunction

function! te#ai#get_api_key() abort
    return readfile($HOME.'/.config/'.te#feat#get_key_value('g:ai_provider_name', 'cur_val').'.token')[0]
endfunction

function! te#ai#get_model_name() abort
    return te#feat#get_key_value('g:ai_llm_model_name', 'cur_val')
endfunction
