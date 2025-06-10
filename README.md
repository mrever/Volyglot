# Volyglot
## Use Vim as a Jupyter-like shell for Python and other languages

Volyglot -- Vim + polyglot    \(***Speaking, writing, written in, or composed of several languages***\)

[![asciicast](https://asciinema.org/a/NI3ba7dOjtYsevfDWCm6lQwxB.svg)](https://asciinema.org/a/NI3ba7dOjtYsevfDWCm6lQwxB)

*Features:*

-Executes Python files, individual lines, or blocks (via visual mode) within the Vim/Neovim editor  
-Displays the output in a separate buffer/window  
-Can inspect variable/expression values  
-Set breakpoints within functions etc. and inspect local variables  
-Completions (via IPython if available, else rlcompleter)  
-Supports Python language extensions [Coconut](http://coconut-lang.org/) and [SageMath](https://www.sagemath.org/), as well as [Hy](https://docs.hylang.org/en/alpha/)
-Other languages supported: Vimscript, Lua, Ruby, Julia, R, JavaScript (via js2py), and Wolfram Language

Install via your favorite plug-in manager (vim-plug, pathogen.vim, Vundle, etc.)

Requirements:

-Vim (gVim, neovim) with Python3 build; ' :echo has("python3") ' must return 1 (Python required for all languages)

Others:
-Vimscript -- works if the above works
-Lua -- automatic for neovim, :echo has("lua") must return 1 for vim, may require lua...so or lua...dll to be present/installed
-Ruby -- :echo has("ruby") must return 1, must have ruby installed/in execution path, gem install neovim for neovim
-JavaScript -- js2py python module must be installed
-Julia -- must have julia installed and in path and [juliacall python module](https://github.com/JuliaPy/PythonCall.jl)
-R -- R installed/in path and rpy2 python module
-Wolfram Language -- [Wolfram Engine](https://www.wolfram.com/engine/) installed/in path and [wolframclient module](https://www.wolfram.com/engine/)


-----------------
Default bindings/commands:
-----------------
:Volyglot   ---initialize Volyglot, create new pane/buffer for outputs  
\<F10\>     ---same as above  
  
For python (or sage or coconut):   
\<F5\>      ---execute entire file  
\<s-enter\> ---execute current line (normal, insert modes) )or selected region (if in visual mode)  
\<c-\\>     ---same as above, friendlier for terminals  
  
  

\<c-]\> hy  
\<m-]\> javascript  
\<m-\\\> julia  
\<m-/\> lua  
\<m-,> ruby  
\<m-;\> octave  
\<m-'\> R  
\<m-enter\> vimscript  
\<m-w\> wolfram  
  
\<c-u\>     ---get completions (if in insert mode)  
\<c-b\>     ---try to evaluate expression in line, or stuff before = (i.e., if the line has x = 2, will output the CURRENT value of x, which may or may not be defined)  



Demo/tutorial is in the works.
