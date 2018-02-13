"blue, darkblue, default, delek, desert, elflord, evening, koehler, morning, murphy, pablo, peachpuff, ron, shine, slate, torte, zellner
colorscheme slate

autocmd FileType python colorscheme zellner
autocmd FileType bash   colorscheme slate

syntax on
filetype indent plugin on
set modeline                           " allow vim: tabstop=n to be used

set number
set hlsearch
hi Search ctermbg=LightYellow
hi Search ctermfg=Red

set mouse=a

set ai                                 " autoindent

set sts=2
set sw=2

set expandtab                          " tabs instead of spaces
set ts=2                               " tab spaces
set tabstop=2                          " set number of spaces inserted
set shiftwidth=2                       " when tab is pressed


" set nocompatible

" http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion
" author: benoit cerrina

fun! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfun

fun! ShiftInsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<s-tab>"
  else
    return "\<c-n>"
  endif
endfun

inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-r>=ShiftInsertTabWrapper()<cr>

nmap <C-c> :q!<cr>

:set dictionary+=dict.file
:set dictionary+=%
:set iskeyword+=:
:set complete+=k
