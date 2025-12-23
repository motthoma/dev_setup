set number
set relativenumber  " relative numbers for other lines

syntax on
filetype plugin indent on

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set nocompatible              " be iMproved, required
filetype plugin indent on    " required
set mouse=a	              " allow mouse usage	
set belloff=all               " surppresses error sounds



" -------------------------
" Detect Python 3.11 or newer
" -------------------------
let g:python3_host_prog = ''
if executable('python3')
    let pyver = system('python3 -c "import sys; print(f\"{sys.version_info.major}.{sys.version_info.minor}\")"')
    let pyver = substitute(pyver, '\n', '', '')  " remove trailing newline

    " Only use this python if >= 3.11
    if pyver >=# '3.11'
        let g:python3_host_prog = exepath('python3')
        let g:has_py311 = 1
    else
        let g:has_py311 = 0
    endif
else
    let g:has_py311 = 0
endif

" automatically jump to last cursor position before  closing
au BufReadPost * execute 'normal! g`"' 


" shortcut for inserting new lines below and above
" current ones without staying in insert mode
map <Enter> o<ESC>
map <S-Enter> O<ESC>

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'

" Only install YouCompleteMe if Python >= 3.11 is found
if g:has_py311
    Plugin 'Valloric/YouCompleteMe'
endif

Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'majutsushi/tagbar'
Plugin 'dense-analysis/ale'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required

" add an indicator for Caps-Lock status in airline
function! CapsLockStatus()
  if system("xset q | grep Caps | awk '{print $4}'") =~? 'on'
    return ' CAPS'
  endif
  return ''
endfunction

let g:airline_section_warning = airline#section#create_right(['%{CapsLockStatus()}'])

" Map CtrlP to :GFiles command of fzf plugin
nnoremap <C-p> :GFiles<CR>

let mapleader = " "
nnoremap <leader><CR> :so ~/.vimrc
nnoremap <leader>Y gg"+yG

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" quickfix window
augroup QuickfixMappings
  autocmd!
  autocmd FileType qf nnoremap <buffer> <C-j> :cnext<CR>
  autocmd FileType qf nnoremap <buffer> <C-k> :cprev<CR>
augroup END




" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
