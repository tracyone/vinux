function! s:delete_file()
    let l:lastline = line("'>")
    let l:curLine = line("'<")
    while l:curLine <= l:lastline
        call cursor(l:curLine, 1)
        let l:file = g:NERDTreeFileNode.GetSelected()
        if !empty(l:file)
            if !empty(l:file.path)
                if (confirm("Delete ".l:file.path.str(), "&Yes\n&No", 2)==1)
                    try 
                        call l:file.delete()
                    catch
                        call te#utils#EchoWarning("Delete ".l:file.path.str()." fail")
                    endtry
                endif
            endif
        endif
        let l:curLine += 1
    endwhile
    call l:file.parent.refresh()
    call NERDTreeRender()
endfunction

function! s:new_file()
    let curDirNode = g:NERDTreeDirNode.GetSelected()
    let l:newNodeName = input("Please input a new filename: ", "", 'file')

    if l:newNodeName ==# ''
        call te#utils#EchoWarning('Node Creation Aborted.')
        return
    endif

    let l:newNodeName =curDirNode.path.str().nerdtree#slash().l:newNodeName

    try
        let newPath = g:NERDTreePath.Create(l:newNodeName)
        let parentNode = b:NERDTree.root.findNode(newPath.getParent())

        let newTreeNode = g:NERDTreeFileNode.New(newPath, b:NERDTree)
        " Emptying g:NERDTreeOldSortOrder forces the sort to
        " recalculate the cached sortKey so nodes sort correctly.
        let g:NERDTreeOldSortOrder = []
        if empty(parentNode)
            call b:NERDTree.root.refresh()
            call b:NERDTree.render()
        elseif parentNode.isOpen || !empty(parentNode.children)
            call parentNode.addChild(newTreeNode, 1)
            call NERDTreeRender()
            call newTreeNode.putCursorHere(1, 0)
        endif

        redraw!
    catch /^NERDTree/
        call te#utils#EchoWarning("Create ".l:newNodeName." fail!")
    endtry
endfunction

nnoremap <buffer> dd :call <SID>delete_file()<cr>
xnoremap <buffer> dd :<c-u>:call <SID>delete_file()<cr>
nnoremap <buffer> N :call <SID>new_file()<cr>

