syntax on
filetype plugin on

" plugins {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-sleuth'
Plug 'wincent/terminus'

Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

Plug 'lifepillar/vim-gruvbox8'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" }}}

" variables {{{ 
let mapleader=' '
let g:coc_global_extensions = [
			\ 'coc-marketplace', 
			\ 'coc-lists'
			\ ]
"}}}

"{{{ options
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

if executable('rg')
	set grepprg=rg\ -n
endif
"}}}

augroup theming " {{{
	autocmd!
	autocmd ColorScheme gruvbox8 highlight Normal ctermbg=none
	autocmd ColorScheme gruvbox8 highlight EndOfBuffer ctermfg=0
    colors gruvbox8
augroup END " }}}

nnoremap <leader>l :CocList<cr>
nnoremap <leader>g :Git

augroup generic "{{{
	autocmd!
	autocmd FocusGained * checktime
augroup END "}}}

augroup cfamily "{{{
	autocmd!
	autocmd FileType c,cpp packadd termdebug
	autocmd FileType c,cpp compiler gcc
    autocmd FileType c,cpp call <SID>coc_setup()

	if executable('devhelp')
		command! DevHelp call job_start('devhelp --search=' . expand('<cword>'))
	endif
augroup END "}}}

augroup golang "{{{
	autocmd!
    autocmd FileType go call <SID>coc_setup()
	autocmd FileType go compiler go
	autocmd FileType go setlocal tabstop=8 shiftwidth=8 noexpandtab
augroup END "}}}

augroup typescript "{{{
	autocmd!
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact call <SID>coc_setup()
	autocmd FileType typescript,typescriptreact,javascript,javascriptreact setlocal 
				\ tabstop=2 
				\ shiftwidth=2 
				\ expandtab
				\ foldmarker=#region,#endregion
augroup END "}}}

augroup python "{{{
  autocmd!
  autocmd FileType python call <SID>coc_setup()
augroup END "}}}

augroup dotnet "{{{
  autocmd!
  autocmd FileType cs call <SID>coc_setup()
augroup END "}}}

function! s:coc_setup() abort "{{{
  " This configuration is taken from coc github page
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> <leader>r <Plug>(coc-rename)
  nnoremap <silent> gh :call <SID>show_documentation()<CR>
  nnoremap <silent> <leader>l :CocList<cr>
  nnoremap <silent> <leader>. :CocAction<cr>
  vnoremap <silent> <leader>. :CocAction<cr>
  inoremap <silent><expr> <c-@> coc#refresh()

  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  endif

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  autocmd CursorHold * silent call CocActionAsync('highlight')

  command! -nargs=0 Format :call CocAction('format')
  command! -nargs=? Fold :call CocAction('fold', <f-args>)
  command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')
endfunction "}}}

helptags ALL
