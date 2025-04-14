"" provide a way to execute vimscript from the buffer
""this works without python/volyglot
"nnoremap <silent> <m-enter> V"py:@p<cr>
"inoremap <silent> <m-enter> <esc>mPV"py:@p<cr>`Pa
"vnoremap <silent> <m-enter> mP"py:@p<cr>`P

command Vimscript normal :call Vimscript()<cr>:echo "m-enter to execute vimscript"<cr>

func! Vimscript()

""this requires python/volyglot, but has nicer output
nnoremap <silent> <m-enter>      mPV"py:py3 voly.output()<cr>:redir @b<cr>:@p<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b").replace('\r',''))<cr>`P
inoremap <silent> <m-enter> <esc>mPV"py:py3 voly.output()<cr>:redir @b<cr>:@p<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b").replace('\r',''))<cr>`Pa
vnoremap <silent> <m-enter>       mP"py:py3 voly.output()<cr>:redir @b<cr>:@p<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b").replace('\r',''))<cr>`P

endfunc
