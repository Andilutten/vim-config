syntax on
filetype plugin on

let $MENU_PROGRAM=get(environ(), 'MENU_PROGRAM', 'dmenu')

let mapleader=' '

set nocompatible
set hidden magic
set tabstop=4 shiftwidth=4
set noexpandtab
set path=**
set ignorecase smartcase
set number relativenumber
set foldmethod=marker
set wildmenu
set mouse=a
set clipboard=unnamedplus
set completeopt-=preview
set splitbelow splitright
set smartindent
set nowrap
set t_Co=16

function! s:find_file() abort "{{{
	"" Find file interactivly
	let l:path = split(&path, ',')->join(' ')
	let l:filename = system(join([
		\'find', l:path, '-type f | ',
		\ $MENU_PROGRAM,'-p "find file:"'
		\ ]))
	call execute(join(['edit', l:filename], ' '))
endfunction "}}}

function! s:select_buffer() abort "{{{
	""" Select buffer interactivly
	redir => l:buffers
	silent buffers
	redir END
	
	let l:filenames = l:buffers
		\->split('\n')
		\->filter({_, v -> len(v)})
		\->map({_, v -> matchstr(v, '\v"[^"]+"')})
		\->map({_, v -> substitute(v, '"', '', 'g')})

	let l:filename = system($MENU_PROGRAM . ' -p "select buffer"', l:filenames)
	call execute(join(['buffer', l:filename], ' '))
endfunction "}}}

function! s:on_lsp_buffer_enabled() abort "{{{
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=number
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
endfunction "}}}

if executable($MENU_PROGRAM)
	nnoremap <silent> <leader>b <cmd>call <SID>select_buffer()<cr>
	nnoremap <silent> <leader>f <cmd>call <SID>find_file()<cr>
endif

augroup cfamily "{{{
	autocmd!
	if executable('clangd')
		autocmd User lsp_setup call lsp#register_server(#{
			\ name: 'clangd',
			\ cmd: {server_info -> ['clangd']},
			\ allowlist: ['c', 'cpp'],
			\ semantic_highlight: {
			\ 	'entity.name.function.cpp': 'Label',
			\	'variable.other.field.cpp': 'Variable'
			\ },
			\ })
	endif
	autocmd FileType c,cpp packadd termdebug
	autocmd FileType c,cpp compiler gcc
augroup END "}}}

augroup golang "{{{
	autocmd!
	if executable('gopls')
		autocmd User lsp_setup call lsp#register_server(#{
			\ name: 'gopls',
			\ cmd: {server_info -> ['gopls']},
			\ allowlist: ['go'],	
			\ })
	endif	
	autocmd FileType go compiler go
	autocmd FileType go setlocal tabstop=8 shiftwidth=8 noexpandtab
augroup END "}}}

augroup typescript "{{{
	autocmd!
	if executable('typescript-language-server')
		autocmd User lsp_setup call lsp#register_server(#{
			\ name: 'tsserver',
			\ cmd: {server_info -> ['typescript-language-server', '--stdio']},
			\ allowlist: ['typescript', 'typescriptreact'],
			\ })
	endif
	autocmd FileType typescript,typescriptreact setlocal tabstop=2 shiftwidth=2 expandtab
augroup END "}}}

augroup lspclient "{{{
	autocmd!
	let g:lsp_diagnostics_float_cursor = 1
	let g:lsp_semantic_enabled = 1
	autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()
augroup END "}}}

helptags ALL
