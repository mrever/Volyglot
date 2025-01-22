Volyglot

Vim + Polyglot (one who is multilingual)
=> Volyglot is a multilingual execution environment in Vim & variants.

It's' a plugin for Vim/gVim/Neovim that let's' you execute code in multiple scripting languages right within your editor
Great for interactive development & debugging, or for trying out new languages

Languages supported:
    ▷   Python
        ▶   Coconut
        ▶   SageMath
        ▶   Hy
    ▷   Lua
    ▷   Vimscript
    ▷   Ruby
    ▷   Javascript
    ▷   Julia
    ▷   R
    ▷   Octave
    ▷   Wolfram Language

Features:
- Write code in one pane, execute the whole file (pane), line-by-line, or user selection and see the result in the output pane.
- Inspect variables/objects without executing the line.
- Get help on objects/modules easily (Python).
- Set breakpoints and debug interactively (Python).



Python demo
    <c-\> to execute Python code
    <F5> to run whole file
    <c-b> to evaluate line or selection
    <c-u> for completer (insert mode)


# Simple example

for idx in range(3):
    print(f'hello Volyglot {idx}')

def myfunc(v):
    if type(v) == int:
        x = 10 + v
        x *= 12
        return x
    else:
        return 0

v = 9
myfunc(v)
myfunc('foo')


# Vim introspection/manipulations
vim.buffers[1][:5]
vim.eval('@q')
vim.command('ls')
vim.buffers[1][56] = 'blah'
vim.current.line = 'test'

# Display an error message
import numpp as np

import numpy as np
np.zeros(9,9)

# Built-in completer <c-u> in insert mode
np.

# 2D array printing
np.zeros((9,9)) + 42
print(np.zeros((9,9)) + 42)
np.random.randint(0,501,(10,10))
np.random.randn(5,5)

# Plotting in external window
import matplotlib.pyplot as plt

y = np.random.randint(0,9,20)

plt.figure()
plt.plot(y)
plt.grid()
plt.show(block=False) # works with gVim (all platforms), or Vim (Windows only)
plt.show() # needed for neovim, or Vim on Linux


∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯
Coconut example  <c-\>, same as basic Python

Run :Coconut to invoke

# Python
print(list(map(lambda x: x**2, range(10))))
# Coconut
map(x -> x**2, range(10)) |> list |> print

A = np.array([1, 2;; 3, 4])
AA = [A ; A]

first_five_words = .split() ..> .$[:5] ..> " ".join
first_five_words("I am the very model of a modern major general")

Can turn Coconut off (back to default Python parser)
:Coconutoff


∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯
Sage(math) example (neovim only) also <c-\>
To start:
:Sage

f = 1 - sin(x)^2
unicode_art(integrate(f, x).simplify_trig())

QQ^3
zeta(0.5)
ζ(0.5)

:Sageoff


Yes, Coconut and Sage work at the same time (!)

QQ^3 |> print




∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯
Hy example <c-]>
:Hy

(setv foobar (* 3 9))
(print foobar)


(defmacro do-while [test #* body]
  `(do
    ~@body
    (while ~test
      ~@body)))

(setv x 0)
(do-while x
  (print "Printed once."))


∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯
Vimscript demo <m-enter>
:Vimscript

messages
echo $USER
nnoremap <s-k> :echo "useless hotkey"<cr>
ls
version

Incidentally, we can run shell commands like this:

!ls
!pwd
!echo $PWD



∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯
Lua example <m-/>
:Lua

function calculate(a, b)
    return a + b, a - b
end
sum, difference = calculate(10, 5)
print("Sum: " .. sum .. ", Difference: " .. difference)

fruits = {"apple", "banana", "cherry"}
table.insert(fruits, "orange")
print(fruits[4])  -- Output: orange

Lua also has a vim module, similar to Python.  It's' a little different
between vim and neovim.

print(vim.buffer())

This could be especially useful for writing an init.lua for neovim, 
or plug-in development


∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯
Julia example <m-\>
:Julia

print(sind(90))

function sphere_vol(r)
    return 4/3*π*r^3 # Julia supports unicode
end

quadratic(a, sqr_term, b) = (-b + sqr_term) / 2a

function quadratic2(a::Float64, b::Float64, c::Float64)
    sqr_term = sqrt(b^2-4a*c) # 4a <=> 4*a in other languages
    r1 = quadratic(a, sqr_term, b)
    r2 = quadratic(a, -sqr_term, b)
    r1, r2 # returns r1, r2 tuple
end

vol = sphere_vol(3)
println("vol = ", vol)
quad1, quad2 = quadratic2(2.0, -2.0, -12.0)
println("result 1: ", quad1)
println("result 2: ", quad2)

# we can import libraries if they're installed
using FFTW

N = 21
xj = (0:N-1)*2*π/N
f = 2*exp.(17*im*xj) + 3*exp.(6*im*xj) + rand(N)

original_k = 1:N
shifted_k = fftshift(fftfreq(N)*N)

original_fft = fft(f)
shifted_fft = fftshift(fft(f))

# Plotting via julia does not work at the moment due to julia-python bridge limitations.
# However, it's very easy to pass data python ↔ julia.

# <c-\> to run this with python
plt.figure()
plt.plot(np.abs(_julmain.shifted_fft))
plt.show()

# _julmain (short for julia.Main, which you can import) can read/set vars from/to julia's namespace


∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯∯
Ruby, Javascript, R, Octave, Wolfram Language to be demonstrated in future videos/demos
