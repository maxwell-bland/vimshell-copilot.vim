"=============================================================================
" FILE: bexe.vim
" AUTHOR: Maxwell Bland <mb28@illinois.edu>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:command = {
      \ 'name' : 'bexe',
      \ 'kind' : 'special',
      \ 'description' : 'bexe {command}',
      \}
function! s:command.execute(args, context) abort "{{{
  " get the real args
  let cmdline = join(a:args, ' ')

  let options = {}
  let options['--encoding'] = 'char'

  if vimshell#util#is_windows()
    let cmdline = '"' . cmdline . '"'
  endif

  " Set redirection.
  let null = ''
  if a:context.fd.stdin == ''
    let stdin = ''
  elseif a:context.fd.stdin == '/dev/null'
    let null = tempname()
    call writefile([], null)

    let stdin = '<' . null
  else
    let stdin = '<' . a:context.fd.stdin
  endif

  echo 'Running command.'

    " Convert encoding.
  let cmdline = vimproc#util#iconv(cmdline, &encoding, options['--encoding'])
  let stdin = vimproc#util#iconv(stdin, &encoding, options['--encoding'])

  " Set environment variables.
  let environments_save = vimshell#util#set_variables({
        \ '$TERMCAP' : 'COLUMNS=' . vimshell#helpers#get_winwidth(),
        \ '$COLUMNS' : vimshell#helpers#get_winwidth(),
        \ '$LINES' : g:vimshell_scrollback_limit,
        \ '$EDITOR' : vimshell#helpers#get_editor_name(),
        \ '$GIT_EDITOR' : vimshell#helpers#get_editor_name(),
        \ '$PAGER' : g:vimshell_cat_command,
        \ '$GIT_PAGER' : g:vimshell_cat_command,
        \})

  " print the contents of the command into a temporary file and run
  let tmpfile = tempname()
  call writefile(['#!/bin/bash', cmdline . ' ' . stdin], tmpfile)
  call system('chmod u+x ' . tmpfile)
  let result = vimproc#system(tmpfile)
  call delete(tmpfile)

  " Restore environment variables.
  call vimshell#util#restore_variables(environments_save)

  " Convert encoding.
  let result = vimproc#util#iconv(result, options['--encoding'], &encoding)

  call vimshell#print(a:context.fd, result)
  redraw
  echo ''

  if null != ''
    call delete(null)
  endif

  let b:vimshell.system_variables['status'] = v:shell_error

  return
endfunction"}}}

function! vimshell#commands#bexe#define() abort
  return s:command
endfunction
