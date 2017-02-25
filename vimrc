"File       vimrc 
"Brief      config file for neovim,vim,gvim in linux,gvim in win32,macvim
"Date       2015-11-28/22:56:20
"Author     tracyone,tracyone@live.cn,
"Github     https://github.com/tracyone/t-vim
"Website    http://onetracy.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if te#env#IsWindows()
    let $HOME=$VIM
    let $VIMFILES = $VIM.'/vimfiles'
else
    let $VIMFILES = $HOME.'/.vim'
endif

function! s:source_rc(path, ...) abort "{{{
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = resolve(expand($VIMFILES.'/rc/' . a:path))
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let content = map(readfile(abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    execute 'source' fnameescape(tempfile)
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction

function! s:set(var, default) abort
  if !exists(a:var)
    if type(a:default)
      execute 'let' a:var '=' string(a:default)
    else
      execute 'let' a:var '=' a:default
    endif
  endif
endfunction
"}}}

call s:source_rc('autocmd.vim')
call s:source_rc('options.vim')
call s:source_rc('mappings.vim')

if filereadable($VIMFILES.'/module.vim')
    execute ':source '.$VIMFILES.'/module.vim'
endif

call s:set('g:complete_plugin_type','ycm')
call s:set('g:feat_enable_complete', 0)
call s:set('g:feat_enable_vim_develop', 0)
call s:set('g:feat_enable_jump', 1)
call s:set('g:feat_enable_tmux', 0)
call s:set('g:feat_enable_git', 0)
call s:set('g:feat_enable_lang_c', 0)
call s:set('g:feat_enable_lang_markdown', 0)
call s:set('g:feat_enable_lang_vim', 0)
call s:set('g:feat_enable_awesome_gui', 0)
call s:set('g:feat_enable_tools', 0)
call s:set('g:feat_enable_edit', 0)
call s:set('g:feat_enable_frontend', 0)
call s:set('g:feat_enable_basic', 1)

" Vim-plug ------------------------{{{
let &rtp=&rtp.','.$VIMFILES
if empty(glob($VIMFILES.'/autoload/plug.vim'))
    if te#env#IsWindows()
        silent! exec ':!mkdir -p '.$VIMFILES.'\\autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'\\autoload'.'\\plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        silent! exec ':!mkdir -p '.$VIMFILES.'/autoload'
        silent! exec ':!curl -fLo ' . $VIMFILES.'/autoload'.'/plug.vim ' .
                    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endif
call plug#begin($VIMFILES.'/bundle')

if g:feat_enable_complete == 1
    call s:source_rc('complete.vim')
endif

if g:feat_enable_jump == 1
    call s:source_rc('jump.vim')
endif

if g:feat_enable_lang_vim == 1
    call s:source_rc('vim.vim')
endif

if g:feat_enable_git == 1
    call s:source_rc('git.vim')
endif

if g:feat_enable_lang_markdown == 1
    call s:source_rc('markdown.vim')
endif

if g:feat_enable_lang_c == 1
    call s:source_rc('c.vim')
endif

if g:feat_enable_awesome_gui == 1
    call s:source_rc('gui.vim')
endif

if g:feat_enable_tools == 1
    call s:source_rc('tools.vim')
endif

if g:feat_enable_frontend == 1
    call s:source_rc('frontend.vim')
endif

if g:feat_enable_basic == 1
    call s:source_rc('basic.vim')
endif

if g:feat_enable_edit == 1
    call s:source_rc('edit.vim')
endif
" Open plug status windows
nnoremap <Leader>ap :PlugStatus<cr>:only<cr>
call plug#end()
autocmd misc_group VimEnter *
            \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \|   echom '[t-vim]Need to install the missing plugins!'
            \|   PlugInstall --sync | q
            \| endif

filetype plugin indent on
syntax on
set modeline
" vim: set fdm=marker foldlevel=0 foldmarker& filetype=vim: 
