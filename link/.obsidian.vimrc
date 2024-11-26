" Yank to system clipboard
set clipboard=unnamedplus

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-i> :back
exmap forward obcommand app:go-forward
nmap <C-o> :forward
