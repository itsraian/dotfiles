vim9script

if $VIM_PATH != ""
  var $PATH = $VIM_PATH
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
  &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set background=dark
  set termguicolors
endif

&t_ti = "\e[?1004h"
&t_te = "\e[?1004l"

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yegappan/lsp'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'sainnhe/everforest'
Plug 'wakatime/vim-wakatime'
Plug 'github/copilot.vim'
Plug 'prettier/vim-prettier'

call plug#end()

g:everforest_background = 'hard'
g:everforest_better_performance = 1
g:everforest_enable_italic = 1
colorscheme everforest

g:gitgutter_sign_priority = 1

# ==============
# Airline
# ==============

g:airline#extensions#tabline#enabled = 1
g:airline#extensions#tabline#formatter = 'jsformatter'
g:airline_powerline_fonts = 1
g:airline_left_sep = ' '
g:airline_right_sep = ' '
g:airline_theme = 'everforest'

g:indentLine_setColors = 1
g:indentLine_char = '│'
# var g:indentLine_setConceal = 0
# var g:gitgutter_preview_win_floating = 1
g:gitgutter_use_location_list = 1

au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! wa

# =============
# LSP
# =============

var lspOpts = {
  autoHighlightDiags: v:true, 
  semanticHighlight: v:true, 
  usePopupInCodeAction: v:true, 
  showInlayHints: v:true, 
  showDiagWithVirtualText: v:true,
  diagSignErrorText: '»',
  diagSignInfoText: '»',
  diagSignHintText: '»',
  diagSignWarningText: '»',
}
autocmd User LspSetup call LspOptionsSet(lspOpts)

var lspServers = [
  {
    name: 'eslint',
    filetype: ['javascript', 'typescript', 'typescriptreact', 'javascriptreact'],
    path: 'vscode-eslint-language-server',
    args: ['--stdio'],
    rootSearch: ['package.json'],
    workspaceConfig: {
    'validate': 'on',
    'packageManager': v:null,
    'useESLintClass': v:false,
    'experimental': {
    'useFlatConfig': v:false,
    },
    'codeActionOnSave': {'enable': v:false, 'mode': 'all' },
    'format': v:true,
    'quiet': v:false,
    'onIgnoredFiles': 'off',
    'rulesCustomizations': [],
    'run': 'onType',
    'problems': { 'shortenToSingleLine': v:false },
    'nodePath': '',
    'workingDirectory': {'mode': 'location'},
    'workspaceFolder': {
    },
    'codeAction': {
    'disableRuleComment': {
    'enable': v:true,
    'location': 'separateLine',
    },
    'showDocumentation': {
    'enable': v:true,
    },
    },
    }
  },
  {
    name: 'typescriptlang',
    filetype: ['javascript', 'typescript', 'typescriptreact', 'javascriptreact'],
    path: 'typescript-language-server',
    args: ['--stdio'],
    syncInit: v:true
  },
  {
    name: 'golang',
    filetype: ['go', 'gomod'],
    path: 'gopls',
    args: ['serve'],
    initializationOptions: {
    'hints': {'parameterNames': v:false},
    'semanticTokens': v:true,
    'usePlaceholders': v:true,
    },
    syncInit: v:true
  },
  {
    name: 'golint-ci',
    filetype: ['go'],
    path: 'golangci-lint-langserver',
    args: ['-debug'],
    initializationOptions: {
      "command": ["golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1"]
    }
  },
#  {
#    name: 'vimls',
#    filetype: ['vim'],
#    path: 'vim-language-server',
#    args: ['--stdio'],
#    initializationOptions: {
#      "diagnostic": {
#        "enable": v:false
#      },
#    }
#  },
  {
    name: 'python',
    filetype: 'python',
    path: 'pyright-langserver',
    args: ['--stdio'],
  },
  {
    name: 'sql',
    filetype: 'sql',
    path: 'sql-language-server',
    args: ['up', '--method', 'stdio'],
  },
  {
    name: 'terraform',
    filetype: 'tf',
    path: 'terraform-ls',
    args: ['serve'],
  },
  {
    name: 'yaml',
    filetype: 'yaml',
    path: 'yaml-language-server',
    args: ['--stdio'],
  },
  {
    name: 'docker',
    filetype: 'dockerfile',
    path: 'docker-langserver',
    args: ['--stdio'],
  },
  {
    name: 'ruff',
    filetype: 'python',
    path: 'ruff-lsp',
  }
]

autocmd User LspSetup call LspAddServer(lspServers)

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vim nnoremap <space>D :LspDiag show<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vim nnoremap <space>a :LspCodeAction<CR>

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> K :LspHover<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gs :LspShowSignature<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gd :LspGotoDefinition<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gy :LspGotoTypeDef<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gi :LspGotoImpl<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gr :LspShowReferences<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> [g :LspDiag prev<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> ]g :LspDiag next<CR>

autocmd BufWritePre *.go,*.py :LspFormat | :LspCodeAction /Organize
autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx :LspFormat | :LspCodeAction /Organize | :PrettierAsync

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

g:netrw_winsize = 20
g:netrw_liststyle = 3

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
