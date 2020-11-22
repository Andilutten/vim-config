let $GIT_EDITOR=get(environ(), 'GIT_EDITOR', 'gvim --remote-tab-wait')

set guifont=JetBrains\ Mono\ Bold\ 11
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set guioptions-=e

colors zellner
highlight EndOfBuffer guifg=bg
highlight Terminal guifg=white guibg=black
highlight Variable guifg=#28A939
highlight! link Pmenu Normal 

function! s:increment_font_size() abort "{{{
	let l:font_props = s:get_font_props()
	let l:font_family = l:font_props.family
	let l:font_size = str2nr(l:font_props.size) + 1
	exec 'set guifont=' 
		\ . join([l:font_family, l:font_size], ' ')
		\ ->fnameescape()
endfunction "}}}

function! s:decrement_font_size() abort "{{{
	let l:font_props = s:get_font_props()
	let l:font_family = l:font_props.family
	let l:font_size = str2nr(l:font_props.size) - 1
	exec 'set guifont=' 
		\ . join([l:font_family, l:font_size], ' ')
		\ ->fnameescape()
endfunction "}}}

function! s:get_font_props() abort "{{{
	let l:font_size = &guifont->matchstr('\v[0-9]*$')
	let l:font_family = &guifont->matchstr('\v^[a-zA-Z ]*')
	return #{
	\	family: l:font_family,
	\	size: l:font_size
	\ }
endfunction "}}}

nmap <c-pageup> <cmd>call <SID>increment_font_size()<cr>
nmap <c-pagedown> <cmd>call <SID>decrement_font_size()<cr>
