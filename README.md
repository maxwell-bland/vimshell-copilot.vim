# VimShell with Github Copilot

Adds various ergonomic improvements to VimShell for use with Github Copilot. 
The modifications work in Linux only.

Works as a drop-in replacement for [Shougo's original vimshell.nvim](https://github.com/Shougo/vimshell.nvim) in [my tutorial for Copilot in the terminal](https://github.com/maxwell-bland/copilot-in-the-terminal).
For information about VimShell generally, check [doc/vimshell.txt](doc/vimshell.txt). Of course, most of the credit for this goes to Shougo.

## Features

- The `sexe` command now directly executes the supplied command line as a bash 
  script directly, allowing VimShell to support bash `for` and `while` loops, but
  all `;` need to be written as `\;`, similar to xargs. This was done to avoid 
  conflicts with the VimShell parser. e.g. 

  ```
  sexe for i in 1 2 3\; do echo $i\; done
  ```

  Correctly prints 
  
  ```
  1
  2
  3
  ```



