# Volyglot
## Use Vim as a Jupyter-like shell for Python and other languages

Volyglot -- Vim + polyglot    \(***Speaking, writing, written in, or composed of several languages***\)

[![asciicast](https://asciinema.org/a/NI3ba7dOjtYsevfDWCm6lQwxB.svg)](https://asciinema.org/a/NI3ba7dOjtYsevfDWCm6lQwxB)

*Features:*

-Executes Python files, individual lines, or blocks (via visual mode) within the Vim editor  
-Displays the output in a separate buffer/window  
-Can inspect variable/expression values  
-Set breakpoints within functions etc. and inspect local variables  
-Completions (via IPython if available, else rlcompleter)  

Additional Features (2024):  
-Can execute [Coconut](http://coconut-lang.org/) just like plain Python if Coconut is installed  
-Similar with [SageMath](https://www.sagemath.org/)  
-[Hy](https://docs.hylang.org/en/alpha/) support, just use <c-]>, assuming Hy is installed  
-Julia support if Julia/PyJulia are set up.  Use <m-\\>.  <c-b> and <c-u> (evaluate-and-print, and completions) work just the same between Julia and Python (run :Julia to start)  
-Octave support similar to Julia  
-Additional languages supported: R, javascript (via js2py), Wolfram Language, lua, ruby, vimscript  



Requirements:

-Vim (gVim, neovim) with Python3 build (Python2 not supported, nor will it be); ' :echo has("python3") ' must return 1


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
