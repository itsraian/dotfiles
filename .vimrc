if $VIM_PATH != ""
  let $PATH = $VIM_PATH
endif

set nocompatible
set hidden

set encoding=utf-8
set fileformat=unix
set fileencoding=utf-8

syntax enable
filetype plugin indent on

set showmode
set signcolumn=yes
set number
set updatetime=300
set hlsearch
set incsearch
set cursorline
set scrolloff=999
set title
set textwidth=120
set wildmode=list:longest,list:full
set wildmenu
set laststatus=2
set colorcolumn=99

set spell
set spelllang=en_us

set history=1000
set undolevels=1000

set mouse=

set wrap
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start

set autoindent
set smartindent

set ignorecase
set smartcase

set nobackup
set nowritebackup
set noswapfile

set autoread

if &term =~ '256color'
  set t_ut=
endif

if exists('+termguicolors')
  set t_Co=256
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set background=dark
  set termguicolors
endif

let &t_ti = "\e[?1004h"
let &t_te = "\e[?1004l"

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'sainnhe/everforest'
Plug 'wakatime/vim-wakatime'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
Plug 'honza/vim-snippets'

call plug#end()

let g:everforest_background = 'hard'
let g:everforest_better_performance = 1
let g:everforest_enable_italic = 1
colorscheme everforest

""" ==============
""" Airline
""" ==============

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 1
let g:airline_left_sep=' '
let g:airline_right_sep=' '
let g:airline_theme = 'everforest'

let g:indentLine_setColors = 0
let g:indentLine_char = '│'
" let g:indentLine_setConceal = 0
" let g:gitgutter_preview_win_floating = 1
let g:gitgutter_use_location_list = 1

au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! wa

""" =========================
""" COC
""" =========================

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nnoremap <space>D :CocList diagnostics<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nnoremap <space>a <Plug>(coc-codeaction-cursor)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nnoremap <space>A <Plug>(coc-codeaction-line)

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nnoremap <silent> K :call CocActionAsync('doHover')<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust inoremap <silent> <leader>p :CocActionSync('showSignatureHelp')<CR>

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> gd <Plug>(coc-definition)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> gy <Plug>(coc-type-definition)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> gi <Plug>(coc-implementation)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> gr <Plug>(coc-references)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> [g <Plug>(coc-diagnostic-prev)
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust nmap <silent> ]g <Plug>(coc-diagnostic-next)

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust imap <silent><expr> <c-space> coc#refresh()
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust imap <silent><expr> <c-@> coc#refresh()

autocmd CursorHold * silent call CocActionAsync('highlight')
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,zig,rust inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

imap <C-l> <Plug>(coc-snippets-expand)

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <Left> :echo "No arrow for you!"<CR>
vnoremap <Left> :<C-u>echo "No arrow for you!"<CR>
inoremap <Left> <C-o>:echo "No arrow for you!"<CR>

nnoremap <Right> :echo "No arrow for you!"<CR>
vnoremap <Right> :<C-u>echo "No arrow for you!"<CR>
inoremap <Right> <C-o>:echo "No arrow for you!"<CR>

nnoremap <Up> :echo "No arrow for you!"<CR>
vnoremap <Up> :<C-u>echo "No arrow for you!"<CR>
inoremap <Up> <C-o>:echo "No arrow for you!"<CR>

nnoremap <Down> :echo "No arrow for you!"<CR>
vnoremap <Down> :<C-u>echo "No arrow for you!"<CR>
inoremap <Down> <C-o>:echo "No arrow for you!"<CR>

let g:netrw_winsize=20
let g:netrw_liststyle=3

nnoremap <space>F :Files<CR>
nnoremap <space>T :BTags<CR>
vnoremap <space>Y "+y
nnoremap <space>gp <Plug>(GitGutterPreviewHunk) 
nnoremap <space>gu <Plug>(GitGutterUndoHunk)
nnoremap <space>gf :GitGutterFold<CR>
nnoremap <space>P "+P
nnoremap <space>f :GFiles<CR>
nnoremap <space>b :Buffers<CR>
nnoremap <space>/ :Rg<CR>
nnoremap <space>E :Explore<CR>
nnoremap <space>n :set number! <bar> IndentLinesToggle<CR>

nnoremap <space>1 :e $MYVIMRC<CR>
nnoremap <space>2 :source $MYVIMRC<CR>
