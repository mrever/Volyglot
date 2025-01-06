command BQN normal :call BQN()<cr>:echo "m-q to execute BQN"<cr>

func! BQN()

nnoremap <silent> <m-q>      mPV"py:py3 voly.output()<cr>:redir @b<cr>:py3 bqn.bqn( _bqnfiltcode() )<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`P
inoremap <silent> <m-q> <esc>mPV"py:py3 voly.output()<cr>:redir @b<cr>:py3 bqn.bqn( _bqnfiltcode() )<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`Pa
vnoremap <silent> <m-q>       mP"py:py3 voly.output()<cr>:redir @b<cr>:py3 bqn.bqn( _bqnfiltcode() )<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`P

py3 << EOL

try:
    if '_blank' not in globals():
        class _blank: pass
        languagemgr = _blank()
        languagemgr.langlist  = []
        languagemgr.langevals = []
        languagemgr.langcompleters = []
    import bqn
    def _bqnfiltcode():
         return vim.eval("@p")

    def _bqneval(expr):
        try:
            _bqnexpr = bqn.bqn(expr)
            return _bqnexpr
        except Exception as e:
            return e

    languagemgr.langlist.append("bqn")
    languagemgr.langevals.append(_bqneval)

except:
    print('bqn not installed or working')

EOL
endfunc
