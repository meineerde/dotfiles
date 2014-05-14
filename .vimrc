set nocompatible   " We're running Vim, not Vi!

" Initialize pathogen
call pathogen#infect()

set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs

set shell=/bin/bash\ -l

" 2 spaces soft tabstops
set ts=2 sts=2 sw=2 expandtab

syntax enable
colorscheme Tomorrow-Night-Bright

" Make backspace key work like most other apps
set backspace=indent,eol,start
