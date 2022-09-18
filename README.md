# VimShell with Github Copilot

Adds various ergonomic improvements to VimShell for use with Github Copilot. 
The modifications work in Linux only.

Works as a drop-in replacement for [Shougo's original vimshell.nvim](https://github.com/Shougo/vimshell.nvim) in [my tutorial for Copilot in the terminal](https://github.com/maxwell-bland/copilot-in-the-terminal).
For information about VimShell generally, check [doc/vimshell.txt](doc/vimshell.txt). Of course, most of the credit for this goes to Shougo.

## Features

### The `bexe` Command

The `bexe` command allows you to run native bash commands by prefixing the line
with `!`. It works by writing the set of statements into a temporary file and
executing that file using `bash`. This is useful for running commands that
would otherwise be interpreted by VimShell as multiple statements, e.g. 

```
!for i in {1..10}; do echo $i; done
```

will now work as expected. (Note the `!` prefix!) 

To declare functions, use the `declare -f` command to write the function to a
temporary file, then source that file using `source`. For example:

```
!myfunc() { echo "hello world"; }; declare -f myfunc >/tmp/myfunc.sh;
!source /tmp/myfunc.sh; myfunc
```

Will print 

```
hello world
```
