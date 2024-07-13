unmap <Space>

" Have j and k navigate visual lines rather than logical ones

exmap lineStart cmcommand goLineLeftSmart

exmap lineEnd cmcommand goLineRight

vmap gh ^

vmap gl $

nmap gh ^

nmap gl $

" this map not work

imap jk <ESC><ESC>

nmap j gj

nmap k gk

nmap J 5j

nmap K 5k



" Quickly remove search highlights
nmap <a-n> :nohl
" Yank to system clipboard
set clipboard=unnamed


" Reload Obsidian
exmap reload obcommand app:reload
map <Space>r :reload


exmap nextTab obcommand workspace:next-tab
exmap prevTab obcommand workspace:previous-tab
map L :nextTab
map H :prevTab


exmap eft obcommand workspace:edit-file-title
nmap <Space>cf :eft


exmap easymotion obcommand mrj-jump-to-link:activate-jump-to-anywhere
map <Space>m :easymotion



exmap close obcommand workspace:close
map <Space>wc :close



exmap vs obcommand workspace:split-vertical
map <Space>wr :vs

exmap vhl obcommand workspace:split-horizontal
map <Space>wd :vhl


" close other tabs
exmap to obcommand workspace:close-others
map to :to


exmap df obcommand app:delete-file


exmap nextHeading jsfile mdHelpers.js {jumpHeading(true)}
exmap prevHeading jsfile mdHelpers.js {jumpHeading(false)}
nmap ]] :nextHeading
nmap [[ :prevHeading



exmap unfoldall obcommand editor:unfold-all

nmap zo :unfoldall



exmap foldall obcommand editor:fold-all
nmap zc :foldall



exmap it obcommand editor:open-link-in-new-split
nmap <Space>i :it



"""""""""""""""""""""""""""""""""""""""""""""""" "
"""""""""""" All Available Commands """""""""""" "
" :obcommand and <opt + cmd + i> to open console "
"""""""""""""""""""""""""""""""""""""""""""""""" "
