let g:ollama_enabled = v:true
let g:ollama_use_venv = 0

let $OPENAI_API_KEY = te#ai#get_api_key()
let g:ollama_openai_credentialname = te#ai#get_api_key()

let g:ollama_model_provider = 'openai'
let g:ollama_chat_provider = 'openai'
let g:ollama_edit_provider = 'openai'

" API url
let g:ollama_openai_baseurl = te#ai#get_provider_url(te#feat#get_key_value('g:ai_provider_name', 'cur_val'))

" model select
let g:ollama_model = te#ai#get_model_name()
let g:ollama_chat_model = te#ai#get_model_name()
let g:ollama_edit_model = te#ai#get_model_name()

"let g:ollama_context_lines = 10                 " 减少上下文提高速度
let g:ollama_debounce_time = 800                " 增加防抖时间
let g:ollama_chat_timeout = 30                  " 增加超时时间

"let g:ollama_model_options = {
    "\ 'temperature': 0.1,
    "\ 'top_p': 0.95,
    "\ 'max_tokens': 512
    "\ }

" debug
"let g:ollama_debug = 3
"let g:ollama_logfile = '/tmp/vim-ollama.log'

let g:ollama_no_maps = v:true
let g:ollama_no_tab_map = v:true
let g:ollama_split_vertically = 0
inoremap <c-a> <Plug>(ollama-tab-completion)
inoremap <c-]> <Plug>(ollama-insert-word)
inoremap <c-l> <Plug>(ollama-insert-line)
