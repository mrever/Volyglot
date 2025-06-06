command! R normal :call R()<cr>:echo "m-' to execute R"<cr>

func! R()

nnoremap <silent> <m-'>      mPV"py:py3 voly.output()<cr>:redir @b<cr>:py3 robjects.r( _rfiltcode() )<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`P
inoremap <silent> <m-'> <esc>mPV"py:py3 voly.output()<cr>:redir @b<cr>:py3 robjects.r( _rfiltcode() )<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`Pa
vnoremap <silent> <m-'>       mP"py:py3 voly.output()<cr>:redir @b<cr>:py3 robjects.r( _rfiltcode() )<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`P

py3 << EOL
try:
    if '_blank' not in globals():
        class _blank: pass
        languagemgr = _blank()
        languagemgr.langlist  = []
        languagemgr.langevals = []
        languagemgr.langcompleters = []
    import rpy2
    import rpy2.robjects as robjects
    def _rfiltcode():
        code = [q for q in vim.eval("@p").split('\n') if q and len(q)>0]
        return '\n'.join(code)
    def _revexpr(expr):
        from rpy2.robjects import conversion, default_converter
        with conversion.localconverter(default_converter):
            return robjects.r(expr)
    languagemgr.langlist.append("R")
    languagemgr.langevals.append(_revexpr)
except Exception as e:
    print("rpy2 not installed or working")
    #print(e)
EOL
endfunc
