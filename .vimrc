if $VIM_PATH != ""
  let $PATH = $VIM_PATH
endif

set nocompatible

set encoding=utf-8
set fileformat=unix
set fileencoding=utf-8

syntax enable
filetype plugin indent on

set background=dark
set showmode
set signcolumn=yes
set number
set updatetime=300
set hlsearch
set incsearch
set cursorline
set scrolloff=999
set t_Co=256
set title
set textwidth=120
set wildmode=list:longest,list:full
set wildmenu
set laststatus=2

set history=1000
set undolevels=1000

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

let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
let &t_ti = "\e[?1004h"
let &t_te = "\e[?1004l"

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'puremourning/vimspector'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'sainnhe/sonokai'
Plug 'wakatime/vim-wakatime'
Plug 'github/copilot.vim'
Plug 'yegappan/lsp'

call plug#end()

let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
colorscheme sonokai

""" ==============
""" Airline
""" ==============

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 1
let g:airline_left_sep=' '
let g:airline_right_sep=' '

let g:indentLine_setColors = 0
let g:indentLine_char = '│'
let g:indentLine_setConceal = 0


au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! wa

""" =========================
""" LSP
""" =========================

let lspOpts = #{
      \ autoHighlight: v:true,
      \ autoPopulateDiags: v:true,
      \ diagVirtualTextAlign: 'after',
      \ noNewlineInCompletion: v:true,
      \ semanticHighlight: v:true,
      \ showDiagOnStatusLine: v:true,
      \ showDiagWithVirtualText: v:true,
      \ usePopupInCodeAction: v:true,
      \ useQuickfixForLocation: v:true
      \ }
autocmd VimEnter * call LspOptionsSet(lspOpts)

let lspServers = [#{
      \   name: 'golang',
      \   filetype: ['go', 'gomod'],
      \   path: 'gopls',
      \   args: ['serve'],
      \   syncInit: v:true
      \ },
      \ #{
      \   name: 'eslint',
      \   filetype: ['javascript', 'typescript', 'typescriptreact', 'javascriptreact'],
      \   path: 'vscode-eslint-language-server',
      \   args: ['--stdio'],
      \   workspaceConfig: {
      \    'validate': 'on',
      \    'packageManager': 'npm',
      \    'useESLintClass': v:false,
      \    'experimental': {
      \      'useFlatConfig': v:false,
      \    },
      \    'codeActionOnSave': {'enable': v:true, 'mode': 'all' },
      \    'format': v:false,
      \    'quiet': v:false,
      \    'onIgnoredFiles': 'off',
      \    'options': {},
      \    'rulesCustomizations': [],
      \    'run': 'onType',
      \    'problems': { 'shortenToSingleLine': v:false },
      \    'nodePath': v:null,
      \    'workingDirectories': [{'mode': 'auto'}],
      \      'workspaceFolder': {
      \    },
      \    'codeAction': {
      \      'disableRuleComment': {
      \        'enable': v:true,
      \        'location': 'separateLine',
      \      },
      \      'showDocumentation': {
      \        'enable': v:true,
      \      },
      \    },
      \   }
      \ },
      \ #{
      \   name: 'typescriptlang',
      \   filetype: ['javascript', 'typescript', 'typescriptreact', 'javascriptreact'],
      \   path: 'typescript-language-server',
      \   args: ['--stdio']
      \ },
      \ #{
      \   name: 'vim',
      \   filetype: ['vim'],
      \   path: 'vim-language-server',
      \   args: ['--stdio'],
      \ },
      \ ]

autocmd VimEnter * call LspAddServer(lspServers)

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nnoremap <space>D :LspDiag show<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> [g :LspDiag next<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> ]g :LspDiag prev<CR>

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nnoremap <space>a :LspCodeAction<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nnoremap <silent> K :LspHover<CR>

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> gd :LspGotoDefinition<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> gy :LspGotoTypeDef<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> gi :LspGotoImpl<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go nmap <silent> gr :LspShowReferences<CR>

autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx,*.go LspFormat

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
nnoremap <space>p "+p
nnoremap <space>P "+P
nnoremap <space>f :GFiles<CR>
nnoremap <space>b :Buffers<CR>
nnoremap <space>/ :Rg<CR>
nnoremap <space>E :Explore<CR>
nnoremap <space>n :set number! <bar> IndentLinesToggle<CR>

nnoremap <space>1 :e $MYVIMRC<CR>
nnoremap <space>2 :source $MYVIMRC<CR>
