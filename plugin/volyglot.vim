if has('python3')

let $PYPLUGPATH .= expand('<sfile>:p:h') "used to import .py files from plugin directory

command! Volyglot normal  :vsp<enter><c-w><c-l>:e ~/volybuff.py<cr>:call Volyglotload()<cr>:sp<cr>:e test.py<cr><c-w><c-h>:set filetype=python<cr>:echo "c-\\ to execute python, m-enter to execute vimscript"<cr>
command! VolyglotSelenium normal  :py3 voly.selenium_init()<cr>
command! VolyglotSeleniumOff normal  :py3 voly.selenium=False; voly.outhtml=False<cr>
command! VolyglotClear normal  :py3 voly.clearbuffhtml()<cr>
nnoremap <silent> <F10> :vsp<enter><c-w><c-l>:e ~/volybuff.py<cr>:call Volyglotload()<cr>:sp<cr>:e test.py<cr><c-w><c-h>:set filetype=python<cr>:echo "c-\\ to execute python"<cr>

func! Volyglotload()

let s:voly_cmd = ':py3 voly.output()<cr>:redir @b<cr>:py3 exec(voly.filtcode())<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>'
let s:maps = [{'key':'<F5>','pre':{'n':'mPggVG"py','i':'<esc>mPggVG"py','v':'mP<esc>ggVG"py'}},
            \ {'key':'<S-Enter>','pre':{'n':'mPV"py','i':'<esc>mPV"py','v':'mP"py'}},
            \ {'key':"<C-\\>",'pre':{'n':'mPV"py','i':'<esc>mPV"py','v':'mP"py'}}]
for m in s:maps
  for mode in keys(m.pre)
    let suf = mode ==# 'i' ? '`Pa' : '`P'
    execute printf('%snoremap <silent> %s %s%s%s', mode, m.key, m.pre[mode], s:voly_cmd, suf)
  endfor
endfor

nnoremap <silent> <c-b>      mPV"py:py3 voly.printexp()<cr>`P
inoremap <silent> <c-b> <esc>mPV"py:py3 voly.printexp()<cr>`Pa
vnoremap <silent> <c-b>       mP"py:py3 voly.printexp()<cr>`P
"alternate mappings for tmux users
nmap <m-b> <c-b>
imap <m-b> <c-b>
vmap <m-b> <c-b>

vnoremap <silent> <F1>       mP"py:py3 voly.output()<cr>:redir @b<cr>:py3 exec(f'help({_origfiltcode()})')<cr>:redir END<cr>:py3 voly.smartprint(vim.eval("@b"))<cr>`P

nnoremap <silent> <F8> mP{V}"py:py3 voly.readtable()<cr>`P
vnoremap <silent> <F8> mP"py:py3 voly.readtable()<cr>`P
"nmap <F9> <s-insert>V}<F8>gvx:py3 vim.current.buffer.append(repr(voly.table))<cr>j
nmap <F9> mpGo<cr><s-insert><esc>V{<F8>uu:py3 vim.current.buffer.append("arr = " + repr(voly.table))<cr>Gdd`pp

inoremap <c-u> <C-R>=Pycomplete()<CR>

func! Pycomplete()
    py3 vim.command("call complete(col('.'), " + repr(voly.get_completions()) + ')')
    return ''
endfunc

py3 __nvim__ = False
if has('nvim')
    py3 __nvim__ = True
endif

py3 << EOL
import vim
import sys
import os
import re
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

if '_blank' not in globals():
    class _blank: pass
    languagemgr = _blank()
    languagemgr.langlist  = []
    languagemgr.langevals = []
    languagemgr.langcompleters = []

# try to evaluate expressions for different languages
def pjeval(expr):
    voly.voly_errlist = []
    try: 
        return eval(expr)
    except Exception as e:
        excpt = e
        voly.voly_errlist.append(e)

    for langeval in languagemgr.langevals:
        try:
            val = langeval(expr)
        except Exception as e:
            excpt = e
            voly.voly_errlist.append(e)
            continue
        typeval = str(type(val)).lower()
        if 'error' in typeval or 'exception' in typeval:
            voly.voly_errlist.append(val)
        else:
            return val
    print(excpt)

if not hasattr(vim, 'find_module'):
    def _dumfun(*args, **kwargs): pass
    vim.find_module = _dumfun

sys.argv = ['']
sys.path.append('.') #might be needed to import from current directory
sys.path.append(os.environ['PYPLUGPATH']) # might be needed to import from plugin directory
#on Windows, this is needed for qt stuff like pyplot
os.environ['QT_QPA_PLATFORM_PLUGIN_PATH'] = sys.exec_prefix.replace('\\','/') + '/Library/plugins/platforms'

if os.getcwd().lower() == 'C:\\WINDOWS\\system32'.lower():
    os.chdir(os.path.expanduser('~'))


def _origfiltcode():
    voly.removeindent()
    code = [q for q in vim.eval("@p").split('\n') if q and len(q)>0]
    code = [q for q in code if q and len(q.strip())>0 and q.strip()[0]!='!']
    #try:
    parsedout = ('\n'.join(code))
    #except:
        #parsedout = ('\n'.join(code))
    return parsedout


class voly_outputter():
    def __init__(vyself):
        vyself.linecount = 1
        vyself.pybuf = vim.current.buffer
        vyself.pywin = vim.current.window
        vyself.oldlinecount = 0
        vyself.languages = ['python']
        vyself.languages += languagemgr.langlist
        vyself.voly_errlist = [] 
        # vyself.hometmp = os.path.expanduser('~') + '/tmp/'
        vyself.hometmp = '/tmp/volyfiles/'
        if not os.path.exists(vyself.hometmp):
            os.makedirs(vyself.hometmp)
        vyself.outhtml = False
        vyself.htmlbuff = []
        vyself.selenium = False
        vyself.coconut_On = False
        vyself.sage_On = False
        try:
            from completer import IPCompleter # requires IPython; will use simpler rlcompleter if not available
            vyself.icomplete = True
            vyself.pycompleter = IPCompleter(namespace=locals(),global_namespace=globals())
        except:
            vyself.icomplete = False
            import rlcompleter
            vyself.pycompleter = rlcompleter.Completer()
            print('loading rlcompleter')

    def output(vyself):
        vyself.pybuf.append('')
        vyself.pybuf.append('# In [' + str(vyself.linecount) + ']:')
        z = [q for q in vim.eval("@p").split('\n') if len(q)>0]
        [vyself.pybuf.append(l) for l in z]
        numlines = len(z)
        vyself.linecount += 1
        if numlines > 9:
            thiswin = vim.current.window
            for win in vim.current.tabpage.windows:
                if 'volybuff' in win.buffer.name:
                    vim.current.window = win
                    vim.command('normal G' + str(numlines-3)+'kV' +str(numlines-5)+'jzf')
            vim.current.window = thiswin
        thiswin = vim.current.window
        vyself.scrollbuffend()


    def mprint(vyself, *args, **kwargs):
        if 'sep' in kwargs.keys():
            sep = kwargs['sep']
        else:
            sep = ' '
        newlinecount = vyself.linecount-1
        outstr = ''
        for a in args:
            outstr += str(a) + sep
        if outstr:
            outstr = outstr[:-len(sep)]
        if newlinecount != vyself.oldlinecount:
            vyself.pybuf.append('') 
            vyself.pybuf.append('# Out [' + str(newlinecount) + ']:') 
        [vyself.pybuf.append(s) for s in outstr.split('\n')] 
        vyself.oldlinecount = vyself.linecount-1
        vyself.scrollbuffend()
        if vyself.outhtml:
            vyself.writebuffhtml(outstr.replace('<', '&lt').replace('>', '&gt'), shownum=True)

    # only prints string that has content (for displaying Python execution results)
    def smartprint(vyself, stringtoprint):
        procstr = stringtoprint.split('\n')
        for dumindex in range(4):
            for line in procstr:
                if not line:
                    procstr.remove('')
                else:
                    break
        if procstr:
            vyself.mprint('\n'.join(procstr))

    def printexp(vyself):
        vyself.pybuf.append('') 
        lines = vim.eval("@p").strip().split('\n')
        def prepnl(s):
            if '\n' in s:
                return '\n' + s
            else:
                return s
        for thisline in lines:
            thisexp = thisline.split('=')[0]
            try:
                if '==' in thisline or thisexp.count('(') > thisexp.count(')'):
                    thisexp = thisline
                if thisexp[-1] in '+-*/':
                    thisexp = thisexp[:-1]
                    if thisexp[-1] == '*':
                        thisexp = thisexp[:-1]
                outstring = prepnl(repr(pjeval(thisexp)))
                expout = thisexp.strip() + ' = ' + outstring
                [vyself.pybuf.append(exp) for exp in expout.split('\n')] 
                if vyself.outhtml:
                    vyself.writebuffhtml(expout.replace('<', '&lt').replace('>', '&gt'), shownum=True)
            except Exception as e1:
                try:
                    thisexp = thisline.replace('\n','')
                    outstring = prepnl(repr(pjeval(thisexp)))
                    expout = thisexp + ' = ' + outstring
                    [vyself.pybuf.append(exp) for exp in expout.split('\n')] 
                    if vyself.outhtml:
                        vyself.writebuffhtml(expout.replace('<', '&lt').replace('>', '&gt'), shownum=True)
                except Exception as e:
                    print(e)
                    [vyself.pybuf.append(thisexp.split('=')[0].strip() + " is not defined.")] 
            vyself.scrollbuffend()

    def scrollbuffend(vyself):
        thiswin = vim.current.window
        for win in vim.current.tabpage.windows:
            if 'volybuff' in win.buffer.name:
                vim.current.window = win
                vim.command('normal G')
        vim.current.window = thiswin

    def readtable(vyself, delim=' +'):
        try:
            table = vim.eval("@p")
            table = table.replace(',', ' ')
            table = ''.join([t for t in table if t.isdigit() or t.isspace() 
                                              or t=='-' or t=='.'])
            q = [re.split(delim, l) for l in table.split('\n') if len(l)>0]
            vyself.table = [[eval(y) for y in l if len(y)>0] for l in q] 
            return vyself.table
        except:
            pass

    def removeindent(vyself):
        code = vim.eval("@p").split('\n')
        code = [line for line in code if len(line)>0]
        minindent = 500
        for line in code:
            spaces = re.search('^ +' , line)
            if spaces:
                indent = len(spaces.group())
                if indent < minindent:
                    minindent = indent
            else:
                minindent = 0
                break
        code = '\n'.join([line[minindent:] for line in code])
        code = code.replace('\\', '\\\\')
        code = code.replace('\'', '\\\'')
        code = code.replace('\"', '\\\"')
        vim.command('let @p="' + code + '"')

    def selenium_init(vyself):
        from selenium import webdriver
        vyself.browser = webdriver.Chrome()
        vyself.refselenium()
        vyself.selenium = True
        vyself.outhtml = True

    def refselenium(vyself):
        vyself.browser.get(f'file:///C:{vyself.hometmp}volybuff.html')
        vyself.browser.execute_script( "window.scrollTo(0, document.body.scrollHeight);" )

    def writebuffhtml(vyself, string, br=2, shownum=False, pre=True):
        with open(vyself.hometmp + "volybuff.html", 'a', encoding='utf-8') as f:
            if shownum:
                string = 'Out [' + str(vyself.linecount) + ']: ' + string
                #string = 'Out [' + str(len(vyself.htmlbuff)+1) + ']: ' + string
            if pre:
                f.write('<pre>')
            f.write(string) #.replace('\n', '<br>'))
            if pre:
                f.write('</pre>')
            f.write('<br>'*br)
            vyself.htmlbuff.append(string)
        if vyself.selenium:
            vyself.refselenium()

    def clearbuffhtml(vyself, string=''):
        header = '<!DOCTYPE html>\n<html lang="en">\n<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css" integrity="sha384-zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq" crossorigin="anonymous">\n  <script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js" integrity="sha384-y23I5Q6l+B6vatafAwxRu/0oK/79VlbSz7Q9aiSZUvyWYIYsd+qj+o24G5ZU2zJz" crossorigin="anonymous"></script>\n  <script defer src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/contrib/auto-render.min.js" integrity="sha384-kWPLUVMOks5AQFrykwIup5lo0m3iMkkHrD0uJ4H5cjeGihAutqP0yW0J6dpFiVkI" crossorigin="anonymous" onload="renderMathInElement(document.body);"></script>\n        with'
        with open(vyself.hometmp + "volybuff.html", 'w') as f:
            f.write(header)
            f.write(string)
            if string:
                f.write('<br>'*5)
        if vyself.selenium:
            vyself.refselenium()

    def vimdebug(vyself):
        vim.debug = sys._getframe().f_back
        if '<module>' not in vim.debug.f_code.co_name:
            vim.oldglobals = list(globals().keys())
            for k in vim.debug.f_locals.keys():
                globals()[k] = vim.debug.f_locals[k]
            try:
                globals()['self_'] = vyself
            except:
                pass
        else:
            vim.oldglobals = None
        vim.command('normal ' + str(vim.debug.f_lineno) + 'gg')
        raise Exception('Debugging in "' + vim.debug.f_code.co_name + '" at line number   ' 
                            + str(vim.debug.f_lineno) )

    def endvimdebug(vyself):
        if vim.oldglobals:
            gkeys = list(globals().keys())
            for k in gkeys:
                if k not in vim.oldglobals:
                    globals().pop(k)

    def get_completions(vyself):
        pycompleter = vyself.pycompleter
        if vyself.icomplete:
            oldcursposy, oldcursposx = vim.current.window.cursor
            thisline = vim.current.line
            token = thisline[:oldcursposx]
            token = re.split(r';| |:|~|%|,|\+|-|\*|/|&|\||\(|\)=',token)[-1]
            completions = [token] 
            try:
                completions += pycompleter.all_completions(token)
            except:
                pass
            for lcompleter in languagemgr.langcompleters:
                completions += lcompleter()
            completions += []
            trunccomp = []
            for c in completions:
                if len(c) > len(token):
                    trunccomp.append(c[len(token):])
            return trunccomp
        else:
            oldcursposy, oldcursposx = vim.current.window.cursor
            thisline = vim.current.line
            token = thisline[:oldcursposx][::-1]
            if token[:2] == "'[":
                token = token[2:]
                getkeys = True
            else:
                getkeys = False
            try:
                stop = re.search('[^A-Za-z0-9_.]', token).start()
            except:
                stop = None
            thistoken = token[:stop][::-1]
            completions = [thistoken]
            if getkeys:
                try:
                    completions += list( eval(thistoken + '.keys()') )
                    completions = completions[1:]
                    completions = [c +"']" for c in completions]
                except:
                    pass
            else:
                cindex = 0
                comp = pycompleter.complete(thistoken,cindex)
                while comp != None:
                    completions.append(comp)
                    cindex += 1
                    comp = pycompleter.complete(thistoken,cindex)
                try:
                    completions += dir(eval(thistoken))
                    completions = list(set(completions))
                except:
                    pass
            for lcompleter in languagemgr.langcompleters:
                completions += lcompleter()
            trunccomp = []
            for c in completions:
                if len(c) > len(token):
                    trunccomp.append(c[len(token):])
            return trunccomp


def print(*args, **kwargs):
    voly.mprint(*args, **kwargs)
    vim.command('redraw')

voly = voly_outputter()
voly.filtcode = _origfiltcode
voly._printbak = print



EOL
endfunc "end Volyglotload

endif
