"avoid source twice
if exists("b:did_vinux_ftplugin") 
    finish
endif
let b:did_vinux_ftplugin = 1
setloca nosmarttab
setloca tabstop=8
setloca softtabstop=8
setloca noexpandtab
