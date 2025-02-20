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
set spelllang+=en

set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000
set history=1000

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
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'ryanoasis/vim-devicons'
Plug 'sainnhe/everforest'
Plug 'wakatime/vim-wakatime'
Plug 'github/copilot.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug "rafamadriz/friendly-snippets"
Plug 'puremourning/vimspector'
Plug 'preservim/nerdtree'

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
g:airline#extensions#whitespace#checks = [ 'conflicts' ]

g:indentLine_setColors = 1
g:indentLine_char = '│'
g:gitgutter_use_location_list = 1
g:asyncomplete_matchfuzzy = 0
g:asyncomplete_min_chars = 1

au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! wa

g:NERDTreeQuitOnOpen = 1
g:NERDTreeWinSize = 50
g:NERDTreeShowHidden = 1

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
#g:lsp_log_verbose = 1
#g:lsp_log_file = '/tmp/lsp.log'


def GetCurrentTSPath(): any
  var ts_path = '/node_modules/typescript/lib'
  var project_dir = '/opt/homebrew/lib'
  var tsserverlibrary_path = project_dir .. ts_path
  return { 'tsdk': tsserverlibrary_path }
enddef

def GetWorkspaceRoot(fallback: string): any
  var cwd = getcwd()
  var root = cwd
  if isdirectory(cwd .. fallback)
    return 'file://' .. cwd .. fallback
  endif

  return 'file://' .. root
enddef

def GetRootUri(fallback: string): any
  return (server_info: any) => {
    return GetWorkspaceRoot(fallback)
  }
enddef

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'tsserver',
      \ 'root_uri': GetRootUri('/frontend'),
      \ 'cmd': ['typescript-language-server', '--stdio'],
      \ 'allowlist': ['vue', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
      \ 'initialization_options': {
      \   'semanticTokens': v:true,
      \   'usePlaceholders': v:true,
      \   plugins: [
      \     {'name': '@vue/typescript-plugin', 'location': '/opt/homebrew/bin/vue-language-server', 'languages': ['vue']}
      \   ]
      \ }
      \})
endif

if executable('vue-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'vue-language-server',
      \ 'root_uri': GetRootUri('/frontend'),
      \ 'cmd': ['vue-language-server', '--stdio'],
      \ 'allowlist': ['vue'],
      \ 'initialization_options': {
      \     'typescript': GetCurrentTSPath(),
      \     'vue': {
      \       'hybridMode': v:true
      \     }
      \ }
      \})
endif

if executable('gopls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'gopls',
      \ 'root_uri': GetRootUri('/backend'),
      \ 'cmd': ['gopls'],
      \ 'allowlist': ['go', 'gomod']
      \ })
endif

if executable('efm-langserver')
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'efm-langserver',
      \ 'root_uri': GetRootUri('/backend'),
      \ 'cmd': ['efm-langserver', '-c', expand('~/.config/efm-langserver/config.yaml')],
      \ 'allowlist': ['vim', 'markdown', 'yaml', 'javascript', 'typescript', 'vue', 'sh', 'go']
      \ })
endif

if executable('erlang_ls')
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'erlang',
      \ 'cmd': ['erlang_ls'],
      \ 'allowlist': ['erlang']
      \ })
endif

if executable('ruff')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ruff',
        \ 'cmd': ['ruff', 'server'],
        \ 'allowlist': ['python']
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


def FormatBECode()
  :silent LspDocumentFormatSync
  :silent LspCodeActionSync --ui=float source.organizeImports
enddef

def FormatWebCode()
  :silent LspDocumentFormatSync
enddef

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vim,vue nnoremap <space>D :LspDocumentDiagnostics<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vim,vue nnoremap <space>a :LspCodeAction --ui=float<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vim,vue nnoremap <space>t :LspDocumentSymbol<CR>

autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vue nmap <silent> K :LspHover --ui=float<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vue nmap <silent> gs :LspSignatureHelp<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vue nmap <silent> gd :LspDefinition<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vue nmap <silent> gy :LspTypeDefinition<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vue nmap <silent> gi :LspImplementation<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vue nmap <silent> gr :LspReferences<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vue nmap <silent> [g :LspPreviousDiagnostic<CR>
autocmd FileType javascript,typescript,javascriptreact,typescriptreact,go,python,vue nmap <silent> ]g :LspNextDiagnostic<CR>

nnoremap <space>dd :call vimspector#Launch()<CR>
nnoremap <space>de :call vimspector#Reset()<CR>
nnoremap <space>dc :call vimspector#Continue()<CR>

nnoremap <space>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <space>dT :call vimspector#ClearBreakpoints()<CR>

nmap <space>dk <Plug>VimspectorRestart
nmap <space>dh <Plug>VimspectorStepOut
nmap <space>dl <Plug>VimspectorStepInto
nmap <space>dj <Plug>VimspectorStepOver

autocmd BufWritePre *.go,*.py :call FormatBECode()
autocmd BufWritePre *.js,*.ts,*.vue,*.tsx,*.jsx :call FormatWebCode()

hi TrailingWhitespace ctermbg=DarkRed guibg=DarkRed
call matchadd("TrailingWhitespace", '\v\s+$')

inoremap <Nul> <C-x><C-o>

inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<C-g>u\<CR>"
inoremap <expr> <ESC> pumvisible() ? asyncomplete#close_popup() : "\<C-g>u\<ESC>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
imap <c-@> <Plug>(asyncomplete_force_refresh)

nnoremap <Left> <Nop>
vnoremap <Left> <Nop>
inoremap <Left> <Nop>

nnoremap <Right> <Nop>
vnoremap <Right> <Nop>
inoremap <Right> <Nop>

nnoremap <Up> <Nop>
vnoremap <Up> <Nop>
inoremap <Up> <Nop>

nnoremap <Down> <Nop>
vnoremap <Down> <Nop>
inoremap <Down> <Nop>

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
nnoremap <space>E :NERDTreeToggleVCS<CR>
nnoremap <space>e :NERDTreeToggle<CR>
nnoremap <space>n :set number! <bar> GitGutterSignsToggle<CR>

nnoremap <space>1 :e $MYVIMRC<CR>
nnoremap <space>2 :source $MYVIMRC<CR>
