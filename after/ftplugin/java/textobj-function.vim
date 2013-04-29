" Vim additional ftplugin: java/textobj-function
" Version 0.1.4
" Copyright (C) 2007-2014 Kana Natsuno <http://whileimautomaton.net/>
"               2013-2014 Jan Larres <jan@majutsushi.net>
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

if !exists('*g:textobj_function_java_select')
    function! g:textobj_function_java_select(object_type)
        return s:select_{a:object_type}()
    endfunction

    function! s:select_a()
        if getline('.') != '}'
            normal! ]M
        endif
        let e = getpos('.')

        normal! [m
        call search(')', 'bW')
        normal! %0k
        let b = getpos('.')

        if 1 < e[1] - b[1]  " is there some code?
            return ['V', b, e]
        else
            return 0
        endif
    endfunction

    function! s:select_i()
        let range = s:select_a()
        if type(range) == type(0)
            return 0
        endif

        let [__unused, b, e] = range
        if 1 < e[1] - b[1]  " is there some code?
            call setpos('.', b)
            call search('{', 'W')
            normal! j0
            let b = getpos('.')

            call setpos('.', e)
            normal! k$
            let e = getpos('.')

            return ['V', b, e]
        else
            return 0
        endif
    endfunction
endif




let b:textobj_function_select = function('g:textobj_function_java_select')




if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '|'
else
    let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'unlet b:textobj_function_select'

" __END__
" vim: foldmethod=marker