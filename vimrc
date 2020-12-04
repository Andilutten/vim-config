syntax on
filetype plugin on

let mapleader=' '

set nocompatible
set encoding=utf8
set hidden magic
set tabstop=4 shiftwidth=4
set hlsearch incsearch
set noexpandtab
set path=**
set ignorecase smartcase
set number relativenumber
set foldmethod=marker
set foldmarker={{{,}}}
set wildmenu
set mouse=a
set clipboard=unnamedplus
set completeopt-=preview
set completeopt+=noselect
set splitbelow splitright
set smartindent
set nowrap
set autoread
set background=dark
set t_Co=16

colors gruvbox8

if executable('rg')
	set grepprg=rg\ -n
endif

nnoremap <leader>b :Buffers<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>g :Git

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
			\ 	'entity.name.function.cpp': 'Identifier',
			\	'variable.other.field.cpp': 'Type'
			\ },
			\ })
	endif
	autocmd FileType c,cpp packadd termdebug
	autocmd FileType c,cpp compiler gcc

	if executable('devhelp')
		command! DevHelp call job_start('devhelp --search=' . expand('<cword>'))
	endif
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
	autocmd FileType typescript,typescriptreact setlocal 
				\ tabstop=2 
				\ shiftwidth=2 
				\ expandtab
				\ foldmarker=#region,#endregion
augroup END "}}}

augroup lspclient "{{{
	autocmd!
	let g:lsp_diagnostics_float_cursor = 1
	let g:lsp_semantic_enabled = 1
	autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()
	command! Format LspDocumentFormat
augroup END "}}}

function! s:on_lsp_buffer_enabled() abort "{{{
    setlocal 
		\ omnifunc=lsp#complete
		\ signcolumn=number

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

helptags ALL
