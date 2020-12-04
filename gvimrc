let $GIT_EDITOR=get(environ(), 'GIT_EDITOR', 'gvim --remote-tab-wait')
let $EDITOR=get(environ(), 'EDITOR', 'gvim --remote')

set guifont=Fira\ Mono\ SemiBold\ 11
set guioptions-=T
set guioptions-=r
set guioptions-=L

" Theming {{{
colors codedark
hi EndOfBuffer guifg=bg

let g:terminal_ansi_colors = [
	\ '#6A787A',
	\ '#E9653B',
	\ '#39E9A8',
	\ '#E5B684',
	\ '#44AAE6',
	\ '#E17599',
	\ '#3DD5E7',
	\ '#C3DDE1',
	\ '#598489',
	\ '#E65029',
	\ '#00FF9A',
	\ '#E89440',
	\ '#009AFB',
	\ '#FF578F',
	\ '#5FFFFF',
	\ '#D9FBFF'
	\ ]
" }}}

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

nmap <c-s-pageup> <cmd>call <SID>increment_font_size()<cr>
nmap <c-s-pagedown> <cmd>call <SID>decrement_font_size()<cr>
