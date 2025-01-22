command Julia normal :call Julia()<cr>:echo "m-\\ to execute julia"<cr>

func! Julia()

nnoremap <silent> <m-\>      mPV"py:py3 voly.output()<cr>:redir @b<cr>:py3 _jeval(_juliafiltcode())<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`P
inoremap <silent> <m-\> <esc>mPV"py:py3 voly.output()<cr>:redir @b<cr>:py3 _jeval(_juliafiltcode())<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`Pa
vnoremap <silent> <m-\>       mP"py:py3 voly.output()<cr>:redir @b<cr>:py3 _jeval(_juliafiltcode())<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`P

py3 << EOL
try:
    if '_blank' not in globals():
        class _blank: pass
        languagemgr = _blank()
        languagemgr.langlist  = []
        languagemgr.langevals = []
        languagemgr.langcompleters = []
    import vim
    from julia import Main as _julmain

    nprint = '''
    import Base.print
    import Base.println
    pyoutstr = ""
    function apptxtout(txt)
    global pyoutstr *= string(txt)
    end
    function print(txt, args...; kwargs...)
    apptxtout(txt)
    for arg in args
    apptxtout(arg)
    end
    pyoutstr
    end
    function println(txt, args...; kwargs...)
    apptxtout(txt)
    for arg in args
    apptxtout(arg)
    end
    apptxtout("\n")
    pyoutstr
    end
    using REPL
    '''

    _julmain.eval(nprint)
    def _resjprint():
        _julmain.eval('pyoutstr = ""')
    _resjprint()

    def _jeval(jcode):
        _resjprint()
        julout = _julmain.eval(jcode)
        out = _julmain.eval('print("")')
        print(out)
        return julout

    def _juliafiltcode():
        code = [q for q in vim.eval("@p").split('\n') if q and len(q)>0]
        return '\n'.join(code)

    def _juliacompleter(token=None):
        oldcursposy, oldcursposx = vim.current.window.cursor
        thisline = vim.current.line
        #if not token:
        token = thisline[:oldcursposx]
        token = re.split(r';| |:|~|%|,|\+|-|\*|/|&|\||\(|\)=',token)[-1]
        completions = [] 
        try:
            jcompstr = 'jcompletions = REPL.REPLCompletions.completions("' + token +  '", ' + str(len(token)) + '); [string(jcompletions[1][i].mod) for i = 1:length(jcompletions[1])  ]'
            jcomps = _julmain.eval(jcompstr)
            if token[-1] == '.':
                jcomps = [token + jc for jc in jcomps]
            completions += jcomps
            return completions
        except Exception as e:
            return []

    languagemgr.langlist.append("julia")
    languagemgr.langevals.append(_jeval)
    languagemgr.langcompleters.append(_juliacompleter)

except Exception as e:
    print('julia bridge not installed or working')
    #print(e)
EOL
endfunc
