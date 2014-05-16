set nocompatible   " We're running Vim, not Vi!

" Initialize pathogen
call pathogen#infect()

let mapleader = "\\"

set shell=/bin/bash\ -l

" Make backspace key work like most other apps
set backspace=indent,eol,start

" Use the system clipboard by default
set clipboard=unnamed

function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
 endfunction

" Highlighting ****************************************************************
syntax enable
set background=dark
let base16colorspace=256
colorscheme base16-tomorrow

" Editor window ***************************************************************
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs

" Status Line *****************************************************************
set ruler
set showcmd

set textwidth=80
set number

" from http://stackoverflow.com/a/3765575/421705
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Line Wrapping ***************************************************************
set nowrap
set linebreak
set nolist " list disables linebreak

" turn off physical line wrapping (ie: automatic insertion of newlines)
set textwidth=0 wrapmargin=0

" Searching *******************************************************************
set hlsearch   " highlight search
set incsearch  " incremental search, search as you type
set ignorecase " ignore case when searching
set smartcase  " ignore case when searching lowercase
nmap <leader>h :noh<CR>

" Spaces***********************************************************************
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Indenting *******************************************************************
set autoindent " Automatically set the indent of a new line (local to buffer)
set smartindent " smartindent (local to buffer)

" Invisible characters ********************************************************
set listchars=tab:▸\ ,trail:·
set list!

" File stuff / File types / Autocomands ***************************************
filetype plugin on
filetype plugin indent on " Enable filetype-specific indenting and plugins
if has("autocmd")
  aug vimrc
    au!
    " To show current filetype use: set filetype
    au BufNewFile,BufRead config.ru,Gemfile,Vagrantfile,Cheffile,Berksfile,*.rsb,*.rabl set filetype=ruby
    au BufNewFile,BufRead *.json set ft=javascript

    " strip trailing white space on all lines
    autocmd vimrc BufWritePre * :call Preserve("%s/\\s\\+$//e")
    " au FileType html :set filetype=xhtml
  aug END
endif

" Tabs ************************************************************************

nmap <leader>t <Esc>:tabnew<CR>

" Plugins *********************************************************************

" NERDtree
nnoremap <leader>n :NERDTreeToggle<CR> :NERDTreeMirror<CR>
let NERDTreeMapActivateNode='<CR>'

" NERDCommenter
let NERDMenuMode=0              " disable menu
let NERDSpaceDelims=1           " place spaces after comment chars
let NERDDefaultNesting=0        " don't recomment commented lines

