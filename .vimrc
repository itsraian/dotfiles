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
set updatetime=100
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


let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
let &t_ti = "\e[?1004h"
let &t_te = "\e[?1004l"

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'puremourning/vimspector'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'rhysd/vim-healthcheck'
Plug 'sainnhe/sonokai'
Plug 'sheerun/vim-polyglot'
Plug 'wakatime/vim-wakatime'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'github/copilot.vim'
Plug 'jparise/vim-graphql'
Plug 'preservim/tagbar'
Plug 'prettier/vim-prettier', {
      \ 'do': 'yarn install --frozen-lockfile --production',
      \ 'branch': 'master'
      \ }

call plug#end()

let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
colorscheme sonokai

let g:go_highlight_array_whitespace_error=1
let g:go_highlight_chan_whitespace_error=1
let g:go_highlight_extra_types=1
let g:go_highlight_space_tab_error=1
let g:go_highlight_trailing_whitespace_error=1
let g:go_highlight_operators=1
let g:go_highlight_functions=1
let g:go_highlight_function_parameters=1
let g:go_highlight_function_calls=1
let g:go_highlight_fields=1
let g:go_highlight_types=1
let g:go_highlight_build_constraints=1
let g:go_highlight_string_spellcheck=1
let g:go_highlight_format_strings=1
let g:go_highlight_generate_tags=1
let g:go_highlight_variable_assignments=1
let g:go_highlight_variable_declarations=1


""" ==============
""" Airline
""" ==============

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline_powerline_fonts = 1
let g:airline_left_sep=' '
let g:airline_right_sep=' '
let g:airline_section_c = airline#section#create(['%{MyLspProgress()}'])

let g:indentLine_setColors = 0
let g:indentLine_char = '│'

""" ==============
""" Vim LSP
""" ==============

let g:lsp_work_done_progress_enabled = 1
function! MyLspProgress() abort
  let l:progress = lsp#get_progress()
  if empty(l:progress) | return '' | endif
  let l:progress = l:progress[len(l:progress) - 1]
  return l:progress['server'] . ': ' . l:progress['title']
endfunction

let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'} 
let g:lsp_diagnostics_signs_hint = {'text': '→'}
let g:lsp_document_code_action_signs_hint = {'text': '>'}
let g:lsp_document_code_action_signs_delay = 50
let g:lsp_use_native_client = 1
let g:lsp_use_event_queue = 1
let g:lsp_semantic_enabled = 1
let g:lsp_diagnostics_virtual_text_align = "right"
let g:lsp_inlay_hints_enabled = 0
let g:lsp_format_sync_timeout = 500
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

inoremap <expr> <cr>pumvisible() ? asyncomplete#close_popup() : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
imap <c-@> <Plug>(asyncomplete_force_refresh)

if executable('gopls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'allowlist': ['go'],
        \ 'initialization_options': {
        \  'staticcheck': v:true,
        \ },
        \ })
endif

if executable('typescript-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['javascript', 'javascriptreact', 'typescript', 'typescript.tsx', 'typescriptreact'],
        \ 'initialization_options': {
        \ },
        \ })
endif

if executable('vscode-eslint-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'eslint',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'vscode-eslint-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
        \ 'allowlist': ['javascript', 'javascriptreact', 'typescript', 'typescript.tsx', 'typescriptreact'],
        \ 'workspace_config': {
        \   'validate': 'on',
        \   'packageManager': 'npm',
        \   'useESLintClass': v:false,
        \   'experimental': {
        \     'useFlatConfig': v:false,
        \   },
        \   'codeActionOnSave': {'enable': v:false, 'mode': 'all' },
        \   'format': v:false,
        \   'quiet': v:false,
        \   'onIgnoredFiles': 'off',
        \   'options': {},
        \   'rulesCustomizations': [],
        \   'run': 'onType',
        \   'problems': { 'shortenToSingleLine': v:false },
        \   'nodePath': v:null,
        \   'workingDirectories': [{'mode': 'auto'}],
        \   'workspaceFolder': {
        \     'uri': lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json')),
        \   },
        \   'codeAction': {
        \     'disableRuleComment': {
        \       'enable': v:true,
        \       'location': 'separateLine',
        \     },
        \     'showDocumentation': {
        \       'enable': v:true,
        \     },
        \   },
        \ },
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <space>D :LspDocumentDiagnostics --buffers=*<CR>
  nnoremap <space>a :LspCodeAction --ui=float<CR>

  autocmd BufWritePre *.go
        \ call execute('LspDocumentFormatSync') |
        \ call execute('LspCodeActionSync source.organizeImports')
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

au FileType javascript,typescript,javascriptreact,typescriptreact au BufWritePre <buffer> :PrettierAsync
highlight lspReference ctermfg=white ctermbg=red 

au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! wa

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

nmap <leader>dc <Plug>VimspectorContinue
nmap <leader>dx <Plug>VimspectorStop
nmap <leader>ds <Plug>VimspectorRestart
nmap <leader>dp <Plug>VimspectorPause
nmap <leader>db <Plug>VimspectorToggleBreakpoint
nmap <leader>do <Plug>VimspectorStepOver
nmap <leader>di <Plug>VimspectorStepInto
