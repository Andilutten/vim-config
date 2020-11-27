syntax on
filetype plugin on

let mapleader=' '
let s:findgrp='find . -type f'

set nocompatible
set hidden magic
set tabstop=4 shiftwidth=4
set hlsearch incsearch
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
set autoread
set termguicolors
set background=dark
set cursorline
set t_Co=256

" Tmux termcolors fix {{{
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" }}}

if executable('rg')
	set grepprg=rg\ -n
endif

if executable('fd')
	let s:findprg='fd --type f'
endif

colors codedark

function! s:find_file() abort "{{{
	"" Find file interactivly
	call fzf#run(#{
	\	options: '--prompt "Find file: "',
	\	source: s:findprg,
	\	sink: 'edit',
	\	window: #{ width: 0.8, height: 0.8 },
	\ })
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

		call fzf#run(#{
				\	options: '--prompt "Select buffer: "',
				\ 	source: l:filenames,
				\	sink: 'buffer',
				\	window: #{ width: 0.8, height: 0.8 },
				\ })
		endfunction "}}}

function! s:on_lsp_buffer_enabled() abort "{{{
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=number
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
	nmap <buffer> ga <plug>(lsp-code-action)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
endfunction "}}}

nnoremap <silent> <leader>b <cmd>call <SID>select_buffer()<cr>
nnoremap <silent> <leader>f <cmd>call <SID>find_file()<cr>

augroup generic "{{{
	autocmd!
	autocmd FocusGained * checktime
augroup END "}}}

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
			\ allowlist: ['typescript', 'typescriptreact', 'javascript', 'javascriptreact'],
			\ })
	endif
	autocmd FileType typescript,typescriptreact setlocal tabstop=2 shiftwidth=2 expandtab
augroup END "}}}

augroup lspclient "{{{
	autocmd!
	let g:lsp_diagnostics_float_cursor = 1
	let g:lsp_semantic_enabled = 1
	autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()
	command! Format LspDocumentFormat
augroup END "}}}

helptags ALL
