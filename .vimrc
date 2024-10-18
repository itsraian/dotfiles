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
# Plug 'yegappan/lsp'
Plug 'prabirshrestha/vim-lsp'
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

g:lsp_semantic_enabled = 1
g:lsp_diagnostics_signs_error = {'text': '✘', 'texthl': 'ErrorMsg'}
g:lsp_diagnostics_signs_warning = {'text': '⚠', 'texthl': 'WarningMsg'}
g:lsp_diagnostics_signs_information = {'text': 'ℹ', 'texthl': 'InfoMsg'}
g:lsp_diagnostics_signs_hint = {'text': '➤', 'texthl': 'MoreMsg'}
g:lsp_document_code_action_signs_hint = {'text': '>'}
g:lsp_document_code_action_signs_enabled = 0
g:lsp_diagnostics_virtual_text_align = 'right'
g:lsp_inlay_hints_enabled = 1
g:lsp_use_native_client = 1
g:lsp_log_file = '/tmp/lsp.log'

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'tsserver',
        \ 'cmd': ['typescript-language-server', '--stdio'],
        \ 'allowlist': ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
        \ 'workspace_config': {
        \ 'hints': {'parameterNames': v:false},
        \ 'semanticTokens': v:true,
        \ 'usePlaceholders': v:true,
        \ }
        \ })
endif

if executable('gopls')
    au User lsp_setup call lsp#register_server({
          \ name: 'gopls',
          \ cmd: ['gopls', 'serve'],
          \ allowlist: ['go', 'gomod'],
          \ })
endif

if executable('starpls')
    au User lsp_setup call lsp#register_server({
          \ name: 'starlark',
          \ cmd: ['starpls', 'server'],
          \ allowlist: ['bazel', 'bzl'],
          \ })
endif

if executable('vscode-eslint-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'vscode-eslint-language-server',
        \ 'cmd': ['vscode-eslint-language-server', '--stdio'],
        \ 'allowlist': ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
        \ 'workspace_config': {
          \ 'validate': 'on',
          \ 'packageManager': v:null,
          \ 'useESLintClass': v:false,
          \ 'experimental': {'useFlatConfig': v:false},
          \ 'codeActionOnSave': {'enable': v:false, 'mode': 'all' },
          \ 'format': v:true,
          \ 'quiet': v:false,
          \ 'onIgnoredFiles': 'off',
          \ 'rulesCustomizations': [],
          \ 'run': 'onType',
          \ 'problems': { 'shortenToSingleLine': v:false },
          \ 'nodePath': '',
          \ 'workingDirectory': {'mode': 'location'},
          \ 'workspaceFolder': { },
          \ 'codeAction': {
          \ 'disableRuleComment': {
          \ 'enable': v:true,
          \ 'location': 'separateLine',
          \ },
          \ 'showDocumentation': { 'enable': v:true },
          \ },
        \ }
        \ })
endif

if executable('ruff')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ruff',
        \ 'cmd': ['ruff', 'server'],
        \ 'allowlist': ['python']
        \ })
endif

if executable('sql-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'sql',
        \ 'cmd': ['sql-language-server', 'up', '--method', 'stdio'],
        \ 'allowlist': ['sql']
        \ })
endif

if executable('terraform-ls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'terraform-ls',
        \ 'cmd': ['terraform-ls', 'serve'],
        \ 'allowlist': ['tf']
        \ })
endif

if executable('yaml-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'yaml',
        \ 'cmd': ['yaml-language-server', '--stdio'],
        \ 'allowlist': ['yaml']
        \ })
endif

if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'docker',
        \ 'cmd': ['docker-langserver', '--stdio'],
        \ 'allowlist': ['dockerfile']
        \ })
endif

if executable('pyright-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'python',
        \ 'cmd': ['pyright-langserver', '--stdio'],
        \ 'allowlist': ['python'],
        \ 'workspace_config': {
          \ 'pyright': {},
          \ 'python': {
            \ 'analysis': {
              \ 'typeCheckingMode': 'standard'
            \ }
          \ }
        \ }
        \ })
endif


def FormatCode()
  :silent LspDocumentFormatSync
enddef

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vim nnoremap <space>D :LspDocumentDiagnostics<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vim nnoremap <space>a :LspCodeAction --ui=float<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vim nnoremap <space>t :LspDocumentSymbol<CR>

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> K :LspHover --ui=float<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gs :LspSignatureHelp<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gd :LspDefinition<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gy :LspTypeDefinition<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gi :LspImplementation<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> gr :LspReferences<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> [g :LspPreviousDiagnostic<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python nmap <silent> ]g :LspNextDiagnostic<CR>

autocmd BufWritePre *.go,*.py :call FormatCode()
autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx :call FormatCode() |  :PrettierAsync
inoremap <Nul> <C-x><C-o>

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
g:netrw_fastbrowse = 0

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
