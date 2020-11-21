let $GIT_EDITOR=get(environ(), 'GIT_EDITOR', 'gvim --remote-tab-wait')

set guifont=JetBrains\ Mono\ Bold\ 12
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
set guioptions-=e

colors zellner
highlight EndOfBuffer guifg=bg
